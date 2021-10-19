//
//  Roote.swift
//  practice_with_YumemiWeather
//
//  Created by Kai Tanobe on 2021/10/15.
//

import UIKit

class RootViewController: UIViewController {
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: UIControl.State.normal)
        button.setTitleColor(UIColor .blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.dismiss(animated: true, completion: nil)
        print("viewWillAppearが呼ばれたよ")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let vc = WeatherViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}
