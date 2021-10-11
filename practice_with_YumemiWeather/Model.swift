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


struct jsonRequest: Codable {
    var jsonArea: String
    var jsonDate: String
    
    
    enum CodingKeys: String, CodingKey {
        case jsonArea = "area"
        case jsonDate = "date"
    }
}
