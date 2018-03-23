//
//  GameView.swift
//  SolarSystem
//
//  Created by Gabriel Mocelin on 21/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

protocol GamePerformer {
    func didSwipe(_ direction: UISwipeGestureRecognizerDirection)
    func startGame()
}

class GameView: UIView {
    var myState: ControlState
    var stateDelegate: StateManager?
    var gameDelegate: GamePerformer?
    
    var label: UILabel!
    var startButton: UIButton!
    
    override init(frame: CGRect) {
        myState = .game
        super.init(frame: frame)
        setupLabel()
        setupButton()
        setupSwipes()
    }
    
    func setupButton() {
        startButton = UIButton(frame: CGRect())
        startButton.setTitle("Start", for: .normal)
        startButton.addTarget(self, action: #selector(handleStartButton), for: .touchUpInside)
        startButton.backgroundColor = #colorLiteral(red: 0.9860219359, green: 0.4115800261, blue: 0.3854584694, alpha: 1)
        startButton.layer.cornerRadius = 20
        startButton.clipsToBounds = true
        
        self.addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        startButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        startButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        startButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
    }
    
    @objc func handleStartButton(sender: UIButton) {
        gameDelegate?.startGame()
        startButton.isHidden = true
    }
    
    func setupLabel()  {
        label = UILabel()
        label.text = "The Game is RUNNING"
        label.textAlignment = .center
        label.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 100).isActive = true
        label.widthAnchor.constraint(equalToConstant: 300).isActive = true
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func setupSwipes() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(swipe:)))
        swipeLeft.direction = .left
        self.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(swipe:)))
        swipeRight.direction = .right
        self.addGestureRecognizer(swipeRight)
        
        //will we get swipe up?
//        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(swipe:)))
//        swipeUp.direction = .up
//        self.addGestureRecognizer(swipeUp)
    }
    
    @objc func handleSwipe(swipe: UISwipeGestureRecognizer) {
        gameDelegate?.didSwipe(swipe.direction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GameView: OverLay{
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
