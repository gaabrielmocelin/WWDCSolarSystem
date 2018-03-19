//
//  SolarSystem.swift
//  SolarSystem
//
//  Created by Gabriel Mocelin on 17/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import SceneKit
import ARKit

class SolarSystem: SCNScene {
    var planets: [Planet]
    
    override init() {
        planets = []
        super.init()
        setupPlanets()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPlanets(){
        for planetName in PlanetName.allcases{
            if planetName == .sun{
                planets.append(generatePlanet(planetName: planetName))
            }else{
                let planet = generatePlanet(planetName: planetName)
                planets.append(planet)
                rootNode.addChildNode(planet.node)
            }
        }
    }
    
    func generatePlanet(planetName: PlanetName) -> Planet{
        
        //TO DO: CHANGE THE TEXTURE ACCORDING TO THE PLANET NAME
        switch planetName {
        case .sun:
            let sphere = SCNSphere(radius: 0.05)
            sphere.setMaterial(with: UIColor.yellow)
            let planet = Planet(planetName: planetName, sphere: sphere)
            return planet
        case .mercury:
            let sphere = SCNSphere(radius: 0.025)
            sphere.setMaterial(with: UIColor.gray)
            let planet = Planet(planetName: planetName, sphere: sphere, position: SCNVector3(x: 0.1, y: 0, z: -0.4))
            planet.yearDuration = 4
            return planet
        case .venus:
            let sphere = SCNSphere(radius: 0.025)
            sphere.setMaterial(with: UIImage(named: "art.scnassets/texture.png"))
            let planet = Planet(planetName: planetName, sphere: sphere, position: SCNVector3(x: 0.2, y: 0, z: -0.4))
            planet.yearDuration = 5
            return planet
        case .earth:
            let sphere = SCNSphere(radius: 0.025)
            sphere.setMaterial(with: UIColor.green)
            let planet = Planet(planetName: planetName, sphere: sphere, position: SCNVector3(x: 0.3, y: 0, z: -0.4))
            planet.yearDuration = 6.5
            return planet
        case .mars:
            let sphere = SCNSphere(radius: 0.025)
            sphere.setMaterial(with: UIColor.red)
            let planet = Planet(planetName: planetName, sphere: sphere, position: SCNVector3(x: 0.4, y: 0, z: -0.4))
            planet.yearDuration = 9
            return planet
        case .jupiter:
            let sphere = SCNSphere(radius: 0.025)
            sphere.setMaterial(with: UIColor.brown)
            let planet = Planet(planetName: planetName, sphere: sphere, position: SCNVector3(x: 0.5, y: 0, z: -0.4))
            planet.yearDuration = 13
            return planet
        case .saturn:
            let sphere = SCNSphere(radius: 0.025)
            sphere.setMaterial(with: UIColor.orange)
            let planet = Planet(planetName: planetName, sphere: sphere, position: SCNVector3(x: 0.6, y: 0, z: -0.4))
            planet.yearDuration = 17
            return planet
        case .uranus:
            let sphere = SCNSphere(radius: 0.025)
            sphere.setMaterial(with: UIColor.cyan)
            let planet = Planet(planetName: planetName, sphere: sphere, position: SCNVector3(x: 0.7, y: 0, z: -0.4))
            planet.yearDuration = 22
            return planet
        case .neptune:
            let sphere = SCNSphere(radius: 0.025)
            sphere.setMaterial(with: UIColor.blue)
            let planet = Planet(planetName: planetName, sphere: sphere, position: SCNVector3(x: 0.8, y: 0, z: -0.4))
            planet.yearDuration = 30
            return planet
        }
    }
    
    func allPlanetsOrbitating(at anchor: ARAnchor) {
        planets.forEach { (planet) in
            if let yearDuration = planet.yearDuration, planet.planetName != .sun{
                orbitalAnimate(planet: planet, centeredAnchor: anchor, time: yearDuration)
            }
        }
    }
    
    func orbitalAnimate(planet: Planet, centeredAnchor: ARAnchor, time: TimeInterval) {
        let node = planet.node
        var actions: [SCNAction] = []
        let radius = simd_distance(node.simdTransform.columns.3, centeredAnchor.transform.columns.3)
        
        let fractionedTime = time / 360
        
        for angle in stride(from: 360, through: 0, by: -1){
            
            let originX = centeredAnchor.transform.columns.3.x
            let originZ = centeredAnchor.transform.columns.3.z
            
            let radianAngle = degreesToRadians(degrees: Float(angle))
            
            let x = originX + cos(radianAngle) * radius
            let z = (originZ + sin(radianAngle) * radius)
            let y = node.simdTransform.columns.3.y
            
            print("X: \(x), Z: \(z)")
            actions.append(SCNAction.move(to: SCNVector3.init(x, y, z), duration: fractionedTime))
        }
        
        let sequenceAction = SCNAction.sequence(actions)
        let repeatSequence = SCNAction.repeatForever(sequenceAction)
        node.runAction(repeatSequence)
    }
    
    func degreesToRadians(degrees: Float) -> Float {
        return degrees * Float(Double.pi) / 180
    }

}

extension SolarSystem: ARSCNViewDelegate{
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        if let sun = planets.first(where: { $0.planetName == PlanetName.sun }) {
            allPlanetsOrbitating(at: anchor)
            return sun.node
        }
        
        return SCNNode()
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
}

extension SCNSphere{
    func setMaterial(with content: Any?) {
        let material = SCNMaterial()
        if let content = content as? UIImage{
            material.diffuse.contents = content
            self.firstMaterial = material
        }else if let content = content as? UIColor{
            material.diffuse.contents = content
            self.firstMaterial = material
        }
    }
}
