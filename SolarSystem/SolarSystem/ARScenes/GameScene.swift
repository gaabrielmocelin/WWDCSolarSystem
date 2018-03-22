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
    var originalSpaceshipPositon: SCNVector3
    
    var spawnBarrierPositions: [SCNVector3]
    
    override init() {
        originalSpaceshipPositon = SCNVector3()
        spawnBarrierPositions = []
        spaceShip = SCNNode(geometry: SCNPyramid(width: 0.05, height: 0.03, length: 0.12))
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func startGame() {
        
    }

    func restartGame()  {

    }
    
    func placeSpaceship(atPosition position: SCNVector3) {
        originalSpaceshipPositon = position
        spaceShip.position = originalSpaceshipPositon
        rootNode.addChildNode(spaceShip)
    }
}

extension GameScene: ARSCNViewDelegate{
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        placeSpaceship(atAnchor: anchor)
        generateSpawnPositions(withAnchor: anchor)
        return SCNNode(geometry: SCNBox(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0.01))
    }
    
    func placeSpaceship(atAnchor anchor: ARAnchor) {
        let translation = anchor.transform.translation
        originalSpaceshipPositon = SCNVector3(translation)
        spaceShip.position = originalSpaceshipPositon
        rootNode.addChildNode(spaceShip)
    }
    
    func generateSpawnPositions(withAnchor anchor: ARAnchor) {
        var translation = anchor.transform.translation
        translation.x += -0.2
        translation.z += -1
        
        for _ in 0..<3 {
            spawnBarrierPositions.append(SCNVector3(translation))
            translation.x += 0.2
        }
    }
}
