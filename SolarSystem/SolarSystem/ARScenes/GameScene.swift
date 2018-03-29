//
//  GameScene.swift
//  SolarSystem
//
//  Created by Gabriel Mocelin on 21/03/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import ARKit
import SceneKit

public enum SpaceshipRow: Int {
    case left
    case center
    case right
}

public enum Difficulty: Int {
    case easy
    case hard
}

public struct CategoryBitMask {
    public static let spaceship: Int = 0b0001
    static let barrier: Int = 0b0010
}

public struct LightType {
    public static let light1: Int = 0x1 << 1
    public static let light2: Int = 0x1 << 2
}

public protocol GameOverDelegate {
    func gameIsOver()
}

public class GameScene: SCNScene {
    public  var spaceShip: SCNNode
    public var spaceshipPositions: [SCNVector3]
    public var originalSpaceshipPositon: SCNVector3
    public var spawnBarrierPositions: [SCNVector3]
    
    //for now
    public var spaceshipRow: SpaceshipRow
    
    public var isGameRunning: Bool
    //algorythm time
    public var lastUpdate: TimeInterval
    public var lastUpdateConstants: TimeInterval
    //algorythm constants
    public var timeToSpawn: TimeInterval
    public  var barrierVelocity: TimeInterval
    
    //gameover delegate
    public var gameOverDelegate: GameOverDelegate?
    
    public override init() {
        originalSpaceshipPositon = SCNVector3()
        spaceshipPositions = []
        spawnBarrierPositions = []
        timeToSpawn = 3
        barrierVelocity = 3
        lastUpdate = 0
        lastUpdateConstants = 0
        isGameRunning = false
        spaceShip = SCNNode()
        spaceshipRow = .center
        super.init()
        
        physicsWorld.contactDelegate = self
        setupAmbientLight()
        setupSpaceship()
    }
    
    func setupAmbientLight() {
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.categoryBitMask = LightType.light1
        let node = SCNNode()
        node.light = ambientLight
        node.light?.intensity = 500
        rootNode.addChildNode(node)
    }
    
