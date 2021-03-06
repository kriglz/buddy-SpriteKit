//
//  BackgroundNode.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/8/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

enum Direction {
    case left
    case right
    case none
}




class BackgroundNode: SKNode {
    
    var direction: Direction = .none
    var buddysSpeed: CGFloat = 0.0

    var horizonGrass: SKSpriteNode!
    var horizonGrassAfterFrame: SKSpriteNode!
    var horizonGrassBeforeFrame: SKSpriteNode!
    
    var mountains: SKSpriteNode!
    var mountainsAfterFrame: SKSpriteNode!
    var mountainsBeforeFrame: SKSpriteNode!

    var mountainsBack: SKSpriteNode!
    var mountainsBackAfterFrame: SKSpriteNode!
    var mountainsBackBeforeFrame: SKSpriteNode!
    
    

    
    /// Initialize the background nodes.
    public func setup(size: CGSize){
        
        // Makes background nodes observe notification about buddy movements.
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: cameraMoveNotificationKey),
            object: nil,
            queue: nil,
            using: moveTheBackground)
        
     
        
        // Init of horizon grass.
        let horizonGrassSize = CGSize(width: size.width, height: size.height * yForGrassHorizon + 20)
        
        horizonGrass = SKSpriteNode(texture: SKTexture(imageNamed: "horizonGrass"))
        horizonGrass.size = horizonGrassSize
        horizonGrass.position = CGPoint(x: size.width / 2, y: size.height * yForGrass + horizonGrass.size.height / 2 - 20)
        horizonGrass.zPosition = zPositionHorizon 
        addChild(horizonGrass)
                
        horizonGrassAfterFrame = horizonGrass.copy() as! SKSpriteNode
        horizonGrassAfterFrame.position = CGPoint(x: horizonGrass.position.x + horizonGrass.size.width, y: horizonGrass.position.y)
        horizonGrassAfterFrame.zPosition = horizonGrass.zPosition
        addChild(horizonGrassAfterFrame)
        
        horizonGrassBeforeFrame = horizonGrass.copy() as! SKSpriteNode
        horizonGrassBeforeFrame.position = CGPoint(x: horizonGrass.position.x - horizonGrass.size.width, y: horizonGrass.position.y)
        horizonGrassBeforeFrame.zPosition = horizonGrass.zPosition
        addChild(horizonGrassBeforeFrame)
        
        
        
        // Init of mountains.
        let mountainsSize = CGSize(width: size.width, height: size.height * yForMountains)
        
        mountains = SKSpriteNode(texture: SKTexture(imageNamed: "mountains"))
        mountains.size = mountainsSize
        mountains.position = CGPoint(x: size.width / 2, y: mountains.size.height / 2 + size.height * (yForGrass + yForGrassHorizon) - 20)
        mountains.zPosition = zPositionMountains
//        addChild(mountains)
        
        mountainsAfterFrame = mountains.copy() as! SKSpriteNode
        mountainsAfterFrame.position = CGPoint(x: mountains.position.x + mountains.size.width, y: mountains.position.y)
        mountainsAfterFrame.zPosition = mountains.zPosition
//        addChild(mountainsAfterFrame)
        
        mountainsBeforeFrame = mountains.copy() as! SKSpriteNode
        mountainsBeforeFrame.position = CGPoint(x: mountains.position.x - mountains.size.width, y: mountains.position.y)
        mountainsBeforeFrame.zPosition = mountains.zPosition
//        addChild(mountainsBeforeFrame)
        
        
        
        // Init of mountiansBack.
        mountainsBack = SKSpriteNode(texture: SKTexture(imageNamed: "mountainsBack"))
        mountainsBack.size = mountains.size
        mountainsBack.position = mountains.position
        mountainsBack.zPosition = zPositionMountains - 1.0
//        addChild(mountainsBack)
        
        mountainsBackAfterFrame = mountainsBack.copy() as! SKSpriteNode
        mountainsBackAfterFrame.position = CGPoint(x: mountainsBack.position.x + mountainsBackAfterFrame.size.width, y: mountainsBack.position.y)
        mountainsBackAfterFrame.zPosition = mountainsBack.zPosition
//        addChild(mountainsBackAfterFrame)

        mountainsBackBeforeFrame = mountainsBack.copy() as! SKSpriteNode
        mountainsBackBeforeFrame.position = CGPoint(x: mountainsBack.position.x - mountainsBackBeforeFrame.size.width, y: mountainsBack.position.y)
        mountainsBackBeforeFrame.zPosition = mountainsBack.zPosition
//        addChild(mountainsBackBeforeFrame)
        
        
        
        // Init of sky.
        let skySize = CGSize(width: size.width, height: size.height * yForSky)
        
        let sky = SKSpriteNode(texture: SKTexture(imageNamed: "sky"))
        
        sky.size = skySize
        sky.position = CGPoint(x: sky.size.width / 2, y: sky.size.height / 2 + size.height * yForGrass)
        sky.zPosition = zPositionSky
        
        addChild(sky)        
    }
    

    
    
    
    /// Moves the background if notification from buddy has been received.
    @objc func moveTheBackground( notification: Notification) -> Void {
        
        guard let buddyDirection = notification.userInfo!["DirectionToMove"],
            let buddySpeed = notification.userInfo!["BuddySpeed"],
            let deltaTime = notification.userInfo!["DeltaTime"] else { return }
        
        direction = buddyDirection as! Direction
        buddysSpeed = buddySpeed as! CGFloat
        let dt = deltaTime as! TimeInterval
        
        let deltaX: CGFloat = buddysSpeed * CGFloat(dt)
        
        moveSprite(sprite: horizonGrass, afterSprite: horizonGrassAfterFrame, byDeltaX: deltaX / horizonSpeedConstant)
        moveSprite(sprite: mountains, afterSprite: mountainsAfterFrame, byDeltaX: deltaX / 5)
        moveSprite(sprite: mountainsBack, afterSprite: mountainsBackAfterFrame, byDeltaX: deltaX / 6)
    }
    
    
    
    
    /// Sets the movement direction and speed.
    func moveSprite(sprite: SKSpriteNode, afterSprite: SKSpriteNode, byDeltaX: CGFloat){
        
        // Loop cycle for both sprite and dublicate
        for spriteToMove in [sprite, afterSprite] {
            
            switch direction {
            case .right:
                
                spriteToMove.position.x -= byDeltaX
                spriteToMove.position.x = (spriteToMove.position.x * 10).rounded(.toNearestOrAwayFromZero) / 10

                // If the sprite is off screen (i. e. rightmost edge is farther left than scen's leftmost edge)
                if spriteToMove.frame.maxX <= 0.0 {
                    spriteToMove.position.x += 2 * spriteToMove.size.width
                }
                
            case .left:
                
                spriteToMove.position.x += byDeltaX
                spriteToMove.position.x = (spriteToMove.position.x * 10).rounded(.toNearestOrAwayFromZero) / 10

                // If the sprite is off screen (i. e. rightmost edge is farther left than scen's leftmost edge)
                if spriteToMove.frame.minX >= spriteToMove.size.width {
                    spriteToMove.position.x -= 2 * spriteToMove.size.width
                }
                
            case .none:
                break
            }
        }
    }
}
