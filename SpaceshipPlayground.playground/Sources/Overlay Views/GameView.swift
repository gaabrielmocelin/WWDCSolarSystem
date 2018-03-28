//
//  GameView.swift
//  SolarSystem
//
//  Created by Gabriel Mocelin on 21/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

public protocol GamePerformer {
    func didSwipe(_ direction: UISwipeGestureRecognizerDirection)
    func startGame()
}

public class GameView: UIView {
    public var myState: ControlState
    public var stateDelegate: StateManager?
    public var gameDelegate: GamePerformer?
    
    var scoreView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        return view
    }()
    
    var label: UILabel!
    var startButton: UIButton!
    
    var score: Int
    var scoreTimer: Timer?
    
   public  override init(frame: CGRect) {
        myState = .game
        score = 0
        super.init(frame: frame)
        setupScoreView()
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
        triggerTimer()
    }
    
    func triggerTimer() {
        scoreTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateScore), userInfo: nil, repeats: true)
    }
    
    @objc func updateScore() {
        score += 1
        DispatchQueue.main.async {
            self.label.text = "\(self.score)"
        }
    }
    
    func setupScoreView()  {
        self.addSubview(scoreView)
        scoreView.translatesAutoresizingMaskIntoConstraints = false
        scoreView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        scoreView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        scoreView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        scoreView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        label = UILabel()
        label.text = "0"
        label.textAlignment = .center
        
        scoreView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: scoreView.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: scoreView.trailingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: scoreView.bottomAnchor, constant: -5).isActive = true
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupSwipes() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(swipe:)))
        swipeLeft.direction = .left
        self.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(swipe:)))
        swipeRight.direction = .right
        self.addGestureRecognizer(swipeRight)
    }
    
    @objc func handleSwipe(swipe: UISwipeGestureRecognizer) {
        gameDelegate?.didSwipe(swipe.direction)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GameView: GameOverDelegate{
    public func gameIsOver() {
        scoreTimer?.invalidate()
        stateDelegate?.nextState(currentState: myState)
    }
}

extension GameView: OverLay{
   public  func hide() {
        fadeOut()
    }
    
    public func show() {
        fadeIn()
    }
}
