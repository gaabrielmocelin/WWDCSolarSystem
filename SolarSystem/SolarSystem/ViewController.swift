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

public class ViewController: UIViewController, ARSCNViewDelegate {
    
    var backgroundMusic = AVAudioPlayer()
    
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
    
    public override func viewDidLoad() {
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
        let scene = SolarSystemScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // the solar system will handle the sceneview delegate
        sceneView.delegate = scene
        
        //set the solar system based on camera direction
        //REFACTOR *********************
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
        guard let position = startPosition, let overLayGame = overLayView as? GameView else {
            print("something went wrong on present game")
            return
        }
        
        let scene = GameScene()
        sceneView.scene = scene
        
        //delegates
        sceneView.delegate = scene
        overLayGame.gameDelegate = scene
        scene.gameOverDelegate = overLayGame
        
        var spaceshipPosition = position
        spaceshipPosition.z -= 0.2
        scene.placeSpaceship(atPosition: spaceshipPosition)
        scene.generateSpawnPositions(withPosition: spaceshipPosition)
        scene.generateRowLines(withPosition: spaceshipPosition)
    }
    
    func resetSession() {
            let configuration = ARWorldTrackingConfiguration()
            sceneView.session.pause()
            sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                node.removeFromParentNode()
            }
            sceneView.session.run(configuration, options: [.resetTracking])
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
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
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "GalaxyGameSound", withExtension: "mp3"), let player = try? AVAudioPlayer(contentsOf: url) else {
            print("error sound")
            return
        }
        backgroundMusic = player
        backgroundMusic.numberOfLoops = -1
        backgroundMusic.prepareToPlay()
        backgroundMusic.play()
    }
}

extension ViewController: StateManager{
    public func nextState(currentState: ControlState) {
        
        switch currentState {
        case .welcome:
            self.currentState = ControlState.solarSystem
            overLayView = IntroduceSolarSystemView()
            presentSolarSystem()
            playSound()
        case .solarSystem:
            if let solarSystem = sceneView.scene as? SolarSystemScene{
                self.currentState = ControlState.gameHistory
                let gameHistory = GameHistoryView()
                solarSystem.endOfTheSystemDelegate = gameHistory
                
                solarSystem.endOfTheSystem(atCameraPointOfView: getCameraAngleAndAxes())
                overLayView = gameHistory
            }
        case .gameHistory:
            overLayView = GameView()
            presentGame()
        case .game:
            DispatchQueue.main.async {
                if let gameOverlay = self.overLayView as? GameView{
                    let score = gameOverlay.score
                    let gameOverView = GameOverView()
                    gameOverView.score = score
                    if gameOverlay.gameWasCompleted {
                        gameOverView.gameCompleted()
                    }
                    self.overLayView = gameOverView
                }
            }
        case .gameOver:
            self.overLayView = GameView()
            presentGame()
        }
    }
}

