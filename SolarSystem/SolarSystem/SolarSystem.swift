//
//  SolarSystem.swift
//  SolarSystem
//
//  Created by Gabriel Mocelin on 17/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import SceneKit

class SolarSystem: SCNScene {
    var planets: [SCNNode]
    
    override init() {
        planets = []
        
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPlanets(){
        var position = SCNVector3(0, 0, -0.4)
        for planet in PlanetName.allcases{
            if planet == .sun{
                
            }
            planets.append(Planet(planetName: planet, position: position, withRadius: 0.5))
            position.x += 0.3
        }
    }

}
