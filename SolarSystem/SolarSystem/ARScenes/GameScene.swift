//
//  GameScene.swift
//  SolarSystem
//
//  Created by Gabriel Mocelin on 21/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import ARKit
import SceneKit

class GameScene: SCNScene {
    var spaceShip: SCNNode
    
    override init() {
        spaceShip = SCNNode(geometry: SCNPyramid(width: 0.05, height: 0.1, length: 0.12))
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func startGame() {
        
    }

    func restartGame()  {

    }
}

extension GameScene: ARSCNViewDelegate{
    func generateAnchors(withCameraPosition camera: (SCNVector3, SCNVector3)) -> [GameAnchor] {
        var anchors: [GameAnchor] = []
        
        var translation = matrix_identity_float4x4
        translation.columns.3.x += -0.1 * camera.0.x
        translation.columns.3.y += (camera.0.y - camera.1.y) / 2
        translation.columns.3.z += 0.25 * camera.0.z
        
        //spaceship or barriers size
        for side in 0..<2{
            //left, center or right
            for position in 0..<3{
                if let position = AnchorPosition(rawValue: position), let side = AnchorSide(rawValue: side){
                    let anchor = GameAnchor(transform: translation, anchorPosition: position, anchorSide: side)
                    anchors.append(anchor)
                }
                translation.columns.3.x += 0.1
            }
            translation.columns.3.x += -0.1 * camera.0.x
            translation.columns.3.z += 0.6 * camera.0.z
        }
        
        return anchors
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let gameAnchor = anchor as? GameAnchor else { return SCNNode() }
       
        switch gameAnchor.anchorSide {
        case .spaceship:
            return SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.1))
        case .barriers:
            return SCNNode(geometry: SCNCone(topRadius: 0.02, bottomRadius: 0.1, height: 0.1))
        }
    }
}
