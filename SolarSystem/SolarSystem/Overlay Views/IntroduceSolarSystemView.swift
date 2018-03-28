//
//  IntroduceSolarSystemView.swift
//  SolarSystem
//
//  Created by Gabriel Mocelin on 20/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

class IntroduceSolarSystemView: UIView {
    public var myState: ControlState
    
    public var stateDelegate: StateManager?
    
    var nextButton: UIButton = {
        let button = UIButton(frame: CGRect())
        button.setTitle("Next", for: .normal)
        button.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        button.setBackgroundImage(UIImage(named: "art.scnassets/Button.png"), for: .normal)
        return button
    }()
    
    var exploreView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "art.scnassets/BackgroundExplore.png")
        return view
    }()
    
    var exploreLabel: UILabel = {
        let label = UILabel()
        label.text = "Explore the solar system"
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    public override init(frame: CGRect) {
        myState = .solarSystem

        super.init(frame: frame)
        
        setupExploreView()
        setupButton()
        alpha = 0
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupExploreView() {
        self.addSubview(exploreView)
        exploreView.translatesAutoresizingMaskIntoConstraints = false
        exploreView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        exploreView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        exploreView.heightAnchor.constraint(equalToConstant: 123).isActive = true
        exploreView.widthAnchor.constraint(equalToConstant: 577).isActive = true
        
        exploreView.addSubview(exploreLabel)
        exploreLabel.translatesAutoresizingMaskIntoConstraints = false
        exploreLabel.topAnchor.constraint(equalTo: exploreView.topAnchor).isActive = true
        exploreLabel.bottomAnchor.constraint(equalTo: exploreView.bottomAnchor, constant: -10).isActive = true
        exploreLabel.leadingAnchor.constraint(equalTo: exploreView.leadingAnchor).isActive = true
        exploreLabel.trailingAnchor.constraint(equalTo: exploreView.trailingAnchor).isActive = true
    }
    
    func setupButton() {
        self.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.heightAnchor.constraint(equalToConstant: 73).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 207).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    @objc func handleNextButton(sender: UIButton) {
        stateDelegate?.nextState(currentState: myState)
    }
        
}

extension IntroduceSolarSystemView: OverLay {
    
    public func hide() {
        fadeOut()
    }
    
    public func show() {
        fadeIn()
    }
}
