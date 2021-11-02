//
//  Weather.swift
//  practice_with_YumemiWeather
//
//  Created by Kai Tanobe on 2021/11/02.
//

import Foundation

struct Weather: Codable {
    var maxTemp: Int
    var date: String
    var minTemp: Int
    var weather: String
}
