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

enum Difficulty: Int {
    case easy
    case hard
}

struct CategoryBitMask {
    static let spaceship: Int = 0b0001
    static let barrier: Int = 0b0010
}

class GameScene: SCNScene {
    var spaceShip: SCNNode
    var spaceshipPositions: [SCNVector3]
    var originalSpaceshipPositon: SCNVector3
    var spawnBarrierPositions: [SCNVector3]
    
    //for now
    private var spaceshipRow: SpaceshipRow
    
    //algorythm timer
    private var barrierVelocityTimer: Timer?
    private var spawnTimer: Timer?
    //algorythm constants
    private var timeToSpawn: TimeInterval
    private var barrierVelocity: TimeInterval
    
    override init() {
        originalSpaceshipPositon = SCNVector3()
        spaceshipPositions = []
        spawnBarrierPositions = []
        timeToSpawn = 3
        barrierVelocity = 3
        spaceShip = SCNNode(geometry: SCNPyramid(width: 0.05, height: 0.03, length: 0.12))
        spaceshipRow = .center
        super.init()
        
        physicsWorld.contactDelegate = self
        setupSpaceshipPhysicsBody()
    }
    
    func setupSpaceshipPhysicsBody() {
        spaceShip.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        spaceShip.physicsBody?.isAffectedByGravity = false
        spaceShip.physicsBody?.categoryBitMask = CategoryBitMask.spaceship
        spaceShip.physicsBody?.collisionBitMask = CategoryBitMask.barrier
        spaceShip.physicsBody?.contactTestBitMask = CategoryBitMask.barrier
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
        
        
        //SHOULD BE CALLED ON START GAME DELEGATE *************
        spawnBarriers(withTime: timeToSpawn)
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
    
    func spawnBarriers(withTime time: TimeInterval) {
        barrierVelocityTimer?.invalidate()
        spawnTimer?.invalidate()
        spawnTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(randomlySpawnBarriers), userInfo: nil, repeats: true)
        barrierVelocityTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { (_) in
            if self.barrierVelocity > 0.7 {
                self.barrierVelocity -= 0.3
                if self.barrierVelocity.truncatingRemainder(dividingBy: 2) == 0 {
                    self.timeToSpawn -= 0.3
                    print("time to spawn \(self.timeToSpawn) -- barriervelocity \(self.barrierVelocity)")
                    self.spawnBarriers(withTime: self.timeToSpawn)
                }
            }else if self.barrierVelocity <= 0.7, self.timeToSpawn > 0.7{
                print("print 2 time to spawn \(self.timeToSpawn) -- barriervelocity \(self.barrierVelocity)")
                self.timeToSpawn -= 0.3
            }
        }
    }
    
    
    @objc func randomlySpawnBarriers() {
        guard let difficulty = Difficulty(rawValue: Int(arc4random_uniform(2))) else { return }
        
        switch difficulty {
        case .easy:
            let row = Int(arc4random_uniform(3))
            generateBarrier(atRow: row)
        case .hard:
            let firstRow = Int(arc4random_uniform(3))
            var secondRow = Int(arc4random_uniform(3))
            while secondRow == firstRow {
                secondRow = Int(arc4random_uniform(3))
            }
            generateBarrier(atRow: firstRow)
            generateBarrier(atRow: secondRow)
        }
    }
    
    func generateBarrier(atRow row: Int) {
        let barrier = SCNNode(geometry: SCNSphere(radius: 0.1))
        barrier.position = self.spawnBarrierPositions[row]
        barrier.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        barrier.physicsBody?.isAffectedByGravity = false
        barrier.physicsBody?.categoryBitMask = CategoryBitMask.barrier
        barrier.physicsBody?.collisionBitMask = CategoryBitMask.spaceship
        barrier.physicsBody?.contactTestBitMask = CategoryBitMask.spaceship
        var moveToPosition = self.spaceshipPositions[row]
        moveToPosition.z += 0.3
        
        self.rootNode.addChildNode(barrier)
        barrier.runAction(SCNAction.move(to: moveToPosition, duration: barrierVelocity), completionHandler: {
            barrier.removeFromParentNode()
        })
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

extension GameScene: SCNPhysicsContactDelegate{
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        print("CONTACT CARAAAIIII")
    }
    
}

extension GameScene: ARSCNViewDelegate{
  
}
