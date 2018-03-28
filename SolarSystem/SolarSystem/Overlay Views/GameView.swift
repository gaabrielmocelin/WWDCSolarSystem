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
    
    var scoreView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "art.scnassets/ScoreView.png")
        return view
    }()
    
    var scoreLabel: UILabel!
    
    var startLabel: UILabel = {
        var label = UILabel()
        label.text = "Tap to play"
        label.textAlignment = .center
        label.textColor = UIColor(red: 34/255, green: 136/255, blue: 221/255, alpha: 1)
        return label
    }()
    
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
        self.addSubview(startLabel)
        startLabel.translatesAutoresizingMaskIntoConstraints = false
        startLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        startLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        startLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        startLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.startLabel.alpha = 0
        }, completion: nil)
    }
    
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        gameDelegate?.startGame()
        startLabel.isHidden = true
        triggerTimer()
    }
    
    func triggerTimer() {
        scoreTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateScore), userInfo: nil, repeats: true)
    }
    
    @objc func updateScore() {
        score += 1
        DispatchQueue.main.async {
            self.scoreLabel.text = "\(self.score)"
        }
    }
    
    func setupScoreView()  {
        self.addSubview(scoreView)
        scoreView.translatesAutoresizingMaskIntoConstraints = false
        scoreView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        scoreView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        scoreView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        scoreView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        scoreLabel = UILabel()
        scoreLabel.textColor = UIColor.white
        scoreLabel.text = "0"
        scoreLabel.textAlignment = .center
        
        scoreView.addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.leadingAnchor.constraint(equalTo: scoreView.leadingAnchor).isActive = true
        scoreLabel.trailingAnchor.constraint(equalTo: scoreView.trailingAnchor).isActive = true
        scoreLabel.bottomAnchor.constraint(equalTo: scoreView.bottomAnchor, constant: -5).isActive = true
        scoreLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
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
