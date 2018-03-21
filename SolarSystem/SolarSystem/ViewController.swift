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
    
    var sceneView: ARSCNView!
    var welcomeView: WelcomeView!
    
     var currentState: ControlState?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView = ARSCNView(frame: CGRect())
        self.view.addSubview(sceneView)
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        sceneView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        sceneView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        sceneView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        
        welcomeView = WelcomeView()
        self.view.addSubview(welcomeView!)
        welcomeView.translatesAutoresizingMaskIntoConstraints = false
        welcomeView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        welcomeView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        welcomeView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        welcomeView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        welcomeView.delegate = self
       
    }
    
    func presentSolarSystem()  {
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SolarSystem()
        
        // Set the view's delegate
        sceneView.delegate = scene
        
        //creating sun on a fixed point
        //SHOULD GET A UPDATED POINT --------------------------------
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.4
        

//        let position = sceneView.pointOfView!.position
//        var translation = matrix_identity_float4x4
//        translation.columns.3.x = position.x
//        translation.columns.3.y = position.y
//        translation.columns.3.z = position.z - 0.4
        
        //WE DONT KNOW WHERE THE CAMERA IS FOCUSING TO SET THE RIGHT AXIS
        //        var translation = sceneView.session.currentFrame!.camera.transform
//        translation.columns.3.z =
        
        
//        var rotate = simd_float4x4(SCNMatrix4MakeRotation(sceneView.session.currentFrame!.camera.eulerAngles.y, 0, 1, 0))
//        rotate.columns.3.z -= 0.3
        
        sceneView.session.add(anchor: ARAnchor(transform: translation))
        
        // Set the scene to the view
        sceneView.scene = scene
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

extension ViewController: StateManager{
    func nextState(currentState: ControlState) {
        if currentState == .welcome{
            welcomeView?.removeFromSuperview()
            
            self.currentState = ControlState.solarSystem
            presentSolarSystem()
        }
    }
}

