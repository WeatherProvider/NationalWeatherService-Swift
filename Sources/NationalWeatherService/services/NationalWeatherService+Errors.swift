//
//  NationalWeatherService+Errors.swift
//  NationalWeatherService
//
//  Created by Alan Chu on 4/5/20.
//

import Foundation

extension NationalWeatherService {
    public enum APIError: Error {
        /// This error occurs when you request data not within the boundries of a National Weather Service office (i.e. not within the United States)
        case invalidPoint(APIErrorDetails)
        case other(APIErrorDetails)
        case unknownError

        public var localizedDescription: String {
            switch self {
            case .invalidPoint: return "Data Unavailable For Requested Point."
            case .other(let details): return details.detail
            case .unknownError: return "Unknown Error"
            }
        }
    }

    public struct APIErrorDetails: Decodable {
        public let title: String
        public let type: URL
        public let status: Int
        public let detail: String

        public var isInvalidPoint: Bool {
            return type.lastPathComponent == "InvalidPoint"
        }
    }
}
