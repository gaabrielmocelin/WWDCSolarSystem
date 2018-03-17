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

class Planet: SCNNode{
    var planetName: PlanetName
    var radius: CGFloat
    
    init(planetName: PlanetName, position: SCNVector3) {
        self.planetName = planetName
        self.radius = 0
        
        super.init()
        self.setupPlanet()
        self.position = position
    }
    
    convenience init(planetName: PlanetName, position: SCNVector3, withRadius: CGFloat) {
        self.init(planetName: planetName, position: position)
        self.radius = radius
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPlanet() {
        let sphere = SCNSphere.init(radius: radius)
        
        //TO DO: CHANGE THE TEXTURE ACCORDING TO THE PLANET NAME
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/texture.png")
        sphere.firstMaterial = material
        
        self.geometry = sphere
    }
}
