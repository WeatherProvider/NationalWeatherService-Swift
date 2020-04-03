//
//  Forecast.swift
//  NationalWeatherService
//
//  Created by Alan Chu on 4/2/20.
//

import Foundation

public struct Forecast: Decodable {
    public let updated: Date
    public let generatedAt: Date
//    public let elevation: UnitLength
    public let periods: [Period]
}
