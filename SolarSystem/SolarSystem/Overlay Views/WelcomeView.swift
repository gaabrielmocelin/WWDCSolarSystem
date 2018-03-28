//
//  WelcomeViewController.swift
//  SolarSystem
//
//  Created by Gabriel Mocelin on 20/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

public class WelcomeView: UIView {
    public var myState: ControlState
    
    var welcomeView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        return view
    }()
    
    var descriptionText: UITextView = {
        let textView = UITextView()
        textView.text = "For the best experience be sure you are in a well-lit area."
        textView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        textView.textAlignment = .center
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    
    var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to my playground"
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    var readyButton: UIButton = {
        let button = UIButton(frame: CGRect())
        button.setTitle("I'm Ready", for: .normal)
        button.addTarget(self, action: #selector(handleReadyButton), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 0.9860219359, green: 0.4115800261, blue: 0.3854584694, alpha: 1)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        return button
    }()
    
    var trackingLabel: UILabel = {
        let label = UILabel()
        label.text = "Tracking State"
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    var trackingState: UILabel = {
        let label = UILabel()
        label.text = "GOOD"
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    public var stateDelegate: StateManager?

    public override init(frame: CGRect) {
        self.myState = .welcome
        
        super.init(frame: frame)
        setupBackgroundBlur()
        setupReadyButton()
        setupWelcomeView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWelcomeView() {
        
        self.addSubview(welcomeView)
        welcomeView.translatesAutoresizingMaskIntoConstraints = false
        welcomeView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        welcomeView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -30).isActive = true
        welcomeView.heightAnchor.constraint(equalToConstant: 280).isActive = true
        welcomeView.widthAnchor.constraint(equalToConstant: 350).isActive = true
        
        
        welcomeView.addSubview(welcomeLabel)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.centerXAnchor.constraint(equalTo: welcomeView.centerXAnchor).isActive = true
        welcomeLabel.widthAnchor.constraint(equalTo: welcomeView.widthAnchor, constant: 0).isActive = true
        welcomeLabel.topAnchor.constraint(equalTo: welcomeView.topAnchor, constant: 20).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        welcomeView.addSubview(descriptionText)
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        descriptionText.centerXAnchor.constraint(equalTo: welcomeView.centerXAnchor).isActive = true
        descriptionText.widthAnchor.constraint(equalTo: welcomeView.widthAnchor, constant: 0).isActive = true
        descriptionText.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20).isActive = true
        descriptionText.heightAnchor.constraint(equalToConstant: 20).isActive = true
       
        let separatorLine = UIView()
        separatorLine.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        welcomeView.addSubview(separatorLine)
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.centerXAnchor.constraint(equalTo: welcomeView.centerXAnchor).isActive = true
        separatorLine.topAnchor.constraint(equalTo: descriptionText.bottomAnchor, constant: 30).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 3).isActive = true
        separatorLine.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        welcomeView.addSubview(trackingLabel)
        trackingLabel.translatesAutoresizingMaskIntoConstraints = false
        trackingLabel.centerXAnchor.constraint(equalTo: welcomeView.centerXAnchor).isActive = true
        trackingLabel.widthAnchor.constraint(equalTo: welcomeView.widthAnchor, constant: 0).isActive = true
        trackingLabel.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 20).isActive = true
        trackingLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        welcomeView.addSubview(trackingState)
        trackingState.translatesAutoresizingMaskIntoConstraints = false
        trackingState.centerXAnchor.constraint(equalTo: welcomeView.centerXAnchor).isActive = true
        trackingState.widthAnchor.constraint(equalTo: welcomeView.widthAnchor, constant: 0).isActive = true
        trackingState.topAnchor.constraint(equalTo: trackingLabel.bottomAnchor, constant: 20).isActive = true
        trackingState.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setupBackgroundBlur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
    
    func setupTextField() {
        self.addSubview(descriptionText)
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        descriptionText.heightAnchor.constraint(equalToConstant: 300).isActive = true
        descriptionText.widthAnchor.constraint(equalToConstant: 300).isActive = true
        descriptionText.topAnchor.constraint(equalTo: self.topAnchor, constant: 100).isActive = true
        descriptionText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50).isActive = true
    }
    
    func setupReadyButton() {
        self.addSubview(readyButton)
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        readyButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        readyButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        readyButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        readyButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    @objc func handleReadyButton() {
        fadeOut { (bool) in
            self.stateDelegate?.nextState(currentState: self.myState)
        }
    }
}

extension WelcomeView: OverLay{
    public func hide() {
        fadeOut()
    }
    
    public func show() {
        fadeIn()
    }
}
