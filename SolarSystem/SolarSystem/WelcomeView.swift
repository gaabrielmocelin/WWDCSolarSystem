//
//  WelcomeViewController.swift
//  SolarSystem
//
//  Created by Gabriel Mocelin on 20/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

class WelcomeView: UIView {
    var myState: ControlState
    
    var text: UITextView!
    var readyButton: UIButton!
    
    var delegate: StateManager?

    override init(frame: CGRect) {
        self.myState = .welcome
        
        super.init(frame: frame)
        setupBackgroundBlur()
        setupTextField()
        setupReadyButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBackgroundBlur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
    
    func setupTextField() {
        text = UITextView(frame: CGRect())
        text.text = "Welcome to my playground, here you gonna use ARkit, so be sure you are in a good place to test it. Press ready to continue"
        text.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        text.backgroundColor = UIColor.clear
        
        self.addSubview(text)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.heightAnchor.constraint(equalToConstant: 300).isActive = true
        text.widthAnchor.constraint(equalToConstant: 300).isActive = true
        text.topAnchor.constraint(equalTo: self.topAnchor, constant: 100).isActive = true
        text.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50).isActive = true
    }
    
    func setupReadyButton() {
        readyButton = UIButton(frame: CGRect())
        readyButton.setTitle("I'm Ready", for: .normal)
        readyButton.addTarget(self, action: #selector(handleReadyButton), for: .touchUpInside)
        readyButton.backgroundColor = #colorLiteral(red: 0.9860219359, green: 0.4115800261, blue: 0.3854584694, alpha: 1)
        readyButton.layer.cornerRadius = 30
        readyButton.clipsToBounds = true
        
        self.addSubview(readyButton)
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        readyButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        readyButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        readyButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        readyButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
    }
    
    @objc func handleReadyButton() {
        fadeOut { (bool) in
            self.delegate?.nextState(currentState: self.myState)
        }
    }
}

extension WelcomeView: OverLay{
    func hide() {
        fadeOut()
    }
    
    func show() {
        fadeIn()
    }
}
