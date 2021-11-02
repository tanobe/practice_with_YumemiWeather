//
//  s.swift
//  practice_with_YumemiWeather
//
//  Created by Kai Tanobe on 2021/10/31.
//

import Foundation
import UIKit
import YumemiWeather


protocol WeatherViewDelegate: AnyObject {
    func didFetchWeatherUpdateTemp(weather: Weather)
    func didFetchWeathershowApiErrorAlert(title: String, message: String, action: UIAlertAction)
    func didFetchWeatherupdateWeatherImage(weather: WeatherState)
}

class WeatherModel {
    
    weak var delegate: WeatherViewDelegate?
    
    func fetchWeather(completion: @escaping (Result<Weather, WeatherError>) -> Void) {
        DispatchQueue.global().async {
            do {
                guard let requestJson = try? self.request("tokyo", Date()) else {
                    return completion(.failure(WeatherError.encodeError))
                }
                let weather = try YumemiWeather.syncFetchWeather(requestJson)
                guard let response = try? self.response(from: weather) else {
                    return completion(.failure(WeatherError.decodeError))
                }
                return completion(.success(response))
                
            } catch YumemiWeatherError.invalidParameterError {
                return completion(.failure(.invalid))
            } catch YumemiWeatherError.unknownError {
                return completion(.failure(.unknown))
            } catch {
                return completion(.failure(.other))
            }
        }
    }
    
    func request(_ area: String, _ date: Date) throws -> String {
        let request = Request(area: area, date: date)
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let jsonValue = try? encoder.encode(request) else {
            throw WeatherError.encodeError
        }
        let jsonString = String(data: jsonValue, encoding: .utf8)!
        return jsonString
    }

    func response(from jsonString: String) throws -> Weather {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let json = jsonString.data(using: .utf8)!
        guard let jsonData = try? decoder.decode(Weather.self,from: json) else {
            throw WeatherError.decodeError
        }
        return jsonData
    }
    
    
    func handleWeather(result: Result<Weather, WeatherError>) {
        switch result {
        case let .success(weather):
            delegate?.didFetchWeatherupdateWeatherImage(weather: WeatherState(rawValue: weather.weather)!)
            delegate?.didFetchWeatherUpdateTemp(weather: weather)
        case let .failure(error):
            let confirmAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            delegate?.didFetchWeathershowApiErrorAlert(title: "Error", message: error.message, action: confirmAction)
        }
    }
}
