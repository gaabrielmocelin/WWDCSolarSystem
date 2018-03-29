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

public protocol GameFinishedDelegate {
    func gameIsOver()
    func gameIsCompleted()
}

public class GameScene: SCNScene {
    public  var spaceShip: SCNNode
    public var spaceshipPositions: [SCNVector3]
    public var originalSpaceshipPositon: SCNVector3
    public var spawnBarrierPositions: [SCNVector3]
    public var rowLines: [SCNNode] = []
    
    public var numberOfBarriersActive = 0
    
    //for now
    public var spaceshipRow: SpaceshipRow
    
    public var isGameRunning: Bool
    public var gameShouldFinish = false
    //algorythm time
    public var lastUpdate: TimeInterval
    public var lastUpdateConstants: TimeInterval
    //algorythm constants
    public var timeToSpawn: TimeInterval
    public  var barrierVelocity: TimeInterval
    
    //gameover delegate
    public var gameOverDelegate: GameFinishedDelegate?
    
    public var blackHole: SCNNode?
    public var smoke: SCNNode?
    
    public override init() {
        originalSpaceshipPositon = SCNVector3()
        spaceshipPositions = []
        spawnBarrierPositions = []
        timeToSpawn = 3.6
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
        guard let model3D = SCNScene(named: "SpaceshipModel3d.scn"), let spaceshipNode = model3D.rootNode.childNode(withName: "spaceship", recursively: true) else { return }
        
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
        addReactorsToTheShip()
        
        placeBlackHole(basedOnPosition: position)
    }
    
