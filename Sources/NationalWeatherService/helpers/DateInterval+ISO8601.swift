//
//  DateInterval+ISO8601.swift
//  NationalWeatherService
//
//  Created by Alan Chu on 4/11/20.
//

import Foundation

extension DateInterval {
    static func iso8601Interval(from iso8601Duration: String,
                                using iso8601Formatter: ISO8601DateFormatter = ISO8601DateFormatter(),
                                in calendar: Calendar = .current) -> DateInterval? {
        var split = iso8601Duration.split(separator: "/")

        guard split.count == 2,
              let durationValue = split.popLast(),
              let startTime = iso8601Formatter.date(from: String(split.popLast() ?? "")),
              let duration = try? DateComponents(ISO8601String: String(durationValue)),
              let endTime = calendar.date(byAdding: duration, to: startTime) else { return nil }

        return DateInterval(start: startTime, end: endTime)
    }
}
