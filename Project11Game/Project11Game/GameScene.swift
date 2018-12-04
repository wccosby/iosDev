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
    }
    
    ///////////////
    // called whenever someone touches the device
    ////////////////
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first { // a set is passed in, if people touch multiple times at once
            let location = touch.location(in: self)
            let box = SKSpriteNode(color: UIColor.red, size: CGSize(width: 64, height: 64))
            box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
            box.position = location
            addChild(box)
        }
    }
}
