//
//  NationalWeatherService+CLLocatino.swift
//  NationalWeatherService
//
//  Created by Alan Chu on 4/5/20.
//

import CoreLocation

extension NationalWeatherService {
    public func loadPoint(for location: CLLocation, then handler: @escaping PointHandler) {
        return self.loadPoint(for: location.coordinate, then: handler)
    }

    public func loadPoint(for coordinate: CLLocationCoordinate2D, then handler: @escaping PointHandler) {
        let url = NationalWeatherService.BaseURL
            .appendingPathComponent("points")
            .appendingPathComponent("\(coordinate.latitude),\(coordinate.longitude)")

        self.load(at: url, as: Point.self, then: handler)
    }

//    public func forecast(for location: CLLocation, then handler: @escaping ForecastHandler) -> ForecastHandler {
//        
//    }
}
