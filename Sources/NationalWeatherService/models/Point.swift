//
//  Point.swift
//  NationalWeatherService
//
//  Created by Alan Chu on 4/2/20.
//

import Foundation

public struct Point: Decodable {
    public let cwa: String
    public let gridX: Int
    public let gridY: Int

    public let pathToForecast: URL
    public let pathToHourlyForecast: URL
    
    public let relativeLocation: String // GeoJSON
    public let timeZone: String
    public let radarStation: String
}
