//
//  Planet.swift
//  SolarSystem
//
//  Created by Gabriel Mocelin on 17/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import SceneKit

enum BodyName: String{
    case sun
    case mercury
    case venus
    case earth
    case mars
    case jupiter
    case saturn
    case uranus
    case neptune
    
    static var allcases = [sun,mercury, venus, earth, mars, jupiter, saturn, uranus, neptune]
}

class CelestialBody{
    var bodyName: BodyName
    var yearDuration: TimeInterval?
    var node: SCNNode
    
    init(planetName: BodyName, sphere: SCNSphere) {
        self.bodyName = planetName
        self.node = SCNNode(geometry: sphere)
    }
    
    convenience init(planetName: BodyName, sphere: SCNSphere, position: SCNVector3) {
        self.init(planetName: planetName, sphere: sphere)
        node.position = position
    }
}
