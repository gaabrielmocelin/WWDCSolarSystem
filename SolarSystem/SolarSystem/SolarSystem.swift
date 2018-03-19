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
    var celestialBodies: [CelestialBody]
    
    var planets: [CelestialBody]{
        return celestialBodies.filter{$0.bodyName != BodyName.sun}
    }
    
    var sun: CelestialBody? {
        return celestialBodies.first(where: { $0.bodyName == BodyName.sun })
    }
    
    var orbitalPaths: [SCNNode]
    
    var sunAnchor: ARAnchor?
    
    override init() {
        celestialBodies = []
        orbitalPaths = []
        super.init()
        setupBodies()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBodies(){
        for bodyName in BodyName.allcases{
            if bodyName == .sun{
                celestialBodies.append(generateCelestialBody(body: bodyName))
            }else{
                let body = generateCelestialBody(body: bodyName)
                celestialBodies.append(body)
                rootNode.addChildNode(body.node)
            }
        }
    }
    
    func generateCelestialBody(body: BodyName) -> CelestialBody{
        
        //TO DO: CHANGE THE TEXTURE ACCORDING TO THE PLANET NAME
        switch body {
        case .sun:
            let sphere = SCNSphere(radius: 0.05)
            sphere.setMaterial(with: UIImage(named: "art.scnassets/sun.jpg"))
            let sun = CelestialBody(planetName: body, sphere: sphere)
            return sun
        case .mercury:
            let sphere = SCNSphere(radius: 0.025)
            sphere.setMaterial(with: UIImage(named: "art.scnassets/mercury.jpg"))
            let planet = CelestialBody(planetName: body, sphere: sphere, position: SCNVector3(x: 0.1, y: 0, z: -0.4))
            planet.yearDuration = 4
            return planet
        case .venus:
            let sphere = SCNSphere(radius: 0.025)
            sphere.setMaterial(with: UIImage(named: "art.scnassets/venus.jpg"))
            let planet = CelestialBody(planetName: body, sphere: sphere, position: SCNVector3(x: 0.2, y: 0, z: -0.4))
            planet.yearDuration = 5
            return planet
        case .earth:
            let sphere = SCNSphere(radius: 0.025)
            sphere.setMaterial(with: UIImage(named: "art.scnassets/earth_day.jpg"))
            let planet = CelestialBody(planetName: body, sphere: sphere, position: SCNVector3(x: 0.3, y: 0, z: -0.4))
            planet.yearDuration = 6.5
            return planet
        case .mars:
            let sphere = SCNSphere(radius: 0.025)
            sphere.setMaterial(with: UIImage(named: "art.scnassets/mars.jpg"))
            let planet = CelestialBody(planetName: body, sphere: sphere, position: SCNVector3(x: 0.4, y: 0, z: -0.4))
            planet.yearDuration = 9
            return planet
        case .jupiter:
            let sphere = SCNSphere(radius: 0.025)
            sphere.setMaterial(with: UIImage(named: "art.scnassets/jupiter.jpg"))
            let planet = CelestialBody(planetName: body, sphere: sphere, position: SCNVector3(x: 0.5, y: 0, z: -0.4))
            planet.yearDuration = 13
            return planet
        case .saturn:
            let sphere = SCNSphere(radius: 0.025)
            sphere.setMaterial(with: UIImage(named: "art.scnassets/saturn.jpg"))
            let planet = CelestialBody(planetName: body, sphere: sphere, position: SCNVector3(x: 0.6, y: 0, z: -0.4))
            planet.yearDuration = 17
            return planet
        case .uranus:
            let sphere = SCNSphere(radius: 0.025)
            sphere.setMaterial(with: UIImage(named: "art.scnassets/uranus.jpg"))
            let planet = CelestialBody(planetName: body, sphere: sphere, position: SCNVector3(x: 0.7, y: 0, z: -0.4))
            planet.yearDuration = 22
            return planet
        case .neptune:
            let sphere = SCNSphere(radius: 0.025)
            sphere.setMaterial(with: UIImage(named: "art.scnassets/neptune.jpg"))
            let planet = CelestialBody(planetName: body, sphere: sphere, position: SCNVector3(x: 0.8, y: 0, z: -0.4))
            planet.yearDuration = 30
            return planet
        }
    }
    
    func allPlanetsOrbitating(at anchor: ARAnchor) {
        generateOrbitalPaths()
        
        planets.forEach { (planet) in
            if let yearDuration = planet.yearDuration{
                orbitalAnimate(planet: planet, centeredAnchor: anchor, time: yearDuration)
            }
        }
    }
    
    func orbitalAnimate(planet: CelestialBody, centeredAnchor: ARAnchor, time: TimeInterval) {
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
            
            actions.append(SCNAction.move(to: SCNVector3.init(x, y, z), duration: fractionedTime))
        }
        
        let sequenceAction = SCNAction.sequence(actions)
        let repeatSequence = SCNAction.repeatForever(sequenceAction)
        node.runAction(repeatSequence)
    }
    
    //GENERATE A FLOAT EXTENSION TO DO THATTTT
    func degreesToRadians(degrees: Float) -> Float {
        return degrees * Float(Double.pi) / 180
    }
    
    func distance(of body: CelestialBody, toAnchor anchor: ARAnchor ) -> Float {
        return simd_distance(body.node.simdTransform.columns.3, anchor.transform.columns.3)
    }
    
    func generateOrbitalPaths() {
        guard let anchor = sunAnchor else { return }
        planets.forEach { (planet) in
            let torus = SCNTorus(ringRadius: CGFloat(distance(of: planet, toAnchor: anchor)), pipeRadius: 0.0007)
            torus.setMaterial(with: UIColor.lightGray)
            let pathNode = SCNNode(geometry: torus)
            
            let x = anchor.transform.columns.3.x
            let y = anchor.transform.columns.3.y
            let z = anchor.transform.columns.3.z
            
            pathNode.position = SCNVector3(x,y,z)
            orbitalPaths.append(pathNode)
            rootNode.addChildNode(pathNode)
        }
    }
}

extension SolarSystem: ARSCNViewDelegate{
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        if let sun = sun {
            sunAnchor = anchor
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

extension SCNGeometry{
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
