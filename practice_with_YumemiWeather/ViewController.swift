//
//  ViewController.swift
//  practice_with_YumemiWeather
//
//  Created by Kai Tanobe on 2021/09/13.
//

import UIKit
import YumemiWeather


class ViewController: UIViewController {
    
    private let imageView: UIImageView = UIImageView()
    
    private let miniTempLabel: UILabel = {
        let  label = UILabel()
        label.text = "--"
        label.textColor = .blue
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 22)
        label.frame.size = CGSize(width: 10.0, height: 10.0)
        return label
    }()
    
    private let maxTempLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.textColor = .red
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 22)
        label.frame.size = CGSize(width: 10.0, height: 10.0)
        return label
    }()
    
    private let reloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reload", for: UIControl.State.normal)
        button.setTitleColor(UIColor .blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: UIControl.State.normal)
        button.setTitleColor(UIColor .blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(imageView)
        view.addSubview(miniTempLabel)
        view.addSubview(maxTempLabel)
        view.addSubview(closeButton)
        view.addSubview(reloadButton)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //親viewと横方向の中心を同じにする
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        //親viewのサイズの半分に横のサイズを指定する
        imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        miniTempLabel.translatesAutoresizingMaskIntoConstraints = false
        miniTempLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4).isActive = true
        miniTempLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.5).isActive = true
        miniTempLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        
        maxTempLabel.translatesAutoresizingMaskIntoConstraints = false
        maxTempLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4).isActive = true
        maxTempLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.5).isActive = true
        maxTempLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        
        let labelHeight = miniTempLabel.frame.size.height
        print(labelHeight)
        imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -(labelHeight / 2)).isActive = true
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.5).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        closeButton.topAnchor.constraint(equalTo: miniTempLabel.bottomAnchor, constant: 80).isActive = true
        closeButton.addTarget(self, action: #selector(closeButtonPushed), for: .touchUpInside)
        
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        reloadButton.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.5).isActive = true
        reloadButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        reloadButton.topAnchor.constraint(equalTo: maxTempLabel.bottomAnchor, constant: 80).isActive = true
        reloadButton.addTarget(self, action: #selector(reloadButtonPushed), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchWeather()
    }
    
    @objc private func closeButtonPushed(sender: UIButton) {
        print("close")
    }
    
    @objc private func reloadButtonPushed(sender: UIButton) {
        fetchWeather()
    }
    
    
    private func fetchWeather() {
        let confirmAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        
        do {
            let respond = try YumemiWeather.fetchWeather(requestJson(Request.init(area: "tokyo", date: getNowTime())))
            let jsonData =  respond.data(using: String.Encoding.utf8)!
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            let weathers = try jsonDecoder.decode(Weather.self, from: jsonData)
            
            updateWeatherImage(weather: WeatherState(rawValue: weathers.weather)!)
            updateTemp(weathers: weathers)
        } catch YumemiWeatherError.invalidParameterError {
            print("invalidParameterErrorによるエラーです")
            showApiErrorAlert(title: "OKを押して下さい", message: "invalidParameterErrorによるエラーです", action: confirmAction)
        } catch YumemiWeatherError.unknownError {
            print("unknownErrorによるエラーです")
            showApiErrorAlert(title: "OKを押して下さい", message: "unknownErrorによるエラーです", action: confirmAction)
        } catch {
            print("その他のエラーです")
            showApiErrorAlert(title: "OKを押して下さい", message: "エラーです", action: confirmAction)
        }
    }
    
    private func showApiErrorAlert(title: String, message: String, action: UIAlertAction) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func updateWeatherImage(weather: WeatherState) {
        imageView.image = weather.image
        imageView.tintColor = weather.color
    }
    
    private func updateTemp(weathers: Weather) {
        maxTempLabel.text = String(weathers.maxTemp)
        miniTempLabel.text = String(weathers.minTemp)
    }
    
    private func requestJson(_ request : Request) -> String {
        let stringDate = stringFromDate(request.date)
        let reString = jsonRequest(jsonArea: request.area, jsonDate: stringDate)
        let encoder = JSONEncoder()
        guard let jsonValue = try? encoder.encode(reString) else {
            fatalError("Failed to encode to JSON.")
        }
        let jsonString = String(data: jsonValue, encoding: .utf8)!
        return jsonString
    }
    
    private func getNowTime() -> Date {
        return  Date()
    }
    
    private func stringFromDate(_ time: Date) -> String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: time)
    }
    
}

enum WeatherState: String {
    case sunny = "sunny"
    case rainy = "rainy"
    case cloudy = "cloudy"
}

extension WeatherState {
    var image: UIImage? {
        switch self {
        case .sunny:
            return UIImage(named: "sunny")
        case .cloudy:
            return UIImage(named: "cloudy")
        case .rainy:
            return UIImage(named: "rainy")
        }
    }
    
    var color: UIColor {
        switch self {
        case .sunny:
            return .orange
        case .cloudy:
            return .gray
        case .rainy:
            return .blue
        }
    }
}
