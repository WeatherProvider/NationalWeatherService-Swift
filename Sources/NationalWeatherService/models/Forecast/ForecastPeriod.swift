//
//  ForecastPeriod.swift
//  NationalWeatherService
//
//  Created by Alan Chu on 4/2/20.
//

import Foundation

extension Forecast {
    public struct Period: Decodable, Identifiable {
        public enum CodingKeys: String, CodingKey {
            case name, startTime, endTime, isDaytime
            case temperature, temperatureUnit, windSpeed, windDirection
            case icon, shortForecast, detailedForecast
        }

        public let id = UUID()
        public let name: String?
        public let date: DateInterval
        public let isDaytime: Bool

        public let temperature: Measurement<UnitTemperature>
        public let windSpeed: Wind

        public let conditions: [Condition]
        public let icon: URL
        public let shortForecast: String
        public let detailedForecast: String?

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.name = try container.decodeIfPresent(String.self, forKey: .name)

            let startTime = try container.decode(Date.self, forKey: .startTime)
            let endTime = try container.decode(Date.self, forKey: .endTime)

            self.date = DateInterval(start: startTime, end: endTime)
            self.isDaytime = try container.decode(Bool.self, forKey: .isDaytime)

            let temperatureValue = try container.decode(Double.self, forKey: .temperature)
            let temperatureUnitRaw = try container.decode(String.self, forKey: .temperatureUnit).lowercased()
            let temperatureUnit: UnitTemperature = temperatureUnitRaw == "f" ? .fahrenheit : .celsius

            self.temperature = Measurement(value: temperatureValue, unit: temperatureUnit)

            let windSpeedValue = try container.decode(String.self, forKey: .windSpeed)
            let windDirection = try container.decodeIfPresent(String.self, forKey: .windDirection) ?? ""
            self.windSpeed = try Wind(from: windSpeedValue, direction: windDirection)

            self.icon = try container.decode(URL.self, forKey: .icon)
            self.conditions = Condition.parseFrom(nwsAPIIconURL: self.icon)

            self.shortForecast = try container.decode(String.self, forKey: .shortForecast)
            self.detailedForecast = try container.decode(String.self, forKey: .detailedForecast)
        }
    }
}
