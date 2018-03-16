//
//  ViewController.swift
//  SolarSystem
//
//  Created by Gabriel Mocelin on 15/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var earth: SCNNode?
    
    var sunAnchor: ARAnchor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        //creating sun on a fixed point
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.4
        sunAnchor = ARAnchor(transform: translation)
        sceneView.session.add(anchor: sunAnchor)
        
        //creating earth that can move around
        earth = createGlobe(at: SCNVector3(0.4, 0, -0.4))
        scene.rootNode.addChildNode(earth!)
        //
        //        scene.rootNode.addChildNode(createGlobe(at: SCNVector3(-0.3, 0, -0.4)))
        //
        //        scene.rootNode.addChildNode(createGlobe(at: SCNVector3(0.3, 0, -0.4)))
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    func createGlobe(at position: SCNVector3) -> SCNNode {
        let sphere = SCNSphere.init(radius: 0.1)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/texture.png")
        sphere.firstMaterial = material
        
        let node = SCNNode(geometry: sphere)
        node.position = position
        
        let action = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 2))
        node.runAction(action)
        return node
    }
    
        func orbitalAnimateTest(node: SCNNode, centeredAnchor: ARAnchor) {
            var actions: [SCNAction] = []
            //        let radius = abs(node.position.x - centeredNode.position.x)
            let radius = Float(0.4)
//                Float( degreesToRadians(degrees: CGFloat(simd_distance(node.simdTransform.columns.3, centeredAnchor.transform.columns.3))))

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

            let sequenceAction = SCNAction.sequence(actions)//.reversed()
            let repeatSequence = SCNAction.repeatForever(sequenceAction)
            node.runAction(repeatSequence)
        }
    
        func degreesToRadians(degrees: Float) -> Float {
            return degrees * Float(Double.pi) / 180
        }
    
    
    
//    func orbitalAnimateTest(node: SCNNode, centeredNode: SCNNode) {
//        var actions: [SCNAction] = []
//        //        let radius = abs(node.position.x - centeredNode.position.x)
//        let radius = simd_distance(node.simdTransform.columns.3, sunAnchor.transform.columns.3)
//
//        for angle in 0..<360{
//            let originX = sunAnchor.transform.columns.3.x
//            let originZ = sunAnchor.transform.columns.3.z
//
//            let x = originX + cos(Float(angle)) * radius
//            let z = originZ + sin(Float(angle)) * radius
//            let y = node.simdTransform.columns.3.y
//
//            print("X: \(x), Z: \(z)")
//            actions.append(SCNAction.move(to: SCNVector3.init(x, y, z), duration: 0.7))
//        }
//
//        let sequenceAction = SCNAction.sequence(actions)
//        node.runAction(sequenceAction)
//
//    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSCNViewDelegate
    
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let sphere = SCNSphere.init(radius: 0.1)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/texture.png")
        sphere.firstMaterial = material
        
        let node = SCNNode(geometry: sphere)
        
        let action = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 2))
        node.runAction(action)
        
        if let earth = earth{
            orbitalAnimateTest(node: earth, centeredAnchor: anchor)
        }
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        print(#function)
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

