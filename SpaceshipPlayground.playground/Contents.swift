//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))

let vc = ViewController()

PlaygroundSupport.PlaygroundPage.current.liveView = vc
