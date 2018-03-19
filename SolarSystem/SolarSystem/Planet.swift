//
//  Planet.swift
//  SolarSystem
//
//  Created by Gabriel Mocelin on 17/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import SceneKit

enum PlanetName: String{
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

class Planet{
    var planetName: PlanetName
    var yearDuration: TimeInterval?
    var node: SCNNode
    
    init(planetName: PlanetName, sphere: SCNSphere) {
        self.planetName = planetName
        self.node = SCNNode(geometry: sphere)
    }
    
    convenience init(planetName: PlanetName, sphere: SCNSphere, position: SCNVector3) {
        self.init(planetName: planetName, sphere: sphere)
        node.position = position
    }
}
