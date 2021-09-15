//
//  ViewController.swift
//  practice_with_YumemiWeather
//
//  Created by Kai Tanobe on 2021/09/13.
//

import UIKit

class ViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "sample_image"))
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        return imageView
    }()
    
    private let leftLabel: UILabel = {
        let  leftLabel = UILabel()
        leftLabel.text = "--"
        leftLabel.textColor = UIColor.blue
        leftLabel.textAlignment = NSTextAlignment.center
        leftLabel.font = UIFont.systemFont(ofSize: 8)
        return leftLabel
    }()
    
    private let rightLabel: UILabel = {
        let rightLabel = UILabel()
        rightLabel.text = "--"
        rightLabel.textColor = UIColor.red
        rightLabel.textAlignment = NSTextAlignment.center
        rightLabel.font = UIFont.systemFont(ofSize: 8)
        return rightLabel
    }()
    
    private let rightButton: UIButton = {
        let rightButton = UIButton()
        rightButton.setTitle("Reload", for: UIControl.State.normal)
        rightButton.setTitleColor(UIColor .blue, for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return rightButton
    }()
    
    private let leftButton: UIButton = {
        let leftButton = UIButton()
        leftButton.setTitle("Close", for: UIControl.State.normal)
        leftButton.setTitleColor(UIColor .blue, for: .normal)
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return leftButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        
        let labelHeight = leftLabel.frame.size.height
        imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -(labelHeight / 2)).isActive = true
        //親viewと横方向の中心を同じにする
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        //親viewのサイズの半分に横のサイズを指定する
        imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        let imageViewSize = imageView.frame.size.width
        
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(leftLabel)
        leftLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4).isActive = true
        leftLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.5).isActive = true
        leftLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(rightLabel)
        rightLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4).isActive = true
        rightLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.5).isActive = true
        rightLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(leftButton)
        leftButton.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.5).isActive = true
        leftButton.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        leftButton.topAnchor.constraint(equalTo: leftLabel.bottomAnchor, constant: 80).isActive = true
        leftButton.addTarget(self, action: #selector(leftButtonPush), for: .touchUpInside)
        
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(rightButton)
        rightButton.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.5).isActive = true
        rightButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        rightButton.topAnchor.constraint(equalTo: rightLabel.bottomAnchor, constant: 80).isActive = true
        rightButton.addTarget(self, action: #selector(rightButtonPush), for: .touchUpInside)
        
    }
    @objc func leftButtonPush(sender: UIButton) {
        print("close")
    }
    
    @objc func rightButtonPush(sender: UIButton) {
        print("Reload")
    }
}

