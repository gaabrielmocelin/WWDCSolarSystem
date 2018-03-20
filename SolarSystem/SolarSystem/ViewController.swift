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
    
    var welcomeView: WelcomeView?
    
    var sunAnchor: ARAnchor!
    
//    var nextButton = UIButton()
    
    var currentState: ControlState?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeView = WelcomeView(frame: self.sceneView.bounds)
        self.view.addSubview(welcomeView!)
        welcomeView?.delegate = self
       
//        presentSolarSystem()
//        setupButton()
    }
    
//    func setupButton() {
//        nextButton = UIButton(frame: CGRect())
//        nextButton.setTitle("Next", for: .normal)
//        nextButton.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
//        nextButton.backgroundColor = #colorLiteral(red: 0.9860219359, green: 0.4115800261, blue: 0.3854584694, alpha: 1)
//        nextButton.layer.cornerRadius = 20
//        nextButton.clipsToBounds = true
//
//        self.sceneView.addSubview(nextButton)
//        nextButton.translatesAutoresizingMaskIntoConstraints = false
//        nextButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        nextButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        nextButton.bottomAnchor.constraint(equalTo: self.sceneView.bottomAnchor, constant: 0).isActive = true
//        nextButton.rightAnchor.constraint(equalTo: self.sceneView.rightAnchor, constant: 0).isActive = true
//
//    }
    
    @objc func handleNextButton(sender: UIButton) {
        print(sender)
        print("clicked")
    }
    
    func presentSolarSystem()  {
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SolarSystem()
        
        // Set the view's delegate
        sceneView.delegate = scene
        
        //creating sun on a fixed point
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.4
        sunAnchor = ARAnchor(transform: translation)
        sceneView.session.add(anchor: sunAnchor)
        
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

