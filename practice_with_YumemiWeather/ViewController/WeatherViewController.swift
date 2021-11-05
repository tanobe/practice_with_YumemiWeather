//
//  ViewController.swift
//  practice_with_YumemiWeather
//
//  Created by Kai Tanobe on 2021/09/13.
//

import UIKit
import YumemiWeather


class WeatherViewController: UIViewController {
    
    var model = WeatherModel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        model.delegate = self
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification,
                                               object: nil,
                                               queue: nil) { [weak self] _ in
            guard let self = self else {
                return
            }
            self.loadWeather()
        }
    }
    
    deinit {
        print(#function)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = UIImageView()
    
    let miniTempLabel: UILabel = {
        let  label = UILabel()
        label.text = "--"
        label.textColor = .blue
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()
    
    let maxTempLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.textColor = .red
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()
    
    let reloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reload", for: UIControl.State.normal)
        button.setTitleColor(UIColor .blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: UIControl.State.normal)
        button.setTitleColor(UIColor .blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let inidecator = UIActivityIndicatorView()
        inidecator.style = .large
        inidecator.color = .purple
        return inidecator
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        let container = UIView()
        
        container.addSubview(imageView)
        container.addSubview(miniTempLabel)
        container.addSubview(maxTempLabel)
        
        view.addSubview(container)
        view.addSubview(activityIndicator)
        view.addSubview(closeButton)
        view.addSubview(reloadButton)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        container.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        miniTempLabel.translatesAutoresizingMaskIntoConstraints = false
        miniTempLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4).isActive = true
        miniTempLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        miniTempLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
        maxTempLabel.translatesAutoresizingMaskIntoConstraints = false
        maxTempLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4).isActive = true
        maxTempLabel.leadingAnchor.constraint(equalTo: miniTempLabel.trailingAnchor).isActive = true
        maxTempLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        maxTempLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        maxTempLabel.widthAnchor.constraint(equalTo: miniTempLabel.widthAnchor).isActive = true
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 80).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        closeButton.addTarget(self, action: #selector(closeButtonPushed), for: .touchUpInside)
        
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        reloadButton.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 80).isActive = true
        reloadButton.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        reloadButton.leadingAnchor.constraint(equalTo: closeButton.trailingAnchor).isActive = true
        reloadButton.widthAnchor.constraint(equalTo: closeButton.widthAnchor).isActive = true
        reloadButton.addTarget(self, action: #selector(reloadButtonPushed), for: .touchUpInside)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 10).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadWeather()
    }
    
    @objc private func closeButtonPushed(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func reloadButtonPushed(sender: UIButton) {
        loadWeather()
    }
    
    private func loadWeather() {
        self.activityIndicator.startAnimating()
        self.model.fetchAndHandleWeather()
    }
    
    func updateTemp(weather: Weather) {
        maxTempLabel.text = String(weather.maxTemp)
        miniTempLabel.text = String(weather.minTemp)
    }
    
    func updateWeatherImage(weather: WeatherState) {
        imageView.image = weather.image
        imageView.tintColor = weather.color
    }
}

extension WeatherViewController: WeatherViewDelegate {
    func handleWeatherFailuredShowApiErrorAlert(title: String, message: String, action: UIAlertAction) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func handleWeatherSuccessedUpdateWeatherImageAndTemp(weather: Weather) {
        self.updateWeatherImage(weather: WeatherState(rawValue: weather.weather)!)
        self.updateTemp(weather: weather)
    }
    
    func fetchAndHandleWeatherDidStopActivityIndicator() {
        self.activityIndicator.stopAnimating()
    }
}
