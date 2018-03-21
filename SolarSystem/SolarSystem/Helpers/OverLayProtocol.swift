//
//  OverLayProtocol.swift
//  SolarSystem
//
//  Created by Gabriel Mocelin on 20/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

protocol OverLay: class {
    var myState: ControlState { get }
    var stateDelegate: StateManager? { get set }
    
    func hide()
    func show()
}

enum ControlState: String{
    case welcome
    case solarSystem
    case gameHistory
}

extension UIView {
    func fadeIn(completion: ((Bool) ->Void)? = nil) {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(completion: ((Bool) ->Void)? = nil) {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    func addSubviewWithSameAnchors(_ view: UIView) {
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
    }
}

protocol StateManager{
    func nextState(currentState: ControlState)
}
