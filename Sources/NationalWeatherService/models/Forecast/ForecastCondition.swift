//
//  ForecastCondition.swift
//  NationalWeatherService
//
//  Created by Alan Chu on 4/2/20.
//

import Foundation

extension Forecast {
    public typealias Condition = Icon
}

extension Icon {
    public static func parseFrom(nwsAPIIconURL url: URL) -> [Icon] {
        guard let lastPathComponent = url.pathComponents.last, !lastPathComponent.isEmpty else {
            return [.other]
        }

        let conditionDetails = lastPathComponent.split(separator: "/")
        return conditionDetails.compactMap { return self.init(rawValue: String($0.split(separator: ",")[0])) ?? nil }
    }
}
