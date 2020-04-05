//
//  NationalWeatherService.swift
//  NationalWeatherService
//
//  Created by Alan Chu on 4/2/20.
//


import MapKit

public struct NationalWeatherService {
    // Definitions
    public typealias GeoJSONHandler = (Result<[MKGeoJSONObject], Error>) -> Void
    public typealias ForecastHandler = (Result<Forecast, Error>) -> Void
    public typealias PointHandler = (Result<Point, Error>) -> Void

    private let geoJSONDecoder = MKGeoJSONDecoder()
    private let decoder: JSONDecoder = {
        let _decoder = JSONDecoder()
        _decoder.dateDecodingStrategy = .iso8601

        return _decoder
    }()

    public static let BaseURL: URL = URL(string: "https://api.weather.gov/")!

    let session: URLSession = URLSession(configuration: .ephemeral)

    let userAgent: String

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
                if let geoJSON = try? self.geoJSONDecoder.decode(data) {
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
            case .success(let objects):
                let feature = objects.compactMap { $0 as? MKGeoJSONFeature }.first!
                let properties = feature.properties!

                do {
                    handler(.success(try self.decoder.decode(type, from: properties)))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }

    public func loadForecast(at url: URL, then handler: @escaping ForecastHandler) {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "units", value: "us")
        ]

        self.load(at: components.url!, as: Forecast.self, then: handler)
    }

    public func loadPoint(at url: URL, then handler: @escaping PointHandler) {
        self.load(at: url, as: Point.self, then: handler)
    }
}
