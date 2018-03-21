//
//  GameHistory.swift
//  SolarSystem
//
//  Created by Gabriel Mocelin on 21/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

class GameHistoryView: UIView {
    var myState: ControlState
    var stateDelegate: StateManager?
    
    var label: UILabel!
    
    override init(frame: CGRect) {
        myState = .gameHistory
        
        super.init(frame: frame)
        
        setupLabel()
    }
    
    func setupLabel()  {
        label = UILabel()
        label.text = "this is where i tell the game history"
        label.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
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

extension GameHistoryView: OverLay{
    func hide() {
        fadeOut()
    }
    
    func show() {
        fadeIn()
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (_) in
            self.stateDelegate?.nextState(currentState: self.myState)
        }
    }
}
