//
//  OverLayProtocol.swift
//  SolarSystem
//
//  Created by Gabriel Mocelin on 20/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

public protocol OverLay: class {
    var myState: ControlState { get }
    var stateDelegate: StateManager? { get set }
    
    func hide()
    func show()
}

public enum ControlState: String{
    case welcome
    case solarSystem
    case gameHistory
    case game
    case gameOver
}

public protocol StateManager{
    func nextState(currentState: ControlState)
}
