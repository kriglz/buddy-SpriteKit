//
//  FishNode.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/19/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class FishNode: SKSpriteNode {
    
    var fishSwimFrame1 = [
        SKTexture(imageNamed: "fishswing11"),
        SKTexture(imageNamed: "fishswing21"),
        SKTexture(imageNamed: "fishswing31")
    ]
    
    var fishSwimFrame2 = [
        SKTexture(imageNamed: "fishswing12"),
        SKTexture(imageNamed: "fishswing22"),
        SKTexture(imageNamed: "fishswing32")
    ]
    
    let randFishNumber = arc4random_uniform(2) + 1

    
    public func newInstance(size: CGSize) -> FishNode {
        
        
        let fish = FishNode(imageNamed: "fish\(randFishNumber)")
        
        if fish.texture != nil {
            
            fish.size = CGSize(width: size.width / 9.6, height: size.height / 7.94)
            fish.position = CGPoint(x: size.width / 2 + CGFloat(arc4random_uniform(200)), y: size.height / 3 - CGFloat(arc4random_uniform(200)))
            fish.zPosition = zPositionFish

            fish.physicsBody = SKPhysicsBody.init(
                texture: SKTexture(imageNamed: "fishFly\(randFishNumber)"),
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
        
        var fishFrame = fishSwimFrame2
        if self.randFishNumber == 1 {
            fishFrame = fishSwimFrame1
        }
        
        let randAnimationCount = Int(arc4random_uniform(10))
        
        let swimAction = SKAction.repeat(
            SKAction.animate(with: fishFrame, timePerFrame: 0.3),
            count: randAnimationCount)
        
        
        let changeStateAction = SKAction.run { [weak self] in
            
            if let randFishNumber = self?.randFishNumber {
                self?.texture = SKTexture(imageNamed: "fishFly\(Int(randFishNumber))")                
            }
            self?.size = CGSize(width: (self?.size.height)!, height: (self?.size.width)!)
            self?.physicsBody?.affectedByGravity = true
        }
        
        let jumpAction = SKAction.applyImpulse(CGVector(dx: -30.0, dy: 200.0), duration: 0.50)
        
        let flipAction = SKAction.applyAngularImpulse(-1.0, duration: 20.0)
        
        let swimJumpSequence = SKAction.sequence([swimAction, changeStateAction, jumpAction, flipAction])
        
        run(swimJumpSequence)
    }
    
}
