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

    private let geoJSONDecoder = MKGeoJSONDecoder()
    private let decoder: JSONDecoder = {
        let _decoder = JSONDecoder()
        _decoder.dateDecodingStrategy = .iso8601

        return _decoder
    }()

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
                do {
                    handler(.success(try self.geoJSONDecoder.decode(data)))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }

        task.resume()
    }

    public func loadForecast(at url: URL, then handler: @escaping ForecastHandler) {
        self.loadNWS(at: url) { result in
            switch result {
            case .success(let objects):
                let feature = objects.compactMap { $0 as? MKGeoJSONFeature }.first!
                let properties = feature.properties!

                do {
                    handler(.success(try self.decoder.decode(Forecast.self, from: properties)))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
