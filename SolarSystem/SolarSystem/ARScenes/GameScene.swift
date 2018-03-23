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
    
    func generateSpawnPositions(withPosition position: SCNVector3) {
        var mutablePosition = position
        mutablePosition.x += -0.2
        mutablePosition.z += -1
        
        for _ in 0..<3 {
            spawnBarrierPositions.append(mutablePosition)
            let node = SCNNode(geometry: SCNCone(topRadius: 0.01, bottomRadius: 0.01, height: 0.01))
            node.position = mutablePosition
            rootNode.addChildNode(node)
            mutablePosition.x += 0.2
        }
    }
}

extension GameScene: ARSCNViewDelegate{
  
}
