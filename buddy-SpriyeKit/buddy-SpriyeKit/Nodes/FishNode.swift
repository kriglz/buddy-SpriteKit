//
//  FishNode.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/19/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class FishNode: SKSpriteNode {
    
    var fishSwimFrame = [
        SKTexture(imageNamed: "fishswing1"),
        SKTexture(imageNamed: "fishswing2"),
        SKTexture(imageNamed: "fishswing3")
    ]
    
    public static func newInstance(size: CGSize) -> FishNode{
    
        let fish = FishNode(imageNamed: "fishswing1") // \(arc4random_uniform(2)+1)")
        
        if fish.texture != nil {
            
            fish.size = CGSize(width: size.width / 9.6, height: size.height / 7.94)
            fish.position = CGPoint(x: size.width / 2 + CGFloat(arc4random_uniform(200)), y: size.height / 3 - CGFloat(arc4random_uniform(200)))
            fish.zPosition = zPositionFish

            fish.physicsBody = SKPhysicsBody.init(
                texture: SKTexture(imageNamed: "fishFly"),
                alphaThreshold: 0.1,
                size: CGSize(width: fish.size.height, height: fish.size.width))
            
            fish.physicsBody?.categoryBitMask = FishCategory
            fish.physicsBody?.contactTestBitMask = WorldCategory
            fish.physicsBody?.collisionBitMask = 0
            fish.physicsBody?.affectedByGravity = false
        }
        
        return fish
    }
    
    
    public func swim(){
        
        let animationCount = Int(arc4random_uniform(10))
        
        let swimAction = SKAction.repeat(
            SKAction.animate(with: fishSwimFrame, timePerFrame: 0.3),
            count: animationCount)
        
        let changeStateAction = SKAction.run { [weak self] in
            self?.texture = SKTexture(imageNamed: "fishFly")
            self?.size = CGSize(width: (self?.size.height)!, height: (self?.size.width)!)
            self?.physicsBody?.affectedByGravity = true
        }
        
        let jumpAction = SKAction.applyImpulse(CGVector(dx: -30.0, dy: 200.0), duration: 0.50)
        
        let flipAction = SKAction.applyAngularImpulse(-1.0, duration: 20.0)
        
        let swimJumpSequence = SKAction.sequence([swimAction, changeStateAction, jumpAction, flipAction])
        
        run(swimJumpSequence)
    }
    
}
