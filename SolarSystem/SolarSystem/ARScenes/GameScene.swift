//
//  GameScene.swift
//  SolarSystem
//
//  Created by Gabriel Mocelin on 21/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import ARKit
import SceneKit

enum SpaceshipRow: Int {
    case left
    case center
    case right
}

class GameScene: SCNScene {
    var spaceShip: SCNNode
    var originalSpaceshipPositon: SCNVector3
    var spawnBarrierPositions: [SCNVector3]
    
    //for now
    private var spaceshipRow: SpaceshipRow
    
    override init() {
        originalSpaceshipPositon = SCNVector3()
        spawnBarrierPositions = []
        spaceShip = SCNNode(geometry: SCNPyramid(width: 0.05, height: 0.03, length: 0.12))
        spaceshipRow = .center
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func restartGame()  {

    }
    
    func placeSpaceship(atPosition position: SCNVector3) {
        originalSpaceshipPositon = position
        spaceShip.position = originalSpaceshipPositon
        spaceshipRow = .center
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
    
    private func moveSpaceshipLeft() {
        guard let row = SpaceshipRow(rawValue: spaceshipRow.rawValue - 1) else { return }
        
        spaceshipRow = row
        var position = originalSpaceshipPositon
        position.x += -0.2
        spaceShip.runAction(SCNAction.move(to: position, duration: 0.5))
        
    }
    
    private func moveSpaceshipRight() {
        guard let row = SpaceshipRow(rawValue: spaceshipRow.rawValue + 1) else { return }
        
        spaceshipRow = row
        var position = originalSpaceshipPositon
        position.x += 0.2
        spaceShip.runAction(SCNAction.move(to: position, duration: 0.3))
    }
}

extension GameScene: GamePerformer{
    func didSwipe(_ direction: UISwipeGestureRecognizerDirection) {
        if direction == .left, !(spaceshipRow == .left){
            moveSpaceshipLeft()
        }else if direction == .right, !(spaceshipRow == .right){
            moveSpaceshipRight()
        }
    }
    
    func startGame() {
        
    }
}

extension GameScene: ARSCNViewDelegate{
  
}
