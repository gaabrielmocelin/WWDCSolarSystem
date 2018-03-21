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
    
    var currentState: ControlState?
    var sceneView: ARSCNView!
    var overLayView: (UIView & OverLay)?{
        willSet{
            overLayView?.hide()
            overLayView?.removeFromSuperview()
        }
        didSet{
            self.view.addSubviewWithSameAnchors(overLayView)
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
        let scene = SolarSystemScene()
        
        // Set the view's delegate
        sceneView.delegate = scene
        
        //set the solar system based on camera direction
        let userVector = getUserVector()
        print(userVector)
        var translation = matrix_identity_float4x4
        translation.columns.3.x += userVector.0.x
        translation.columns.3.y += (userVector.0.y - userVector.1.y) / 2
        translation.columns.3.z += 0.4 * userVector.0.z
        
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
    
    func getUserVector() -> (SCNVector3, SCNVector3) { // (direction, position)
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform) // 4x4 transform matrix describing camera in world space
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33) // orientation of camera in world space
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43) // location of camera in world space
            
            return (dir, pos)
        }
        return (SCNVector3(0, 0, -1), SCNVector3(0, 0, -0.2))
    }
}

extension ViewController: StateManager{
    func nextState(currentState: ControlState) {
        
        switch currentState {
        case .welcome:
            self.currentState = ControlState.solarSystem
            overLayView = IntroduceSolarSystemView()
            presentSolarSystem()
        case .solarSystem:
            self.currentState = ControlState.gameHistory
            overLayView = GameHistoryView()
        case .gameHistory:
            self.overLayView = GameView()
            sceneView.scene = GameScene()
        case .game:
            self.overLayView = GameOverView()
        case .gameOver:
            self.overLayView = GameView()
            let scene = sceneView.scene as! GameScene
            scene.restartGame()
        }
    }
}

