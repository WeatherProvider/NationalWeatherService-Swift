//
//  File.swift
//  
//
//  Created by Alan Chu on 7/11/20.
//

import Foundation
import NationalWeatherService

fileprivate var userAgent: String {
    guard let contact = ProcessInfo.processInfo.environment["NWS_AGENT_CONTACT"],
        !contact.isEmpty else {
            fatalError("You must specify a NWS_AGENT_CONTACT environment variable for unit testing.")
    }

    return "(NationalWeatherService-SwiftPackage-UnitTests, \(contact))"
}

public let nws = NationalWeatherService(userAgent: userAgent)
