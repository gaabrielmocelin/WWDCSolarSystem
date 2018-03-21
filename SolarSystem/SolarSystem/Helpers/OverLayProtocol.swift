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
    case game
    case gameOver
}

protocol StateManager{
    func nextState(currentState: ControlState)
}
