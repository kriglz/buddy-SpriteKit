//
//  FloorNode.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/12/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class FloorNode: SKSpriteNode {
    
    private var floorSprite: SKSpriteNode!
    private var floorSpriteAfterFrame: SKSpriteNode!
    private var floorSpriteBeforeFrame: SKSpriteNode!
    
    private let runWavesKey = "runWaves"
    private var isWaveRunning = false
    
    
    var direction: Direction = .none
    var buddysSpeed: CGFloat = 0.0

    
    private let waterWaveFrame = [
        SKTexture(imageNamed: "wave1"),
        SKTexture(imageNamed: "wave2"),
        SKTexture(imageNamed: "wave3"),
        SKTexture(imageNamed: "wave4"),
        SKTexture(imageNamed: "wave5")
    ]
    
    
    public func setup(size: CGSize){
        
        //Makes background nodes observe notification about camera movements.
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: cameraMoveNotificationKey),
            object: nil,
            queue: nil,
            using: moveTheFloor)
        
        //Init of ground grass - the walking surface.
        let groundSize = CGSize(width: size.width, height: size.height * yForGrass)
        
        floorSprite = SKSpriteNode(texture: waterWaveFrame[1])
        floorSprite.size = groundSize
        floorSprite.position = CGPoint(x: floorSprite.size.width / 2, y: floorSprite.size.height / 2)
        floorSprite.zPosition = zPositionWater
        
        floorSprite.physicsBody = SKPhysicsBody(texture: waterWaveFrame[1], alphaThreshold: 0.2, size: CGSize(width: floorSprite.size.width, height: floorSprite.size.height - 7))
        floorSprite.physicsBody?.isDynamic = false
        floorSprite.physicsBody?.categoryBitMask = FloorCategory
        floorSprite.physicsBody?.contactTestBitMask = BuddyCategory
        
        addChild(floorSprite)
        
     
        floorSpriteAfterFrame = floorSprite.copy() as! SKSpriteNode
        floorSpriteAfterFrame.position = CGPoint(x: floorSprite.position.x + floorSprite.size.width, y: floorSprite.position.y)
        floorSpriteAfterFrame.zPosition = floorSprite.zPosition
//        floorSpriteAfterFrame.physicsBody = floorSprite.physicsBody
        
        addChild(floorSpriteAfterFrame)
        
        
        floorSpriteBeforeFrame = floorSprite.copy() as! SKSpriteNode
        floorSpriteBeforeFrame.position = CGPoint(x: floorSprite.position.x - floorSprite.size.width, y: floorSprite.position.y)
        floorSpriteBeforeFrame.zPosition = floorSprite.zPosition
//        floorSpriteBeforeFrame.physicsBody = floorSprite.physicsBody
        
        addChild(floorSpriteBeforeFrame)
    }
    
    
    
    
    
    
    
    
    ///Moves the background if notification from camera has been received.
    @objc func moveTheFloor( notification: Notification) -> Void {
        
        guard let buddyDirection = notification.userInfo!["DirectionToMove"],
            let buddySpeed = notification.userInfo!["BuddySpeed"],
            let deltaTime = notification.userInfo!["DeltaTime"] else { return }
        
        direction = buddyDirection as! Direction
        buddysSpeed = buddySpeed as! CGFloat
        let dt = deltaTime as! TimeInterval
        
        
        let deltaX: CGFloat = buddysSpeed * CGFloat(dt)
        
        moveSprite(sprite: floorSprite, beforeSprite: floorSpriteBeforeFrame, afterSprite: floorSpriteAfterFrame, byDeltaX: deltaX)
    }
    
    
    
    
    ///Sets the movement direction and speed.
    func moveSprite(sprite: SKSpriteNode, beforeSprite: SKSpriteNode, afterSprite: SKSpriteNode, byDeltaX: CGFloat){
        
        //Loop cycle for both sprite and dublicate
        for spriteToMove in [sprite, beforeSprite, afterSprite] {
            
            //Move sprite to the left based on speed
            var newPosition: CGPoint = CGPoint.zero
            newPosition = spriteToMove.position
            
            
            switch direction {
                
            case .right:
                
                newPosition.x -= byDeltaX
                spriteToMove.position = newPosition
                
                //If the sprite is off screen (i. e. rightmost edge is farther left than scen's leftmost edge)
                if spriteToMove.frame.maxX < 0.0 {

                    //Shift it over so that it's now to the immediate right of the other sprite.
                    //Two sprite are leap-frogging each other as tehy both move.
                    
                    spriteToMove.position.x += 2 * spriteToMove.size.width
                }
                
            case .left:
                
                newPosition.x += byDeltaX
                spriteToMove.position = newPosition
                
                //If the sprite is off screen (i. e. rightmost edge is farther left than scen's leftmost edge)

                if spriteToMove.frame.minX > spriteToMove.size.width {

                    //Shift it over so that it's now to the immediate right of the other sprite.
                    //Two sprite are leap-frogging each other as tehy both move.
                    spriteToMove.position.x -= 2 * spriteToMove.size.width
                }
                
            case .none:
                break
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ///Adds running wave animation to the sprite.
    public func runWaves(){
        guard isWaveRunning else {

            let wave = SKAction.animate(with: waterWaveFrame, timePerFrame: 0.4)
            let waveAction = SKAction.repeatForever(wave)
            
            floorSprite.run(waveAction)
            floorSpriteAfterFrame.run(waveAction)
            floorSpriteBeforeFrame.run(waveAction)
            
            isWaveRunning = true
            return
        }
    }
}


