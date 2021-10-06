//
//  Model.swift
//  practice_with_YumemiWeather
//
//  Created by Kai Tanobe on 2021/10/06.
//

import Foundation

struct Request: Encodable, Decodable {
    var area: String
    var date: String
}

struct Weather: Decodable {
    var max_temp: Int
    var date: String
    var min_temp: Int
    var weather: String
}

