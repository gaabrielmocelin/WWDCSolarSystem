//
//  GameOverView.swift
//  SolarSystem
//
//  Created by Gabriel Mocelin on 21/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

public class GameOverView: UIView {
    public var myState: ControlState
    public var stateDelegate: StateManager?
    
    var scoreLabel: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    var gameOverLabel: UILabel = {
        var label = UILabel()
        label.text = "GAME OVER"
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    var backgroundImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "art.scnassets/BackgroundGameover.png")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    var restartButton: UIButton = {
        let button = UIButton(frame: CGRect())
        button.setTitle("Play Again", for: .normal)
        button.addTarget(self, action: #selector(handleRestartButton), for: .touchUpInside)
        button.setBackgroundImage(UIImage(named: "art.scnassets/Button.png"), for: .normal)
        return button
    }()
    
    var score: Int?{
        didSet{
            updateScoreLabel()
        }
    }
    
    public override init(frame: CGRect) {
        myState = .gameOver
        
        super.init(frame: frame)
        
        setupGameOver()
        setupButton()
    }
    
    func setupGameOver() {
        self.addSubview(backgroundImage)
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        backgroundImage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -30).isActive = true
        backgroundImage.heightAnchor.constraint(equalToConstant: 294).isActive = true
        backgroundImage.widthAnchor.constraint(equalToConstant: 628).isActive = true
        
        setupGameOverLabel()
        setupScoreLabel()
    }
    
    func setupGameOverLabel()  {
        backgroundImage.addSubview(gameOverLabel)
        gameOverLabel.translatesAutoresizingMaskIntoConstraints = false
        gameOverLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        gameOverLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        gameOverLabel.centerXAnchor.constraint(equalTo: backgroundImage.centerXAnchor).isActive = true
        gameOverLabel.centerYAnchor.constraint(equalTo: backgroundImage.centerYAnchor, constant: 25).isActive = true
    }
    
    func updateScoreLabel() {
        guard let score = score else { return }
        DispatchQueue.main.async {
            self.scoreLabel.text = "Your score was: \(score)"
        }
    }
    
    func setupScoreLabel()  {
        backgroundImage.addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        scoreLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        scoreLabel.centerXAnchor.constraint(equalTo: backgroundImage.centerXAnchor).isActive = true
        scoreLabel.centerYAnchor.constraint(equalTo: backgroundImage.centerYAnchor, constant: -25).isActive = true
    }
    
    func setupButton() {
        self.addSubview(restartButton)
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        restartButton.heightAnchor.constraint(equalToConstant: 73).isActive = true
        restartButton.widthAnchor.constraint(equalToConstant: 207).isActive = true
        restartButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true
        restartButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    @objc func handleRestartButton(sender: UIButton) {
        stateDelegate?.nextState(currentState: myState)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gameCompleted() {
        DispatchQueue.main.async {
            self.scoreLabel.text = "You have saved the humanity"
            self.gameOverLabel.text = "CONGRATULATIONS"
        }
    }
}

extension GameOverView: OverLay{
    public func hide() {
        fadeOut()
    }
    
    public func show() {
        fadeIn()
    }
}
