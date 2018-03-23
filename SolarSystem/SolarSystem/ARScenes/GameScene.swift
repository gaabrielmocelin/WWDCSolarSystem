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
    var spaceshipPositions: [SCNVector3]
    var originalSpaceshipPositon: SCNVector3
    var spawnBarrierPositions: [SCNVector3]
    
    //for now
    private var spaceshipRow: SpaceshipRow
    
    override init() {
        originalSpaceshipPositon = SCNVector3()
        spaceshipPositions = []
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
    
    //generate the three posible positions and place the spaceship at the centered one
    func placeSpaceship(atPosition position: SCNVector3) {
        var mutablePosition = position
        mutablePosition.x += -0.2
        
        for index in 0..<3 {
            if index == 1{
                spaceShip.position = mutablePosition
                spaceshipRow = .center
            }
            spaceshipPositions.append(mutablePosition)
            mutablePosition.x += 0.2
        }
        rootNode.addChildNode(spaceShip)
        
        
        //SHOULD BE CALLED ON STARTGAME DELEGATE
        generateBarriers()
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
        spaceShip.runAction(SCNAction.move(to: spaceshipPositions[row.rawValue], duration: 0.2))
        
    }
    
    private func moveSpaceshipRight() {
        guard let row = SpaceshipRow(rawValue: spaceshipRow.rawValue + 1) else { return }
        
        spaceshipRow = row
        spaceShip.runAction(SCNAction.move(to: spaceshipPositions[row.rawValue], duration: 0.2))
    }
    
    
    func generateBarriers() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            let barrier = SCNNode(geometry: SCNSphere(radius: 0.1))
            let row = Int(arc4random_uniform(3))
            barrier.position = self.spawnBarrierPositions[row]
            var moveToPosition = self.spaceshipPositions[row]
            moveToPosition.z += 0.3
            
            self.rootNode.addChildNode(barrier)
            barrier.runAction(SCNAction.move(to: moveToPosition, duration: 0.7), completionHandler: {
                barrier.removeFromParentNode()
            })
        }
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
