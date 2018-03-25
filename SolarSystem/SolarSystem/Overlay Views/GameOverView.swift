//
//  GameOverView.swift
//  SolarSystem
//
//  Created by Gabriel Mocelin on 21/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

class GameOverView: UIView {
    var myState: ControlState
    var stateDelegate: StateManager?
    
    var label: UILabel!
    var restartButton: UIButton!
    
    override init(frame: CGRect) {
        myState = .gameOver
        
        super.init(frame: frame)
        
        setupLabel()
        setupButton()
    }
    
    func setupButton() {
        restartButton = UIButton(frame: CGRect())
        restartButton.setTitle("Start", for: .normal)
        restartButton.addTarget(self, action: #selector(handleRestartButton), for: .touchUpInside)
        restartButton.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        restartButton.layer.cornerRadius = 20
        restartButton.clipsToBounds = true
        
        self.addSubview(restartButton)
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        restartButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        restartButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        restartButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        restartButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
    }
    
    @objc func handleRestartButton(sender: UIButton) {
        stateDelegate?.nextState(currentState: myState)
    }
    
    func setupLabel()  {
        label = UILabel()
        label.text = "GAMEOVER"
        label.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 200).isActive = true
        label.widthAnchor.constraint(equalToConstant: 300).isActive = true
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GameOverView: OverLay{
    func hide() {
        fadeOut()
    }
    
    func show() {
        fadeIn()
//        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (_) in
//            self.stateDelegate?.nextState(currentState: self.myState)
//        }
    }
}
