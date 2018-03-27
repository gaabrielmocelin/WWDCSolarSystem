//
//  IntroduceSolarSystemView.swift
//  SolarSystem
//
//  Created by Gabriel Mocelin on 20/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

class IntroduceSolarSystemView: UIView {
    var myState: ControlState
    
    var stateDelegate: StateManager?
    
    var nextButton: UIButton = {
        let button = UIButton(frame: CGRect())
        button.setTitle("Next", for: .normal)
        button.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 0.9860219359, green: 0.4115800261, blue: 0.3854584694, alpha: 1)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        return button
    }()
    
    var exploreView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        return view
    }()
    
    var exploreLabel: UILabel = {
        let label = UILabel()
        label.text = "Explore the solar system"
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        myState = .solarSystem

        super.init(frame: frame)
        
        setupExploreView()
        setupButton()
        alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupExploreView() {
        self.addSubview(exploreView)
        exploreView.translatesAutoresizingMaskIntoConstraints = false
        exploreView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        exploreView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        exploreView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        exploreView.widthAnchor.constraint(equalToConstant: 350).isActive = true
        
        exploreView.addSubview(exploreLabel)
        exploreLabel.translatesAutoresizingMaskIntoConstraints = false
        exploreLabel.topAnchor.constraint(equalTo: exploreView.topAnchor).isActive = true
        exploreLabel.bottomAnchor.constraint(equalTo: exploreView.bottomAnchor).isActive = true
        exploreLabel.leadingAnchor.constraint(equalTo: exploreView.leadingAnchor).isActive = true
        exploreLabel.trailingAnchor.constraint(equalTo: exploreView.trailingAnchor).isActive = true
    }
    
    func setupButton() {
        self.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    @objc func handleNextButton(sender: UIButton) {
        stateDelegate?.nextState(currentState: myState)
    }
        
}

extension IntroduceSolarSystemView: OverLay {
    
    func hide() {
        fadeOut()
    }
    
    func show() {
        fadeIn()
    }
}
