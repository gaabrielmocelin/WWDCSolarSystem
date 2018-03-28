//
//  Planet.swift
//  SolarSystem
//
//  Created by Gabriel Mocelin on 17/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import SceneKit

public enum BodyName: String{
    case sun
    case mercury
    case venus
    case earth
    case mars
    case jupiter
    case saturn
    case uranus
    case neptune
    
   public static var allcases = [sun,mercury, venus, earth, mars, jupiter, saturn, uranus, neptune]
}

public class CelestialBody{
    public var bodyName: BodyName
    public var yearDuration: TimeInterval?
    public var node: SCNNode
    
    public init(planetName: BodyName, sphere: SCNSphere) {
        self.bodyName = planetName
        self.node = SCNNode(geometry: sphere)
    }
    
    public convenience init(planetName: BodyName, sphere: SCNSphere, position: SCNVector3) {
        self.init(planetName: planetName, sphere: sphere)
        node.position = position
    }
}
