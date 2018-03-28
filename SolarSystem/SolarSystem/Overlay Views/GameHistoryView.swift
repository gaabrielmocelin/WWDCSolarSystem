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
    
    var label: UITextView!
    var labelCenterYAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        myState = .gameHistory
        
        super.init(frame: frame)
        
        setupLabel()
    }
    
    func setupLabel()  {
        label = UITextView()
        label.text = """
        this is where i tell the game history,
        bkabalbak blabla bla blablablabla bla blablabla
        blabla bla blabla bla bla "
        """
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.backgroundColor = UIColor.clear
        
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 200).isActive = true
        label.widthAnchor.constraint(equalToConstant: 300).isActive = true
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        labelCenterYAnchor =  label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 200)
        labelCenterYAnchor!.isActive  = true
    }
    
    func tellHistory()  {
        UIView.animate(withDuration: 30, animations: {
            self.labelCenterYAnchor?.isActive = false
            self.label.bottomAnchor.constraint(equalTo: self.topAnchor).isActive = true
            self.layoutIfNeeded()
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
//                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (_) in
//                        self.stateDelegate?.nextState(currentState: self.myState)
//                    }
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
