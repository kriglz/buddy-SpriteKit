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
    private var direction: Direction = .none
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
    
    private(set) var isWalking: Bool = false
    private(set) var walkingSpeed: CGFloat = 0.0
    
    ///Updates skater on the screen.
    public func update(deltaTime: TimeInterval){
        
        //Cheks if buddy needs to walk.
        if !isWalking {
            
            //Sets walking action to nil.
//            isWalking = false
            physicsBody?.velocity.dx = 0.0
            removeAction(forKey: walkingActionKey)
            texture = SKTexture(imageNamed: "buddyStill")

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
            
            let delta = frame.width * easings
            
            walkingSpeed = delta
            
            //Should move to left
            switch direction {
            case .left:
                position.x -= delta
                xScale = -1
            case .right:
                position.x += delta
                xScale = 1
            case .none:
                break
            }
        }
    }
    
    
     
    ///Sets destination point after touch action happens.
    public func walk(_ towards: Direction){
        direction = towards
        if direction == .none {
            isWalking = false
        } else {
            isWalking = true
        }
    }
    
    ///Updates destiantion and position, after buddy is initiated.
    public func updatePosition(point: CGPoint){
        direction = .none
        position = point
    }
}
