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
    
    
    
    ///Defines walking direction or stop position as `.none`.
    private var direction: Direction = .none
    
    
    /// Shows if buddy is moving / in walking action.
    private(set) var isWalking: Bool = false
    
    /// Buddy node walking speed relative to the ground in POINTS per SEC.
    private(set) var walkingSpeed: CGFloat = 144.0
    
    
    /// Calculates time since lasts stop to manage when the speed needs to increase.
    private var timeSinceLastStop: Double = 0.0
    
    
    
    ///Updates skater on the screen.
    public func update(deltaTime: TimeInterval){
        
        //Cheks if buddy needs to walk.
        if !isWalking {
            
            //Sets walking action to nil.
            physicsBody?.velocity.dx = 0.0
            removeAction(forKey: walkingActionKey)
            texture = SKTexture(imageNamed: "buddyStill")
            timeSinceLastStop = 0.0
            
        //Else - Adds walking action.
        } else {
            
            if action(forKey: walkingActionKey) == nil {
                
                let frameTime = Double(walkingSpeed) * deltaTime / 30.0
                
                //Initial one time slower action.
                let startingAction = SKAction.repeat( SKAction.animate(with: buddyWalkingFrame,
                                                                       timePerFrame: frameTime * 1.5, // = 0.12
                                                                       resize: false,
                                                                       restore: false),
                                                      count: 1)
                
                //Main walking action.
                let walkingAction = SKAction.repeatForever( SKAction.animate(with: buddyWalkingFrame,
                                     timePerFrame: frameTime,
                                     resize: false,
                                     restore: false)
                )
                
                let actions = SKAction.sequence([startingAction, walkingAction])
                
                
                run(actions, withKey: walkingActionKey)
            }
            
            
            timeSinceLastStop += deltaTime
            let walkingSpeedChangeTime = Double(walkingSpeed) * deltaTime * 1.5 * Double(buddyWalkingFrame.count) / 30.0
            
            var walkingDeltaX: CGFloat {
                if timeSinceLastStop < walkingSpeedChangeTime {
                    return walkingSpeed * CGFloat(deltaTime) / 1.5
                } else {
                    return walkingSpeed * CGFloat(deltaTime)
                }
            }
            

            //Moves the buddy position by `walkingDeltaX`.
            switch direction {
            case .left:
                position.x -= walkingDeltaX
                xScale = -1
            case .right:
                position.x += walkingDeltaX
                xScale = 1
            case .none:
                break
            }
        }
    }
    
    
     
    ///Sets destination point after touch action happens.
    public func walk(_ towards: Direction){
        direction = towards
        
        //Updates state of buddy - walking / non-walking .
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
