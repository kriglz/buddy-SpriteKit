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
    private var destination: CGPoint!
    ///Defines how much walking speed is slowed down.
    private let easings: CGFloat = 0.1
    
    
    ///Creates a new buddy node.
    public static func newInstance() -> BuddyNode {
        let buddy = BuddyNode(imageNamed: "buddyStill")
        
        if let buddyTexture = buddy.texture {
            
            buddy.physicsBody = SKPhysicsBody.init(texture: buddyTexture, alphaThreshold: 1.0, size: buddy.size)
            
            buddy.physicsBody?.allowsRotation = false
            
            //Adding contactTestBitMask for buddy.
            buddy.physicsBody?.categoryBitMask = BuddyCategory
            buddy.physicsBody?.contactTestBitMask = WorldCategory
        }
        
        return buddy
    }
    
    
    ///Updates skater on the screen.
    public func update(deltaTime: TimeInterval){ //, itemLocation: CGPoint){
        
        
        
        //Cheks if buddy needs to walk.
        if abs(destination.x - position.x) < 2 {
            
            physicsBody?.velocity.dx = 0
            removeAction(forKey: walkingActionKey)
            texture = SKTexture(imageNamed: "buddyStill")
            
            
        } else {
            
            //Adds walking action.
            if action(forKey: walkingActionKey) == nil {
                let walkingAction = SKAction.repeatForever(
                    SKAction.animate(with: buddyWalkingFrame,
                                     timePerFrame: 0.1,
                                     resize: false,
                                     restore: false)
                )
                run(walkingAction, withKey: walkingActionKey)
            }
            
            ///The distance from buddy to the `touchPoint`.
            let distance = sqrt(pow((destination.x - position.x), 2) + pow((destination.y - position.y), 2))
            
            //Sets the buddy speed.
            if distance > 1 {
                let directionX = destination.x - position.x
//                let directionY = destination.y - position.y
                
                position.x += directionX * easings
                //            position.y += directionY * easings
            } else {
                position.x = destination.x
            }
            
            if destination.x < position.x {
                xScale = -1
            } else {
                xScale = 1
            }
        }
            
            
            
        
       
        
        
        
        
        
        
        
       
        
    }
    
    ///Sets destination point after touch action happens.
    public func setDestination(destination: CGPoint){
        self.destination = destination
    }
    
    ///Updates destiantion and position, after buddy is initiated.
    public func updatePosition(point: CGPoint){
        position = point
        destination = point
    }
    
    
}