    func addReactorsToTheShip() {
        let particleSystem = SCNParticleSystem(named: "Reactor", inDirectory: nil)!
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
    
    func placeBlackHole(basedOnPosition position: SCNVector3) {
        var blackHolePosition = position
        blackHolePosition.z += 2
        
        let cylinder = SCNCylinder(radius: 0.4, height: 0.1)
        cylinder.setMaterial(with: UIImage(named: "BlackHole.png"), constant: true)
        let blackHole = SCNNode(geometry: cylinder)
        blackHole.position = blackHolePosition
        blackHole.eulerAngles.x = Float(90).radians
        self.blackHole = blackHole
        rootNode.addChild(blackHole)
    }
    
    public func generateSpawnPositions(withPosition position: SCNVector3) {
        var mutablePosition = position
        mutablePosition.x += -0.3
        mutablePosition.z += -1.5
        
        for _ in 0..<3 {
            spawnBarrierPositions.append(mutablePosition)
            mutablePosition.x += 0.3
        }
        
        setupGameFloor()
        setupGameGenerateBox()
    }
    
    func setupGameGenerateBox() {
        let position = spawnBarrierPositions[1]
        let particleSystem = SCNParticleSystem(named: "Smoke", inDirectory: nil)!
        let particleEmitter = SCNNode()
        particleEmitter.position = position
        particleEmitter.addParticleSystem(particleSystem)
        rootNode.addChild(particleEmitter)
        
        smoke = particleEmitter
    }
    
    func setupGameFloor() {
        var position = spawnBarrierPositions[1]
        position.y -= 0.2
        
        let particleSystem = SCNParticleSystem(named: "GameFloor", inDirectory: nil)!
        let particleEmitter = SCNNode()
        particleEmitter.position = position
        particleEmitter.addParticleSystem(particleSystem)
        rootNode.addChild(particleEmitter)
    }
    
    func moveSpaceshipLeft() {
        guard let row = SpaceshipRow(rawValue: spaceshipRow.rawValue - 1) else { return }
        
        spaceshipRow = row
        spaceShip.runAction(SCNAction.move(to: spaceshipPositions[row.rawValue], duration: 0.2))
        spaceShip.runAction(SCNAction.rotateBy(x: 0, y: 0, z: 0.7, duration: 0.15)) {
            self.spaceShip.runAction(SCNAction.rotateBy(x: 0, y: 0, z: -0.7, duration: 0.05))
        }
        
    }
    
    func moveSpaceshipRight() {
        guard let row = SpaceshipRow(rawValue: spaceshipRow.rawValue + 1) else { return }
        
        spaceshipRow = row
        spaceShip.runAction(SCNAction.move(to: spaceshipPositions[row.rawValue], duration: 0.2))
        spaceShip.runAction(SCNAction.rotateBy(x: 0, y: 0, z: -0.7, duration: 0.15)) {
            self.spaceShip.runAction(SCNAction.rotateBy(x: 0, y: 0, z: 0.7, duration: 0.05))
        }
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
        if !gameShouldFinish{
            
            numberOfBarriersActive += 1
            
            let sphere = SCNSphere(radius: 0.1)
            sphere.setMaterial(with: randomTextureForBarrier())
            let barrier = SCNNode(geometry: sphere)
            var starterPosition = self.spawnBarrierPositions[row]
            starterPosition.z += -0.1
            barrier.position = starterPosition
            barrier.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
            barrier.physicsBody?.isAffectedByGravity = false
            barrier.physicsBody?.categoryBitMask = CategoryBitMask.barrier
            barrier.physicsBody?.collisionBitMask = CategoryBitMask.spaceship
            barrier.physicsBody?.contactTestBitMask = CategoryBitMask.spaceship
            var moveToPosition = self.spaceshipPositions[row]
            moveToPosition.z += 1
            
            self.rootNode.addChild(barrier)
            barrier.runAction(SCNAction.move(to: moveToPosition, duration: barrierVelocity), completionHandler: {
                barrier.removeFromParentNode()
                self.numberOfBarriersActive -= 1
                
                if self.gameShouldFinish, self.numberOfBarriersActive == 0, self.isGameRunning{
                    self.isGameRunning = false
                    self.arriveOnNewPlanet()
                }
            })
        }
    }
    
    func randomTextureForBarrier() -> UIImage?{
        let index = arc4random_uniform(3)
        
        return UIImage(named: "comet\(index).jpg")
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
            
            rowLines.append(rowLine)
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
        self.isGameRunning = true
    }
    
    public func CompleteGame() {
        gameShouldFinish = true
    }
}

extension GameScene{
    func arriveOnNewPlanet()  {
        guard let blackHole = blackHole else { return }
        
        blackHole.runAction(SCNAction.scale(to: 0, duration: 1)) {
            blackHole.removeFromParentNode()
        }
        
        rowLines.forEach { (row) in
            row.runAction(SCNAction.scale(to: 0, duration: 1), completionHandler: {
                row.removeFromParentNode()
            })
        }
        
        smoke?.removeFromParentNode()
        
        let newPlanetPosition = spawnBarrierPositions[1]
        let sphere = SCNSphere(radius: 0.3)
        sphere.setMaterial(with: UIImage(named: "NewPlanet.png"))
        let newPlanet = SCNNode(geometry: sphere)
        newPlanet.scale = SCNVector3(0, 0, 0)
        newPlanet.position = newPlanetPosition
        rootNode.addChild(newPlanet)
        newPlanet.runAction(SCNAction.scale(to: 1, duration: 1)) {
            self.moveSpaceShipToNewPlanet()
        }
    }
    
    func moveSpaceShipToNewPlanet() {
        var position = spawnBarrierPositions[1]
        position.y += 0.45
        spaceShip.runAction(SCNAction.move(to: position, duration: 3)) {
            position.y -= 0.2
            self.spaceShip.runAction(SCNAction.move(to: position, duration: 5), completionHandler: {
                self.gameCompleted()
            })
        }
    }
    
    func gameCompleted() {
        gameOverDelegate?.gameIsCompleted()
    }
}

extension GameScene: SCNPhysicsContactDelegate{
    public func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let spaceshipPosition = spaceShip.position
        
        let particleSystem = SCNParticleSystem(named: "FireExplosion", inDirectory: nil)!
        let particleEmitter = SCNNode()
        particleEmitter.position = spaceshipPosition
        particleEmitter.addParticleSystem(particleSystem)
        rootNode.addChild(particleEmitter)
        
        contact.nodeA.removeFromParentNode()
        contact.nodeB.removeFromParentNode()
        
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
            if timeToSpawn > 1{
                timeToSpawn -= 0.3
            }
            if barrierVelocity > 1{
                barrierVelocity -= 0.1
            }
            
            print("timespawn \(timeToSpawn) --- barriervelocity \(barrierVelocity)")
            lastUpdateConstants = time
        }
    }
    
}

extension GameScene: ARSCNViewDelegate{
    
}

