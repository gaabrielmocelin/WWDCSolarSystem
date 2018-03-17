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
        var position = SCNVector3(0, 0, -0.4)
        for planetName in PlanetName.allcases{
            let sphere = generateSphere(forPlanet: planetName, withRadius: 0.1)
            
            if planetName == .sun{
                planets.append(Planet(planetName: planetName, sphere: sphere))
            }else{
                planets.append(Planet(planetName: planetName, sphere: sphere, position: position))
            }
            position.x += 0.4
        }
    }
    
    func generateSphere(forPlanet: PlanetName, withRadius radius: CGFloat) -> SCNSphere{
        let sphere = SCNSphere(radius: radius)
        
        //TO DO: CHANGE THE TEXTURE ACCORDING TO THE PLANET NAME
        sphere.setMaterial(with: UIImage(named: "art.scnassets/texture.png"))
        
        return sphere
    }
    
    func orbitalAnimate(node: SCNNode, centeredAnchor: ARAnchor) {
        var actions: [SCNAction] = []
        let radius = Float(0.4)
        
        for angle in stride(from: 360, through: 0, by: -1){
            
            let originX = centeredAnchor.transform.columns.3.x
            let originZ = centeredAnchor.transform.columns.3.z
            
            let radianAngle = degreesToRadians(degrees: Float(angle))
            
            let x = originX + cos(radianAngle) * radius
            let z = (originZ + sin(radianAngle) * radius)
            let y = node.simdTransform.columns.3.y
            
            print("X: \(x), Z: \(z)")
            actions.append(SCNAction.move(to: SCNVector3.init(x, y, z), duration: 0.01))
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
            
            //should be out of here
            self.rootNode.addChildNode(planets[1].node)
            orbitalAnimate(node: planets[1].node, centeredAnchor: anchor)
            
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
