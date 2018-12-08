//
//  GameScene.swift
//  Project11Game
//
//  Created by William Cosby on 12/4/18.
//  Copyright © 2018 William Cosby. All rights reserved.
//
import SpriteKit

class GameScene: SKScene {
    
    ////////////////
    // this is like UIKit's viewDidLoad method
    ////////////////
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "Content/background.jpg")
        background.position = CGPoint(x: 512, y:384) // placing at the center of our canvas
        background.blendMode = .replace // ?
        background.zPosition = -1 // put it behind everything else
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        // make bouncers
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
        // make target slots
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
    }
    
    ///////////////
    // called whenever someone touches the device
    ////////////////
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first { // a set is passed in, if people touch multiple times at once
            let location = touch.location(in: self)
//            let box = SKSpriteNode(color: UIColor.red, size: CGSize(width: 64, height: 64))
//            box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
//            box.position = location
//            addChild(box)
            
            let ball = SKSpriteNode(imageNamed: "Content/ballRed")
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
            ball.physicsBody?.restitution = 0.4 // this is the "bounciness" of the body
            ball.position = location
            addChild(ball)
        }
    }
    
    ///////////////
    // creates a bouncer at the specified point
    ////////////////
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "Content/bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false // if this is false then the object will not be moved by things like gravity or collisions
        addChild(bouncer)
    }
    
    ///////////////
    // makes a target slot at the position, and effect
    ////////////////
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "Content/slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "Content/slotGlowGood")
        } else {
            slotBase = SKSpriteNode(imageNamed: "Content/slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "Content/slotGlowBad")
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10) // rotate 180 degrees in 10 seconds
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
}
