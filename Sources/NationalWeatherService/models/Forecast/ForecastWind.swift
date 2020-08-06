//
//  WindSpeed.swift
//  NationalWeatherService
//
//  Created by Alan Chu on 4/2/20.
//

import Foundation

extension Forecast {
    public enum WindDirection: String {
        case n, nne, ne, ene, e, ese, se, sse, s, ssw, sw, wsw, w, wnw, nw, nnw
        case none = "N/A"
    }

    public enum Wind: /*CustomStringConvertible,*/ Equatable {
        case single(Measurement<UnitSpeed>, direction: WindDirection)
        case range(lhs: Measurement<UnitSpeed>, rhs: Measurement<UnitSpeed>, direction: WindDirection)

        /// A structured model for wind forecasts.
        ///
        /// ## Example Accepted Formats
        /// - `10 mph`
        /// - `10 to 20 mph`
        /// - `10 - 20 mph`
        /// - `15 km/h`
        /// - `15` (parses as 15 km/h)
        /// - `15 - 25` (parses as 15 - 25 km/h)
        ///
        /// - parameter windText: Text to parse into forecasted wind data. If `mph` is the suffix,
        /// then the speed unit will be miles per hour. Otherwise, it will use kilometers per hour.
        /// - parameter direction: Text representing wind direction to parse into `WindDirection`.
        public init(from windText: String, direction: String) throws {
            let unit: UnitSpeed = windText.lowercased().hasSuffix("mph") ? .milesPerHour : .kilometersPerHour
            let split = windText.split(separator: " ")

            let windDirection = WindDirection(rawValue: direction.lowercased()) ?? .none

            // weather.gov API uses the "to" keyword.
            if windText.contains("to") || windText.contains("-") {
                let lhsString = split[0]
                let rhsString = split[2]

                guard let lhsValue = Double(lhsString) else {
                    throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "lhs parsing expected a Double. Actual value: \(lhsString)"))
                }

                guard let rhsValue = Double(rhsString) else {
                    throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "rhs parsing expected a Double. Actual value: \(rhsString)"))
                }

                self = .range(lhs: Measurement(value: lhsValue, unit: unit),
                              rhs: Measurement(value: rhsValue, unit: unit),
                              direction: windDirection)
            } else {
                let valueString = split[0]
                guard let value = Double(valueString) else {
                    throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Parsing expected a Double. Actual value: \(valueString)"))
                }

                self = .single(Measurement(value: value, unit: unit), direction: windDirection)
            }
        }

//        public var description: String {
//            func formatSpeed(_ measurement: Measurement<UnitSpeed>) -> String {
//                let mph = measurement.converted(to: .milesPerHour)
//                return "\(mph.value) mph"
//            }
//
//            switch self {
//            case .single(let speed, let direction):
//                return formatSpeed(speed) + " (\(direction))".uppercased()
//            case .range(let lhs, let rhs, let direction):
//                let directionText = "(\(direction))".uppercased()
//                return "\(formatSpeed(lhs)) - \(formatSpeed(rhs)) \(directionText)"
//            }
//        }
    }
}
