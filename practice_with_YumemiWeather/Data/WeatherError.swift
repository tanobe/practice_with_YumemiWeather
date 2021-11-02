//
//  WeatherError.swift
//  practice_with_YumemiWeather
//
//  Created by Kai Tanobe on 2021/11/02.
//

import Foundation

enum WeatherError: Error {
    case invalid
    case unknown
    case encodeError
    case decodeError
    case other
}

extension WeatherError {
    var message: String {
        switch self {
        case .invalid:
            return "invalidParameterErrorによるエラーです。"
        case .unknown:
            return "unknownParameterErrorによるエラーです。"
        case .encodeError:
            return "ecodeErrorによるエラーです。"
        case .decodeError:
            return "decodeErrorによるエラーです。"
        case .other:
            return "その他によるエラーです。"
        }
    }
}
