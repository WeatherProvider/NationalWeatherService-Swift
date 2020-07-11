//
//  File.swift
//  
//
//  Created by Alan Chu on 7/11/20.
//

import CoreLocation

extension NationalWeatherService {
    public typealias ForecastHandler = (Result<Forecast, Error>) -> Void

    fileprivate func loadForecast(at url: URL, then handler: @escaping ForecastHandler) {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "units", value: "si")
        ]

        self.load(at: components.url!, as: Forecast.self, then: handler)
    }

    public func forecast(for coordinates: CLLocationCoordinate2D, then handler: @escaping ForecastHandler) {
        self.loadPoint(for: coordinates, then: { pointResult in
            // TODO: this is ugly
            switch pointResult {
            case .success(let point):
                self.loadForecast(at: point.forecast, then: handler)
            case .failure(let error):
                handler(.failure(error))
            }
        })
    }

    public func forecast(for location: CLLocation, then handler: @escaping ForecastHandler) {
        self.forecast(for: location.coordinate, then: handler)
    }

    public func hourlyForecast(for coordinates: CLLocationCoordinate2D, then handler: @escaping ForecastHandler) {
        self.loadPoint(for: coordinates, then: { pointResult in
            // TODO: this is ugly
            switch pointResult {
            case .success(let point):
                self.loadForecast(at: point.forecastHourly, then: handler)
            case .failure(let error):
                handler(.failure(error))
            }
        })
    }

    public func hourlyForecast(for location: CLLocation, then handler: @escaping ForecastHandler) {
        self.hourlyForecast(for: location.coordinate, then: handler)
    }
}
