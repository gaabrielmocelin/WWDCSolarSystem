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
    func CompleteGame()
}

public class GameView: UIView {
    public var myState: ControlState
    public var stateDelegate: StateManager?
    public var gameDelegate: GamePerformer?
    
    public var gameWasCompleted = false
    
    var scoreView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ScoreView.png")
        return view
    }()
    var scoreLabel: UILabel!
    
    var backgroundWarningView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "BackgroundGameView.png")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    var warningLabel: UITextView = {
        let label = UITextView()
        label.text = "Look at the ship and tap anywhere when you are ready to play"
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.font = Fonts.shared.boldFont(withSize: 20)
        return label
    }()
    
    var swipeTutorialView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "SwipeTutorial.png")
        view.contentMode = .scaleAspectFit
        view.alpha = 0
        return view
    }()
    
    var score: Int
    var scoreTimer: Timer?
    
    var isGameRunning = false
    
    public  override init(frame: CGRect) {
        myState = .game
        score = 0
        super.init(frame: frame)
        setupScoreView()
        setupSwipes()
        setupWarningView()
        setupTutorial()
    }
    
    func setupTutorial() {
        self.addSubview(swipeTutorialView)
        swipeTutorialView.translatesAutoresizingMaskIntoConstraints = false
        swipeTutorialView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        swipeTutorialView.topAnchor.constraint(equalTo: scoreView.bottomAnchor, constant: 30).isActive = true
        swipeTutorialView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        swipeTutorialView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        swipeTutorialView.fadeIn()
        
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.swipeTutorialView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: nil)
    }
    
    func setupWarningView() {
        self.addSubview(backgroundWarningView)
        backgroundWarningView.translatesAutoresizingMaskIntoConstraints = false
        backgroundWarningView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        backgroundWarningView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 5).isActive = true
        backgroundWarningView.heightAnchor.constraint(equalToConstant: 123).isActive = true
        backgroundWarningView.widthAnchor.constraint(equalToConstant: 577).isActive = true
        
        backgroundWarningView.addSubview(warningLabel)
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        warningLabel.topAnchor.constraint(equalTo: backgroundWarningView.topAnchor, constant: 45).isActive = true
        warningLabel.bottomAnchor.constraint(equalTo: backgroundWarningView.bottomAnchor).isActive = true
        warningLabel.leadingAnchor.constraint(equalTo: backgroundWarningView.leadingAnchor, constant: 40).isActive = true
        warningLabel.trailingAnchor.constraint(equalTo: backgroundWarningView.trailingAnchor, constant: -40).isActive = true
    }
    
    fileprivate func startedGame() {
        if !isGameRunning{
            gameDelegate?.startGame()
            backgroundWarningView.fadeOut()
            triggerTimer()
            isGameRunning = true
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        startedGame()
    }
    
    func triggerTimer() {
        scoreTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateScore), userInfo: nil, repeats: true)
    }
    
    @objc func updateScore() {
        score += 1000
        DispatchQueue.main.async {
            self.scoreLabel.text = "\(self.score)"
        }
        
        if score == 200000{
            gameDelegate?.CompleteGame()
            scoreView.fadeOut()
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
        scoreLabel.font = Fonts.shared.boldFont(withSize: 24)
        
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
        startedGame()
        
        gameDelegate?.didSwipe(swipe.direction)
        
        if swipeTutorialView.alpha == 1{
            swipeTutorialView.fadeOut(completion: { (_) in
                self.swipeTutorialView.layer.removeAllAnimations()
            })
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GameView: GameFinishedDelegate{
    public func gameIsOver() {
        scoreTimer?.invalidate()
        stateDelegate?.nextState(currentState: myState)
    }
    
    public func gameIsCompleted() {
        gameWasCompleted = true
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

