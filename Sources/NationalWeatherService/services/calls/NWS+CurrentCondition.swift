//
//  File.swift
//  
//
//  Created by Alan Chu on 7/11/20.
//

import Foundation

extension NationalWeatherService {
    public typealias CurrentConditionHandler = (Result<Forecast.Period, Error>) -> Void

    /// Gets the current weather for the given location.
    public func currentCondition(latitude: Double, longitude: Double, then handler: @escaping CurrentConditionHandler) {
        self.forecast(latitude: latitude, longitude: longitude) { result in
            switch result {
            case .success(let forecast):
                let now = Date()
                let period = forecast.periods
                    .filter { $0.date.contains(now) }
                    .sorted { $0.date > $1.date }
                    .first

                if let period = period {
                    handler(.success(period))
                } else {
                    handler(.failure(NationalWeatherService.APIError.unknownError))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}

#if canImport(CoreLocation)
import CoreLocation

extension NationalWeatherService {
    /// Gets the current weather for the given location.
    public func currentCondition(for coordinates: CLLocationCoordinate2D, then handler: @escaping CurrentConditionHandler) {
        self.currentCondition(latitude: coordinates.latitude, longitude: coordinates.longitude, then: handler)
    }

    /// Gets the current weather for the given location.
    public func currentCondition(for location: CLLocation, then handler: @escaping CurrentConditionHandler) {
        self.currentCondition(for: location.coordinate, then: handler)
    }
}
#endif
