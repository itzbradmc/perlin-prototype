//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit
import GameKit
import GameplayKit
import MetalKit
import SceneKit
import Foundation
import CoreFoundation



class GameScene: SKScene {
    
    struct Point{
        var x: CGFloat
        var y: CGFloat
        var element: SKShapeNode
        var intensity: Double
    }
    
    struct Ball{
        var x: CGFloat
        var y: CGFloat
        var element: SKShapeNode
    }
    
    let height_pixels = 10
    var width_pixels = 0
    
    var hasSetup: Bool = false
    
    var noiseMap: GKNoiseMap!
    
    var texture: SKTexture!
    
    var ball: Ball!
    
    var noiseResultList: Array<Float> = Array();
    
    func setup(){
        
        
        
        width_pixels = Int(self.frame.width)
        
        let source: GKRidgedNoiseSource = GKRidgedNoiseSource(frequency: 1, octaveCount: 3, lacunarity: 2, seed: 2)
        let noise: GKNoise = GKNoise(source)
        noiseMap = GKNoiseMap(noise, size: vector_double2(3.0, 3.0), origin: vector_double2(0, 0), sampleCount: vector_int2(Int32(width_pixels)), seamless: true)
        texture = SKTexture.init(noiseMap: noiseMap)
        
        let ballRect = CGRect(x: 0, y: 0, width: 10, height: 10)
        let ballNode = SKShapeNode.init(rect: ballRect)
        ballNode.fillColor = .red
        ball = Ball.init(x: 0, y: 0, element: ballNode)
        
//        for coord_y in 0..<height_pixels{
//            for coord_x in 0..<width_pixels{
//                let vector: vector_int2 = vector_int2(Int32(coord_x), Int32(coord_y))
//                let result = noiseMap.value(at: vector)
//                noiseResultList.append(result)
//            }
//        }
        
        
        let textureNode = SKSpriteNode(texture: texture)
        self.addChild(textureNode)
        self.addChild(ballNode)
        let cam = SKCameraNode()
        self.camera = cam
        self.addChild(cam)
        
        hasSetup = true
    }
    
    func lerp(from fromColor: NSColor, to toColor: NSColor, with progress: CGFloat) -> NSColor{
        let r = (1 - progress) * fromColor.redComponent + progress * toColor.redComponent
        let g = (1 - progress) * fromColor.greenComponent + progress * toColor.greenComponent
        let b = (1 - progress) * fromColor.blueComponent + progress * toColor.blueComponent
        let a = (1 - progress) * fromColor.alphaComponent + progress * toColor.alphaComponent
        return NSColor(red: r, green: g, blue: b, alpha: a)
    }
    
    func addNewPoint(x: Double, y: Double, result: Float){
        let pointElementRect = CGRect(x: (x*10)-250, y: (y*10)-375, width: 10, height: 10)
        let pointElementNode = SKShapeNode(rect: pointElementRect)
        let color = lerp(from: NSColor.red, to: NSColor.green, with: CGFloat(result))
        pointElementNode.fillColor = color
        pointElementNode.strokeColor = color
        self.addChild(pointElementNode)
    }
    @objc static override var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }
    
    override func keyDown(with event: NSEvent){
        print(event.keyCode)//13 == W 0 == A 2 == D 1 == S
        if(ball != nil){
            if(event.keyCode == 13){
                let x = ball.element.position.x
                let y = ball.element.position.y
                ball.element.position = CGPoint(x: x, y: y+5)
                let value: Float = noiseMap.value(at: vector_int2(Int32(x), Int32(y)))
                print(value)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(hasSetup == false){
            print("started")
            setup()
        }
        if(hasSetup == true){
            
        }
    }
    
}




// Load the SKScene
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 500, height: 750))
if let scene = GameScene(fileNamed: "") {
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill
    
    // Present the scene
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
