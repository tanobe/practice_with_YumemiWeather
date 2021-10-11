//
//  Model.swift
//  practice_with_YumemiWeather
//
//  Created by Kai Tanobe on 2021/10/06.
//

import Foundation

struct Request: Codable {
    var area: String
    var date: String
}

struct Weather: Codable {
    var maxTemp: Int
    var date: String
    var minTemp: Int
    var weather: String
}

