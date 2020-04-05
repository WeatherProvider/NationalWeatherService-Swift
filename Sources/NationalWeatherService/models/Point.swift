//
//  Point.swift
//  NationalWeatherService
//
//  Created by Alan Chu on 4/2/20.
//

import Foundation
import MapKit

public struct Point: Decodable {
    public enum CodingKeys: String, CodingKey {
        case cwa, gridX, gridY, forecast, forecastHourly, relativeLocation, timeZone, radarStation
    }
    public let cwa: String
    public let gridX: Int
    public let gridY: Int

    public let forecast: URL
    public let forecastHourly: URL

//    public let relativeLocation: MKGeoJSONFeature
    
    public let timeZone: String
    public let radarStation: String

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.cwa = try container.decode(String.self, forKey: .cwa)
        self.gridX = try container.decode(Int.self, forKey: .gridX)
        self.gridY = try container.decode(Int.self, forKey: .gridY)

        self.forecast = try container.decode(URL.self, forKey: .forecast)
        self.forecastHourly = try container.decode(URL.self, forKey: .forecastHourly)

//        let timeZoneName = try container.decode(String.self, forKey: .timeZone)
//        guard let timeZone = TimeZone(identifier: timeZoneName) else {
//            throw NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid time zone."])
//        }
//        self.timeZone = try container.decode(TimeZone.self, forKey: .timeZone)
        self.timeZone = try container.decode(String.self, forKey: .timeZone)

        self.radarStation = try container.decode(String.self, forKey: .radarStation)
    }
}
