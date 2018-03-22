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
    
    var startPosition: SCNVector3?
    
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
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    }
    
    func presentSolarSystem()  {
        let scene = SolarSystemScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // the solar system will handle the sceneview delegate
        sceneView.delegate = scene
        
        //set the solar system based on camera direction
        let camera = getCameraAngleAndAxes()
        print(camera)
        var transform = matrix_identity_float4x4
        transform.columns.3.x += camera.0.x
        transform.columns.3.y += (camera.0.y - camera.1.y) / 2
        transform.columns.3.z += 0.4 * camera.0.z
        
        startPosition = SCNVector3(transform.translation)
        sceneView.session.add(anchor: ARAnchor(transform: transform))
    }
    
    func presentGame()  {
        let scene = GameScene()
        sceneView.scene = scene
        sceneView.delegate = scene
        if let position = startPosition{
            scene.placeSpaceship(atPosition: position)
        }
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
    
    // Credit to https://github.com/farice/ARShooter to help me get the point where the user is looking for
    func getCameraAngleAndAxes() -> (SCNVector3, SCNVector3) { // (direction, position)
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
            overLayView = GameView()
            presentGame()
        case .game:
            self.overLayView = GameOverView()
        case .gameOver:
            self.overLayView = GameView()
            let scene = sceneView.scene as! GameScene
            scene.restartGame()
        }
    }
}

