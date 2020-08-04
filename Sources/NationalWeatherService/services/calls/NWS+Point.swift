//
//  File.swift
//  
//
//  Created by Alan Chu on 7/11/20.
//

import Foundation

extension NationalWeatherService {
    public typealias PointHandler = (Result<Point, Error>) -> Void

    public func loadPoint(latitude: Double, longitude: Double, then handler: @escaping PointHandler) {
        let url = NationalWeatherService.BaseURL
            .appendingPathComponent("points")
            .appendingPathComponent("\(latitude),\(longitude)")

        self.load(at: url, as: Point.self, then: handler)
    }
}

#if canImport(CoreLocation)
import CoreLocation

extension NationalWeatherService {
    public func loadPoint(for coordinate: CLLocationCoordinate2D, then handler: @escaping PointHandler) {
        self.loadPoint(latitude: coordinate.latitude, longitude: coordinate.longitude, then: handler)
    }

    public func loadPoint(for location: CLLocation, then handler: @escaping PointHandler) {
        self.loadPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, then: handler)
    }
}
#endif
