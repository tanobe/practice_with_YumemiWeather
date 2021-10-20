//
//  ViewController.swift
//  practice_with_YumemiWeather
//
//  Created by Kai Tanobe on 2021/09/13.
//

import UIKit
import YumemiWeather


class WeatherViewController: UIViewController {
    
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
        
        view.backgroundColor = .white
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadButtonPushed), name: .notifyName, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleWeather(result: fetchWeather())
    }
    
    override func viewDidLayoutSubviews() {
        let labelHeight = miniTempLabel.frame.size.height
        imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -(labelHeight / 2)).isActive = true
    }
    
    @objc private func closeButtonPushed(sender: UIButton) {
        print("close")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func reloadButtonPushed(sender: UIButton) {
        handleWeather(result: fetchWeather())
    }
    
    private func fetchWeather() -> Result<Weather, WeatherError> {
        do {
            guard let requestJson = try? request("tokyo", Date()) else {
                return .failure(WeatherError.encodeError)
            }
            let weather = try YumemiWeather.fetchWeather(requestJson)
            guard let response = try? response(from: weather) else {
                return .failure(WeatherError.decodeError)
            }
            return .success(response)
            
        } catch YumemiWeatherError.invalidParameterError {
            return .failure(.invalid)
        } catch YumemiWeatherError.unknownError {
            return .failure(.unknown)
        } catch {
            return .failure(.other)
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
    
    private func updateTemp(weather: Weather) {
        maxTempLabel.text = String(weather.maxTemp)
        miniTempLabel.text = String(weather.minTemp)
    }
    
    private func request(_ area: String, _ date: Date) throws -> String {
        let request = Request(area: area, date: date)
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let jsonValue = try? encoder.encode(request) else {
            throw WeatherError.encodeError
        }
        let jsonString = String(data: jsonValue, encoding: .utf8)!
        return jsonString
    }

    private func response(from jsonString: String) throws -> Weather {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let json = jsonString.data(using: .utf8)!
        guard let jsonData = try? decoder.decode(Weather.self,from: json) else {
            throw WeatherError.decodeError
        }
        return jsonData
    }
    
    private func handleWeather(result: Result<Weather, WeatherError>) {
        switch result {
        case let .success(weather):
            updateWeatherImage(weather: WeatherState(rawValue: weather.weather)!)
            updateTemp(weather: weather)
        case let .failure(error):
            let confirmAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            showApiErrorAlert(title: "Error", message: error.message, action: confirmAction)
        }
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
