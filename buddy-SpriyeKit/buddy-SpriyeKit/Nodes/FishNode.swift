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
    let fishScaleConstant = CGFloat(drand48())

    ///Creates new fish node.
    public func newInstance(size: CGSize) -> FishNode {
        
        let fish = FishNode(imageNamed: "fish\(randFishNumber)")
        
        if fish.texture != nil {
            
            fish.size = CGSize(
                width: (size.width / 9.6) * (0.8 + 0.5 * fishScaleConstant),
                height: (size.height / 7.94) * (0.8 + 0.5 * fishScaleConstant))
            fish.position = CGPoint(
                x: CGFloat(arc4random_uniform(UInt32(size.width))),
                y: size.height / 4 - 120 * fishScaleConstant)
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
    
    ///Adds swim animation to the fish.
    public func swim(){
        var fishFrame = fishSwimFrame2
        if self.randFishNumber == 1 {
            fishFrame = fishSwimFrame1
        }
        
        let swimAction = SKAction.repeatForever(
            SKAction.animate(with: fishFrame, timePerFrame: Double(0.1 * (1 + 2 * fishScaleConstant))))
        
        run(swimAction)
    }
    
    
    ///Adds swim-move action to the fish.
    public func move(){
        
        let scaleConstant = drand48() * 0.8
        
        self.alpha = 0.0
        
        let fadeInAnimation = SKAction.fadeIn(withDuration: 5 * (1 + scaleConstant))
        let moveToPointAnimation = SKAction.move(to: CGPoint(x: self.position.x - (50 * (1 + CGFloat(scaleConstant))), y: self.position.y - 10),
                                                 duration: 5 * (1 + scaleConstant))
        let groupAction1 = SKAction.group([moveToPointAnimation,
                                           fadeInAnimation])
        
        
        let flipAnimation = SKAction.run { [weak self] in
            self?.xScale *= -1
        }
        
        let moveBackToPointAnimation = SKAction.move(to: CGPoint(x: self.position.x + 20 * (1 + CGFloat(scaleConstant)), y: self.position.y - 10), duration: 1.0  * (1 + scaleConstant))
        let fadeOutAniamtion = SKAction.fadeOut(withDuration: 1.0  * (1 + scaleConstant))
        let groupAction2 = SKAction.group([moveBackToPointAnimation,
                                          fadeOutAniamtion])
        
        
        let removeAction = SKAction.removeFromParent()
        
        let sequenceOfAnimations = SKAction.sequence([groupAction1,
                                                      flipAnimation,
                                                      groupAction2,
                                                      removeAction])
        
        run(sequenceOfAnimations)
    }
    
    
    public func jump(){
        
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
        
        let duration = Double(randAnimationCount) / 20 + 0.2
        
        let jumpAction = SKAction.applyImpulse(CGVector(dx: -30.0, dy: 200.0), duration: duration)
        
        let flipAction = SKAction.applyAngularImpulse(-1.0, duration: 20.0)
        
        let swimJumpSequence = SKAction.sequence([swimAction, changeStateAction, jumpAction, flipAction])
        
        run(swimJumpSequence)
    }
    
}
