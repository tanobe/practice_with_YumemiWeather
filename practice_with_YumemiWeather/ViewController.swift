//
//  ViewController.swift
//  practice_with_YumemiWeather
//
//  Created by Kai Tanobe on 2021/09/13.
//

import UIKit
import YumemiWeather


class catchWeather {
    func fetchWeather() -> String {
        let weather = YumemiWeather.fetchWeather()
        return weather
    }
}

class ViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let weather = catchWeather().fetchWeather()
        let imageView = UIImageView(image: UIImage(named: weather))
        let state = WeatherState(rawValue: weather)
        imageView.tintColor = state?.color
        return imageView
    }()
    
    private let leftLabel: UILabel = {
        let  label = UILabel()
        label.text = "--"
        label.textColor = .blue
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 8)
        label.frame.size = CGSize(width: 10.0, height: 10.0)
        return label
    }()
    
    private let rightLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.textColor = .red
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 8)
        label.frame.size = CGSize(width: 10.0, height: 10.0)
        return label
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reload", for: UIControl.State.normal)
        button.setTitleColor(UIColor .blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    private let leftButton: UIButton = {
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
        view.addSubview(leftLabel)
        view.addSubview(rightLabel)
        view.addSubview(leftButton)
        view.addSubview(rightButton)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //親viewと横方向の中心を同じにする
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        //親viewのサイズの半分に横のサイズを指定する
        imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        leftLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4).isActive = true
        leftLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.5).isActive = true
        leftLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4).isActive = true
        rightLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.5).isActive = true
        rightLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        
        let labelHeight = leftLabel.frame.size.height
        print(labelHeight)
        imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -(labelHeight / 2)).isActive = true
        
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.5).isActive = true
        leftButton.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        leftButton.topAnchor.constraint(equalTo: leftLabel.bottomAnchor, constant: 80).isActive = true
        leftButton.addTarget(self, action: #selector(leftButtonPushed), for: .touchUpInside)
        
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.5).isActive = true
        rightButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        rightButton.topAnchor.constraint(equalTo: rightLabel.bottomAnchor, constant: 80).isActive = true
        rightButton.addTarget(self, action: #selector(rightButtonPushed), for: .touchUpInside)
        
    }
    @objc private func leftButtonPushed(sender: UIButton) {
        print("close")
    }
    
    @objc private func rightButtonPushed(sender: UIButton) {
        fetchWeatherStateFunc()
    }
    
    func fetchWeatherStateFunc() {
        let weather = catchWeather().fetchWeather()
        let state = WeatherState(rawValue: weather)
        imageView.image = state?.image
        imageView.tintColor = state?.color
        print(weather)
    }
}

enum WeatherState: String {
    case sunny = "sunny"
    case rainy = "rainy";
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
}

extension WeatherState {
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
