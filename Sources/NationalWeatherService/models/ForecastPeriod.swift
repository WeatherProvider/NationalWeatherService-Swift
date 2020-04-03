//
//  ForecastPeriod.swift
//  NationalWeatherService
//
//  Created by Alan Chu on 4/2/20.
//

import Foundation

extension Forecast {
    public struct Period: Decodable {
        public enum CodingKeys: String, CodingKey {
            case name, startTime, endTime, isDaytime
            case temperature, temperatureUnit, windSpeed, windDirection
            case shortForecast, detailedForecast
        }

        public let name: String?
        public let date: DateInterval
        public let isDaytime: Bool

        public let temperature: Measurement<UnitTemperature>
        public let windSpeed: Measurement<UnitSpeed>
        public let windDirection: String?

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

            // TODO: The API may return a wind speed range at times (e.g. `10 to 20 mph` instead of `10 mph`).
            let windSpeedComponents = try container.decode(String.self, forKey: .windSpeed).split(separator: " ")
            let windSpeedValue = Double(windSpeedComponents[0]) ?? 0
            let windSpeedUnitRaw = String(windSpeedComponents[1])

            let windSpeedUnit: UnitSpeed = windSpeedUnitRaw == "mph" ? .milesPerHour : .kilometersPerHour
            self.windSpeed = Measurement(value: windSpeedValue, unit: windSpeedUnit)

            self.windDirection = try container.decodeIfPresent(String.self, forKey: .windDirection)

            self.shortForecast = try container.decode(String.self, forKey: .shortForecast)
            self.detailedForecast = try container.decode(String.self, forKey: .detailedForecast)
        }
    }
}
