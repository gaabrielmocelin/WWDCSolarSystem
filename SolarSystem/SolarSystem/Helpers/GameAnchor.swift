//
//  GameAnchor.swift
//  SolarSystem
//
//  Created by Gabriel Mocelin on 22/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import ARKit

enum AnchorPosition: Int {
    case left
    case center
    case right
}

enum AnchorSide: Int{
    case spaceship
    case barriers
}

class GameAnchor: ARAnchor {
    var anchorPosition: AnchorPosition
    var anchorSide: AnchorSide
    
    init(transform: matrix_float4x4, anchorPosition: AnchorPosition, anchorSide: AnchorSide) {
        self.anchorSide = anchorSide
        self.anchorPosition = anchorPosition
        super.init(transform: transform)
    }
}
