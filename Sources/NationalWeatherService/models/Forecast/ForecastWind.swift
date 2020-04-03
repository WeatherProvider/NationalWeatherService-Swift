//
//  WindSpeed.swift
//  NationalWeatherService
//
//  Created by Alan Chu on 4/2/20.
//

import Foundation

extension Forecast {
    public enum Wind: CustomStringConvertible {
        case single(Measurement<UnitSpeed>, direction: String)
        case range(lhs: Measurement<UnitSpeed>, rhs: Measurement<UnitSpeed>, direction: String)

        public init(from windText: String, direction: String) throws {
            let split = windText.split(separator: " ")

            guard let unitString = split.last, !unitString.isEmpty else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Expected a speed unit string but found an empty String instead."))
            }

            let unit: UnitSpeed = unitString == "mph" ? .milesPerHour : .kilometersPerHour

            if windText.contains("to") {
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
                              direction: direction)
            } else {
                let valueString = split[0]
                guard let value = Double(valueString) else {
                    throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Parsing expected a Double. Actual value: \(valueString)"))
                }

                self = .single(Measurement(value: value, unit: unit), direction: direction)
            }
        }

        public var description: String {
            let formatter = MeasurementFormatter()
            switch self {
            case .single(let speed, let direction):
                return formatter.string(from: speed) + " (\(direction))"
            case .range(let lhs, let rhs, let direction):
                return formatter.string(from: lhs) + " - " + formatter.string(from: rhs) + " (\(direction))"
            }
        }
    }
}