    func setupSpaceship() {
        guard let model3D = SCNScene(named: "art.scnassets/SpaceshipModel3d.scn"), let spaceshipNode = model3D.rootNode.childNode(withName: "spaceship", recursively: true) else { return }
        
        spaceShip = spaceshipNode
        spaceShip.categoryBitMask = LightType.light1
        
        spaceShip.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        spaceShip.physicsBody?.isAffectedByGravity = false
        spaceShip.physicsBody?.categoryBitMask = CategoryBitMask.spaceship
        spaceShip.physicsBody?.collisionBitMask = CategoryBitMask.barrier
        spaceShip.physicsBody?.contactTestBitMask = CategoryBitMask.barrier
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //generate the three posible positions and place the spaceship at the centered one
    public func placeSpaceship(atPosition position: SCNVector3) {
        var mutablePosition = position
        mutablePosition.x += -0.3
        
        for index in 0..<3 {
            if index == 1{
                spaceShip.position = mutablePosition
                spaceshipRow = .center
            }
            spaceshipPositions.append(mutablePosition)
            mutablePosition.x += 0.3
        }
        rootNode.addChild(spaceShip)
        
        
        //REFACTORRR *******************
        
        let particleSystem = SCNParticleSystem(named: "Reactor", inDirectory: "art.scnassets")!
        let particleEmitter = SCNNode()
        particleEmitter.addParticleSystem(particleSystem)
        
        let particleEmitter2 = SCNNode()
        particleEmitter2.addParticleSystem(particleSystem)
        
        spaceShip.addChild(particleEmitter)
        particleEmitter.position.x += -1.5
        particleEmitter.position.y += 2
        particleEmitter.position.z += 3.5
        
        spaceShip.addChild(particleEmitter2)
        particleEmitter2.position.x += 1.5
        particleEmitter2.position.y += 2
        particleEmitter2.position.z += 3.3
    }
    
    public func generateSpawnPositions(withPosition position: SCNVector3) {
        var mutablePosition = position
        mutablePosition.x += -0.3
        mutablePosition.z += -1.5
        
        for _ in 0..<3 {
            spawnBarrierPositions.append(mutablePosition)
            let node = SCNNode(geometry: SCNCone(topRadius: 0.01, bottomRadius: 0.01, height: 0.01))
            node.position = mutablePosition
            rootNode.addChild(node)
            mutablePosition.x += 0.3
        }
        
        setupGameFloor()
    }
    
    func setupGameFloor() {
        var position = spawnBarrierPositions[1]
        position.y -= 0.2
        
        let particleSystem = SCNParticleSystem(named: "GameFloor", inDirectory: "art.scnassets")!
        let particleEmitter = SCNNode()
        particleEmitter.position = position
        particleEmitter.addParticleSystem(particleSystem)
        rootNode.addChild(particleEmitter)
    }
    
    func moveSpaceshipLeft() {
        guard let row = SpaceshipRow(rawValue: spaceshipRow.rawValue - 1) else { return }
        
        spaceshipRow = row
        spaceShip.runAction(SCNAction.move(to: spaceshipPositions[row.rawValue], duration: 0.2))
        
    }
    
    func moveSpaceshipRight() {
        guard let row = SpaceshipRow(rawValue: spaceshipRow.rawValue + 1) else { return }
        
        spaceshipRow = row
        spaceShip.runAction(SCNAction.move(to: spaceshipPositions[row.rawValue], duration: 0.2))
    }
    
    func randomlySpawnBarriers() {
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
        let sphere = SCNSphere(radius: 0.1)
        sphere.setMaterial(with: randomTextureForBarrier())
        let barrier = SCNNode(geometry: sphere)
        barrier.position = self.spawnBarrierPositions[row]
        barrier.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        barrier.physicsBody?.isAffectedByGravity = false
        barrier.physicsBody?.categoryBitMask = CategoryBitMask.barrier
        barrier.physicsBody?.collisionBitMask = CategoryBitMask.spaceship
        barrier.physicsBody?.contactTestBitMask = CategoryBitMask.spaceship
        var moveToPosition = self.spaceshipPositions[row]
        moveToPosition.z += 0.7
        
        self.rootNode.addChild(barrier)
        barrier.runAction(SCNAction.move(to: moveToPosition, duration: barrierVelocity), completionHandler: {
            barrier.removeFromParentNode()
        })
    }
    
    func randomTextureForBarrier() -> UIImage?{
        let index = arc4random_uniform(3)
        
        return UIImage(named: "art.scnassets/comet\(index).jpg")
    }
    
    public func generateRowLines(withPosition position: SCNVector3) {
        guard let barrierPosition = spawnBarrierPositions.first, let spaceshipPosition = spaceshipPositions.first else { return }
        let height = spaceshipPosition.z - barrierPosition.z
        var linePosition = spaceshipPosition
        linePosition.x -= 0.15
        linePosition.z += (height / 2) * -1
        linePosition.y -= 0.05
        
        for _ in 0..<4 {
            let capsule = SCNCapsule(capRadius: 0.005, height: CGFloat(height))
            let rowLine = SCNNode(geometry: capsule)
            rowLine.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(90), y: 0, z: 0)
            rowLine.position = linePosition
            rootNode.addChild(rowLine)
            linePosition.x += 0.3
            
            let material = SCNMaterial()
            
            //CHANGE COLORRR *****************
            material.diffuse.contents = UIColor(red: 34/255, green: 136/255, blue: 221/255, alpha: 1)
            capsule.materials = [material]
            
            let light = SCNLight()
            light.categoryBitMask = LightType.light2
            light.type = .omni
            light.color = UIColor.green
            light.intensity = 5000
            rowLine.light = light
        }
    }
}

extension GameScene: GamePerformer{
    public func didSwipe(_ direction: UISwipeGestureRecognizerDirection) {
        if isGameRunning{
            if direction == .left, !(spaceshipRow == .left){
                moveSpaceshipLeft()
            }else if direction == .right, !(spaceshipRow == .right){
                moveSpaceshipRight()
            }
        }
    }
    
    public func startGame() {
        isGameRunning = true
    }
}

extension GameScene: SCNPhysicsContactDelegate{
    public func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        spaceShip.removeFromParentNode()
        
        isGameRunning = false
        gameOverDelegate?.gameIsOver()
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let deltaTime = time - lastUpdate
        if isGameRunning, deltaTime > timeToSpawn {
            randomlySpawnBarriers()
            lastUpdate = time
        }
        
        let deltaConstantsTime = time - lastUpdateConstants
        if isGameRunning, deltaConstantsTime > 5{
            if timeToSpawn > 0.7{
                timeToSpawn -= 0.3
            }
            if barrierVelocity > 1{
                barrierVelocity -= 0.2
            }
            
            print("timespawn \(timeToSpawn) --- barriervelocity \(barrierVelocity)")
            lastUpdateConstants = time
        }
    }
    
}

extension GameScene: ARSCNViewDelegate{
  
}
