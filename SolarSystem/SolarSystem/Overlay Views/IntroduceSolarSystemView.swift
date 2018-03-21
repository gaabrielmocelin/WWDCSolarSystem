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
    
    var nextButton = UIButton()
    
    override init(frame: CGRect) {
        myState = .solarSystem

        super.init(frame: frame)
        
        setupButton()
        alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButton() {
        nextButton = UIButton(frame: CGRect())
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        nextButton.backgroundColor = #colorLiteral(red: 0.9860219359, green: 0.4115800261, blue: 0.3854584694, alpha: 1)
        nextButton.layer.cornerRadius = 20
        nextButton.clipsToBounds = true

        self.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        nextButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true

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
