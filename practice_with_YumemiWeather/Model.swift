//
//  Model.swift
//  practice_with_YumemiWeather
//
//  Created by Kai Tanobe on 2021/10/06.
//

import Foundation

struct Request: Codable {
    var area: String
    var date: Date
}

struct Weather: Codable {
    var maxTemp: Int
    var date: String
    var minTemp: Int
    var weather: String
}

enum WeatherErrors: Error {
    case invalid
    case unknown
    case ecodeError
    case decodeError
    case other
}


extension WeatherErrors {
    var message: String {
        switch self {
        case .invalid:
            return "invalidParameterErrorによるエラーです。"
        case .unknown:
            return "invalidParameterErrorによるエラーです。"
        case .ecodeError:
            return "ecodeErrorによるエラーです。"
        case .decodeError:
            return "decodeErrorによるエラーです。"
        case .other:
            return "その他によるエラーです。"
        }
    }
}
