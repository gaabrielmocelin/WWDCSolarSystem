//
//  SolarSystem.swift
//  SolarSystem
//
//  Created by Gabriel Mocelin on 17/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import SceneKit
import ARKit

class SolarSystemScene: SCNScene {
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
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        let node = SCNNode()
        node.light = ambientLight
        node.light?.intensity = 100
        rootNode.addChildNode(node)
        
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
        
        switch body {
        case .sun:
            let sphere = SCNSphere(radius: 0.05)
            sphere.setMaterial(with: UIImage(named: "art.scnassets/sun.jpg"), constant: true)
            let sun = CelestialBody(planetName: body, sphere: sphere)
            sun.node.light = SCNLight()
            sun.node.light?.type = .omni
            return sun
        case .mercury:
            let sphere = SCNSphere(radius: 0.025)
            sphere.setMaterial(with: UIImage(named: "art.scnassets/mercury.jpg"))
            let planet = CelestialBody(planetName: body, sphere: sphere)
            planet.yearDuration = 10
            return planet
        case .venus:
            let sphere = SCNSphere(radius: 0.025)
            sphere.setMaterial(with: UIImage(named: "art.scnassets/venus.jpg"))
            let planet = CelestialBody(planetName: body, sphere: sphere)
            planet.yearDuration = 17
            return planet
        case .earth:
            let sphere = SCNSphere(radius: 0.025)
            sphere.setMaterial(with: UIImage(named: "art.scnassets/earth_day.jpg"))
            let planet = CelestialBody(planetName: body, sphere: sphere)
            planet.yearDuration = 22
            return planet
        case .mars:
            let sphere = SCNSphere(radius: 0.025)
            sphere.setMaterial(with: UIImage(named: "art.scnassets/mars.jpg"))
            let planet = CelestialBody(planetName: body, sphere: sphere)
            planet.yearDuration = 32
            return planet
        case .jupiter:
            let sphere = SCNSphere(radius: 0.025)
            sphere.setMaterial(with: UIImage(named: "art.scnassets/jupiter.jpg"))
            let planet = CelestialBody(planetName: body, sphere: sphere)
            planet.yearDuration = 45
            return planet
        case .saturn:
            let sphere = SCNSphere(radius: 0.025)
            sphere.setMaterial(with: UIImage(named: "art.scnassets/saturn.jpg"))
            let planet = CelestialBody(planetName: body, sphere: sphere)
            planet.yearDuration = 60
//            planet.node.eulerAngles = SCNVector3(-0.7, -0.7, 0)
            
            //saturn ring
            let tube = SCNTube(innerRadius: 0.03, outerRadius: 0.05, height: 0.0005)
            tube.setMaterial(with: UIImage(named: "art.scnassets/SaturnRing2.png"))
            let tubeNode = SCNNode(geometry: tube)
            planet.node.addChildNode(tubeNode)
            
            return planet
        case .uranus:
            let sphere = SCNSphere(radius: 0.025)
            sphere.setMaterial(with: UIImage(named: "art.scnassets/uranus.jpg"))
            let planet = CelestialBody(planetName: body, sphere: sphere)
            planet.yearDuration = 90
            return planet
        case .neptune:
            let sphere = SCNSphere(radius: 0.025)
            sphere.setMaterial(with: UIImage(named: "art.scnassets/neptune.jpg"))
            let planet = CelestialBody(planetName: body, sphere: sphere)
            planet.yearDuration = 125
            return planet
        }
    }
    
    func updatePlanetsPositions(at anchor: ARAnchor) {
        let transform = anchor.transform.columns.3
        var position = SCNVector3(transform.x + 0.1, transform.y, transform.z)
        planets.forEach { (planet) in
            planet.node.position = position
            position.x += 0.1
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
        
        let rotateTime: TimeInterval = time < 30 ? time / (time / 0.9) : time / (time / 1.5)
        let repeatRotateAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: rotateTime))
        
        let orbitalSequenceAction = SCNAction.sequence(actions)
        let repeatOrbitalAction = SCNAction.repeatForever(orbitalSequenceAction)
        
        let groupAction = SCNAction.group([repeatRotateAction, repeatOrbitalAction])
        
        node.runAction(groupAction)
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
            torus.setMaterial(with: UIColor.init(white: 0.7, alpha: 0.4))
            let pathNode = SCNNode(geometry: torus)
            
            let axes = anchor.transform.translation
            pathNode.position = SCNVector3(axes)
            orbitalPaths.append(pathNode)
            rootNode.addChildNode(pathNode)
        }
    }
}

extension SolarSystemScene: ARSCNViewDelegate{
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        if let sun = sun {
            sunAnchor = anchor
            updatePlanetsPositions(at: anchor)
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
    func setMaterial(with content: Any?, constant: Bool = false) {
        let material = SCNMaterial()
        
        if constant{
            material.lightingModel = .constant
        }
        
        if let content = content as? UIImage{
            material.diffuse.contents = content
            self.firstMaterial = material
        }else if let content = content as? UIColor{
            material.diffuse.contents = content
            self.firstMaterial = material
        }
    }
}
