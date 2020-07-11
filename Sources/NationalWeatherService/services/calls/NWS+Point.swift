//
//  File.swift
//  
//
//  Created by Alan Chu on 7/11/20.
//

import CoreLocation

extension NationalWeatherService {
    public typealias PointHandler = (Result<Point, Error>) -> Void

    public func loadPoint(for coordinate: CLLocationCoordinate2D, then handler: @escaping PointHandler) {
        let url = NationalWeatherService.BaseURL
            .appendingPathComponent("points")
            .appendingPathComponent("\(coordinate.latitude),\(coordinate.longitude)")

        self.load(at: url, as: Point.self, then: handler)
    }

    // MARK: - Sugar
    fileprivate func loadPoint(at url: URL, then handler: @escaping PointHandler) {
        self.load(at: url, as: Point.self, then: handler)
    }

    public func loadPoint(for location: CLLocation, then handler: @escaping PointHandler) {
        return self.loadPoint(for: location.coordinate, then: handler)
    }
}
