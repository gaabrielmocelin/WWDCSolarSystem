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

class ViewController: UIViewController{
    
    var currentState: ControlState?
    var sceneView: ARSCNView!
    var overLayView: (UIView & OverLay)?{
        willSet{
            overLayView?.hide()
            overLayView?.removeFromSuperview()
        }
        didSet{
            self.view.addSubviewWithSameAnchors(overLayView!)
            overLayView?.show()
            overLayView?.stateDelegate = self
        }
    }
    
    var screenCenter: CGPoint {
        let bounds = sceneView.bounds
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSceneView()
        setupInitialState()
    }
    
    func setupInitialState() {
        self.currentState = ControlState.welcome
        
        let welcomeView = WelcomeView()
        overLayView = welcomeView
    }
    
    func setupSceneView() {
        sceneView = ARSCNView(frame: CGRect())
        self.view.addSubviewWithSameAnchors(sceneView)
    }
    
    func presentSolarSystem()  {
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SolarSystem()
        
        // Set the view's delegate
        sceneView.delegate = self
    
        //SHOULD GET A UPDATED POINT --------------------------------
        //maybe there is another option ********
        resetSession()
        
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.4
        
        sceneView.session.add(anchor: ARAnchor(transform: translation))
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    func resetSession() {
            let configuration = ARWorldTrackingConfiguration()
            sceneView.session.pause()
            sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                node.removeFromParentNode()
            }
            sceneView.session.run(configuration, options: [.resetTracking])
    }
    
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
}

extension ViewController: ARSCNViewDelegate{
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        if let scene = sceneView.scene as? SolarSystem, let sun = scene.sun{
            scene.sunAnchor = anchor
            scene.updatePlanetsPositions(at: anchor)
            scene.allPlanetsOrbitating(at: anchor)
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

extension ViewController: StateManager{
    func nextState(currentState: ControlState) {
        if currentState == .welcome{
            self.currentState = ControlState.solarSystem
            self.overLayView = IntroduceSolarSystemView()
            presentSolarSystem()
        }else if currentState == .solarSystem {
            self.currentState = ControlState.gameHistory
            self.overLayView = GameHistory()
            sceneView.scene = SCNScene()
        }
    }
}

