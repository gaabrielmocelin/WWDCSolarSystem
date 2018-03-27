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
    var labelBottomAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        myState = .gameHistory
        
        super.init(frame: frame)
        
        setupLabel()
    }
    
    func setupLabel()  {
        label = UILabel()
        label.text = """
        this is where i tell the game history,
        bkabalbak blabla bla blablablabla bla blablabla
        blabla bla blabla bla bla "
        """
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 200).isActive = true
        label.widthAnchor.constraint(equalToConstant: 300).isActive = true
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        labelBottomAnchor =  label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 300)
        labelBottomAnchor!.isActive  = true
    }
    
    func tellHistory()  {
        UIView.animate(withDuration: 10, animations: {
            self.labelBottomAnchor?.constant = -500
        }) { (bool) in
            print("acabou")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GameHistoryView: EndOfTheSystemDelegate{
    func didBeginTheEndOfSystem() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 2, animations: {
                self.backgroundColor = UIColor.black
            }, completion: { (bool) in
                if bool{
                    self.tellHistory()
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (_) in
                        self.stateDelegate?.nextState(currentState: self.myState)
                    }
                }
            })
            
        }
    }
}

extension GameHistoryView: OverLay{
    func hide() {
        fadeOut()
    }
    
    func show() {
        fadeIn()
    }
}
