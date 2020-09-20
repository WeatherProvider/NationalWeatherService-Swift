//
//  NationalWeatherService.swift
//  NationalWeatherService
//
//  Created by Alan Chu on 4/2/20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import GEOSwift

public class NationalWeatherService {
    // Definitions
    public typealias GeoJSONHandler = (Result<GeoJSON, Error>) -> Void

    /// The name of the environment variable for reading the user agent.
    public static let UserAgentEnvironmentVariableKey = "NATIONAL_WEATHER_SERVICE_USER_AGENT"

    private let decoder: JSONDecoder = {
        let _decoder = JSONDecoder()
        _decoder.dateDecodingStrategy = .iso8601

        return _decoder
    }()

    public static let BaseURL: URL = URL(string: "https://api.weather.gov/")!

    let session: URLSession = URLSession(configuration: .ephemeral)

    let userAgent: String

    /// Initializes using the environment variable as the user agent. If you do not want to use an environment variable, use `init(userAgent:_)` instead.
    ///
    /// A User Agent is required to identify your application. This string should be contact information (e.g. website or email) in case of a security event.
    /// See [weather.gov reference](https://www.weather.gov/documentation/services-web-api).
    /// Example string: `"(myweatherapp.com, contact@myweatherapp.com)"`
    /// - precondition: Environment variable `NATIONAL_WEATHER_SERVICE_USER_AGENT` is not an empty String.
    public init() {
        guard let userAgent = ProcessInfo.processInfo.environment[NationalWeatherService.UserAgentEnvironmentVariableKey] else {
            preconditionFailure("Missing \"\(NationalWeatherService.UserAgentEnvironmentVariableKey)\" environment variable. Use `init(userAgent:_)` if you do not want to specify environment variable.")
        }

        self.init(userAgent: userAgent)
    }

    /// - parameter userAgent: A User Agent is required to identify your application. This string should be contact information (e.g. website or email) in case of a security event. See [weather.gov reference](https://www.weather.gov/documentation/services-web-api). Example string: `"(myweatherapp.com, contact@myweatherapp.com)"`
    /// - precondition: `userAgent` is not an empty String.
    public init(userAgent: String) {
        precondition(!userAgent.isEmpty, "User Agent cannot be empty per weather.gov guidelines.")
        self.userAgent = userAgent
    }

    public func loadNWS(at url: URL, then handler: @escaping GeoJSONHandler) {
        var request = URLRequest(url: url)
        request.addValue(userAgent, forHTTPHeaderField: "User-Agent")
        request.addValue("application/geo+json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: request) { result in
            switch result {
            case .success(let data):
                if let geoJSON = try? self.decoder.decode(GeoJSON.self, from: data) {
                    handler(.success(geoJSON))
                } else if let errorDetails = try? self.decoder.decode(APIErrorDetails.self, from: data) {
                    if errorDetails.isInvalidPoint {
                        handler(.failure(APIError.invalidPoint(errorDetails)))
                    } else {
                        handler(.failure(APIError.other(errorDetails)))
                    }
                } else {
                    handler(.failure(APIError.unknownError))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }

        task.resume()
    }

    public func load<T: Decodable>(at url: URL,
                                   as type: T.Type,
                                   then handler: @escaping (Result<T, Error>) -> Void) {
        self.loadNWS(at: url) { result in
            switch result {
            case .success(let object):
                if case let .feature(feature) = object,
                   let featureProperties = feature.untypedProperties {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: featureProperties, options: [])
                        handler(.success(try self.decoder.decode(type, from: data)))
                    } catch {
                        handler(.failure(error))
                    }
                } else {
                    handler(.failure(APIError.unknownError))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
