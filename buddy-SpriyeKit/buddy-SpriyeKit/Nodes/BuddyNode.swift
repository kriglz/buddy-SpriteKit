//
//  BuddyNode.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/7/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class BuddyNode: SKSpriteNode {
    
    ///String which defines walking action.
    private let walkingActionKey = "action_walking"
    private let buddyWalkingFrame = [
        SKTexture(imageNamed: "buddyWalk1"),
        SKTexture(imageNamed: "buddyWalk2"),
        SKTexture(imageNamed: "buddyWalk3"),
        SKTexture(imageNamed: "buddyWalk4"),
        SKTexture(imageNamed: "buddyWalk5"),
        SKTexture(imageNamed: "buddyWalk6"),
        SKTexture(imageNamed: "buddyWalk7"),
        SKTexture(imageNamed: "buddyWalk8")
    ]
    
    
    ///Point which defines walking direction
    private var directionPoint: CGFloat = 0.0
    ///Defines how much walking speed is slowed down.
    private let easings: CGFloat = 0.012
    
    
    ///Creates a new buddy node.
    public static func newInstance() -> BuddyNode {
        let buddy = BuddyNode(imageNamed: "buddyStill")
        
        if let buddyTexture = buddy.texture {
            //Adding physics body of shape of still buddy.
            buddy.physicsBody = SKPhysicsBody.init(texture: buddyTexture, alphaThreshold: 0.1, size: buddy.size)
            buddy.physicsBody?.allowsRotation = false
            
            //Adding contactTestBitMask for buddy.
            buddy.physicsBody?.categoryBitMask = BuddyCategory
            buddy.physicsBody?.contactTestBitMask = WorldCategory | FloorCategory
        }
        return buddy
    }
    
    private var isWalking: Bool = false
    private var isJumping: Bool = false
    
    ///Updates skater on the screen.
    public func update(deltaTime: TimeInterval){
        
        //Cheks if buddy needs to walk.
        if !isWalking {
            
            //Sets walking action to nil.
            physicsBody?.velocity.dx = 0.0
            removeAction(forKey: walkingActionKey)
            texture = SKTexture(imageNamed: "buddyStill")

            if isJumping {
                
                //Limits height of jump.
                if position.y < size.height {
                
                    let jumpUpVector = CGVector(dx: 0.0, dy: position.y + size.height)
                    let buddyPoint = CGPoint(x: size.width / 2, y: size.height * 0.9)
                    let jumpAction = SKAction.applyForce(jumpUpVector, at: buddyPoint, duration: 0.05)
                
                    run(jumpAction)
                }
                
                isJumping = false
            }

        //Else - Adds walking action.
        } else {
            if action(forKey: walkingActionKey) == nil {
                let walkingAction = SKAction.repeatForever(
                    SKAction.animate(with: buddyWalkingFrame,
                                     timePerFrame: 0.1,
                                     resize: false,
                                     restore: false)
                )
                run(walkingAction, withKey: walkingActionKey)
            }
            
            let direction = frame.width * easings
            
            //Should move to left
            if directionPoint > 0 {
                position.x += direction
                xScale = 1
                
            //Else - Should move to right
            } else {
                position.x -= direction
                xScale = -1
            }

        }
        
            
    
    }
    
    
    ///Stops buddy at current position.
    public func stopWalking(){
        isWalking = false
    }
    
    ///Makes buddy to jump.
    public func jump(){
        isJumping = true
        isWalking = false
    }
    
    ///Sets destination point after touch action happens.
    public func setDestination(to direction: CGFloat){
        isWalking = true
        directionPoint = direction
    }
    
    ///Updates destiantion and position, after buddy is initiated.
    public func updatePosition(point: CGPoint){
        isWalking = false
        position = point
    }
    
    
}
