//
//  OverLayProtocol.swift
//  SolarSystem
//
//  Created by Gabriel Mocelin on 20/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

protocol OverLay where Self: UIView {
    var myState: ControlState { get }
    
    func hide()
    func show()
}

enum ControlState: String{
    case welcome
    case solarSystem
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
}

protocol StateManager{
    func nextState(currentState: ControlState)
}
