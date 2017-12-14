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
    

    var horizonGrass: SKSpriteNode!
    var horizonGrassAfterFrame: SKSpriteNode!
    var horizonGrassBeforeFrame: SKSpriteNode!
    
    var mountains: SKSpriteNode!
    var mountainsAfterFrame: SKSpriteNode!
    var mountainsBeforeFrame: SKSpriteNode!

    var mountainsBack: SKSpriteNode!
    var mountainsBackAfterFrame: SKSpriteNode!
    var mountainsBackBeforeFrame: SKSpriteNode!
    
    var buddysSpeed: CGFloat = 0.0
    
    


    
    ///Initialize the background nodes.
    public func setup(size: CGSize){
        
        //Makes background nodes observe notification about camera movements.
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: cameraMoveNotificationKey),
            object: nil,
            queue: nil,
            using: moveTheBackground)
        
     
        
        //Init of horizon grass.
        let horizonGrassSize = CGSize(width: size.width, height: size.height * yForGrassHorizon + 20)
        
        horizonGrass = SKSpriteNode(texture: SKTexture(imageNamed: "horizonGrass"))
        horizonGrass.size = horizonGrassSize
        horizonGrass.position = CGPoint(x: size.width / 2, y: size.height * yForGrass + horizonGrass.size.height / 2 - 20)
        horizonGrass.zPosition = 8
        addChild(horizonGrass)
        
        horizonGrassAfterFrame = horizonGrass.copy() as! SKSpriteNode
        horizonGrassAfterFrame.position = CGPoint(x: horizonGrass.position.x + horizonGrass.size.width, y: horizonGrass.position.y)
        horizonGrassAfterFrame.zPosition = horizonGrass.zPosition
        addChild(horizonGrassAfterFrame)
        
        horizonGrassBeforeFrame = horizonGrass.copy() as! SKSpriteNode
        horizonGrassBeforeFrame.position = CGPoint(x: horizonGrass.position.x - horizonGrass.size.width, y: horizonGrass.position.y)
        horizonGrassBeforeFrame.zPosition = horizonGrass.zPosition
        addChild(horizonGrassBeforeFrame)
        
        
        
        //Init of mountains.
        let mountainsSize = CGSize(width: size.width, height: size.height * yForMountains)
        
        mountains = SKSpriteNode(texture: SKTexture(imageNamed: "mountains"))
        mountains.size = mountainsSize
        mountains.position = CGPoint(x: size.width / 2, y: mountains.size.height / 2 + size.height * (yForGrass + yForGrassHorizon) - 20)
        mountains.zPosition = 6
        addChild(mountains)
        
        mountainsAfterFrame = mountains.copy() as! SKSpriteNode
        mountainsAfterFrame.position = CGPoint(x: mountains.position.x + mountains.size.width, y: mountains.position.y)
        mountainsAfterFrame.zPosition = mountains.zPosition
        addChild(mountainsAfterFrame)
        
        mountainsBeforeFrame = mountains.copy() as! SKSpriteNode
        mountainsBeforeFrame.position = CGPoint(x: mountains.position.x - mountains.size.width, y: mountains.position.y)
        mountainsBeforeFrame.zPosition = mountains.zPosition
        addChild(mountainsBeforeFrame)
        
        
        
        //Init of mountiansBack.
        mountainsBack = SKSpriteNode(texture: SKTexture(imageNamed: "mountainsBack"))
        mountainsBack.size = mountains.size
        mountainsBack.position = mountains.position
        mountainsBack.zPosition = 4
        addChild(mountainsBack)
        
        mountainsBackAfterFrame = mountainsBack.copy() as! SKSpriteNode
        mountainsBackAfterFrame.position = CGPoint(x: mountainsBack.position.x + mountainsBack.size.width, y: mountainsBack.position.y)
        mountainsBackAfterFrame.zPosition = mountainsBack.zPosition
        addChild(mountainsBackAfterFrame)

        mountainsBackBeforeFrame = mountainsBack.copy() as! SKSpriteNode
        mountainsBackBeforeFrame.position = CGPoint(x: mountainsBack.position.x - mountainsBack.size.width, y: mountainsBack.position.y)
        mountainsBackBeforeFrame.zPosition = mountainsBack.zPosition
        addChild(mountainsBackBeforeFrame)
        
        
        
        //Below stuff is not moving yet.

        //Init of sky.
        let skySize = CGSize(width: size.width, height: size.height * (yForSky + yForMountains))
        let skyOrigin = CGPoint(x: CGPoint().x, y: size.height * (yForGrass + yForGrassHorizon))
        let skynRect = CGRect(origin: skyOrigin, size: skySize)
        
        let sky = SKShapeNode(rect: skynRect)
        sky.fillColor = UIColor.init(red: 255/255, green: 254/255, blue: 240/255, alpha: 1.0)
        sky.strokeColor = .clear
        sky.zPosition = 1
        
        addChild(sky)
        
        //Init sun in the sky.
        let sunSize = CGSize(width: size.height * yForGrass * 1.68, height: size.height * yForGrass)
        
        let sun = SKSpriteNode(texture: SKTexture(imageNamed: "skySun"))
        sun.size = sunSize
        sun.position = CGPoint(x: sun.size.width / 3, y: size.height - size.height * yForGrass)
        sun.zPosition = 2
        addChild(sun)
    }
    

    
    
    
    ///Moves the background if notification from camera has been received.
    @objc func moveTheBackground( notification: Notification) -> Void {
        
        guard let buddyDirection = notification.userInfo!["DirectionToMove"],
            let buddySpeed = notification.userInfo!["BuddySpeed"],
            let deltaTime = notification.userInfo!["DeltaTime"] else { return }
        
        direction = buddyDirection as! Direction
        buddysSpeed = buddySpeed as! CGFloat
        let dt = deltaTime as! TimeInterval
        
        
        let deltaX: CGFloat = buddysSpeed * CGFloat(dt)
        
        moveSprite(sprite: horizonGrass, beforeSprite: horizonGrassBeforeFrame, afterSprite: horizonGrassAfterFrame, byDeltaX: deltaX / 6.0)
        moveSprite(sprite: mountains, beforeSprite: mountainsBeforeFrame, afterSprite: mountainsAfterFrame, byDeltaX: deltaX / 12.0)
        moveSprite(sprite: mountainsBack, beforeSprite: mountainsBackBeforeFrame, afterSprite: mountainsBackAfterFrame, byDeltaX: deltaX / 14.0)
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
                if (spriteToMove == sprite && spriteToMove.frame.maxX < 0.0) || (spriteToMove == afterSprite && spriteToMove.frame.minX < 0.0) {
                    
                    //Shift it over so that it's now to the immediate right of the other sprite.
                    //Two sprite are leap-frogging each other as tehy both move.
                    
                    spriteToMove.position = CGPoint(x: spriteToMove.position.x + spriteToMove.size.width, y: spriteToMove.position.y)
                }
                
            case .left:
                
                newPosition.x += byDeltaX
                spriteToMove.position = newPosition 
                
                //If the sprite is off screen (i. e. rightmost edge is farther left than scen's leftmost edge)
                if (spriteToMove == sprite && spriteToMove.frame.minX > spriteToMove.size.width) || (spriteToMove == beforeSprite && spriteToMove.frame.minX > 0.0){
                    
                    //Shift it over so that it's now to the immediate right of the other sprite.
                    //Two sprite are leap-frogging each other as tehy both move.
                    
                    spriteToMove.position = CGPoint(x: spriteToMove.position.x - spriteToMove.size.width, y: spriteToMove.position.y)
                }
                
            case .none:
                break
            }
        }
    }
}









//        let grassLine = SKShapeNode(rect: CGRect(x: size.width / 2, y: size.height / 2, width: 200, height: 30))
//        grassLine.physicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width: 200, height: 30))
//        grassLine.fillColor = .orange
//        grassLine.physicsBody?.isDynamic = false
//
//        let effectNode = SKEffectNode()
//        effectNode.addChild(grassLine)
//        addChild(effectNode)
//        let sourcePositions: [float2] = [
//            float2(0, 1),  float2(0.25, 1), float2(0.5, 1), float2(0.75, 1),  float2(1, 1),
//            float2(0, 0),   float2(0.25, 0), float2(0.5, 0), float2(0.75, 0),  float2(1, 0)
//        ]
//        let destinationPositions: [float2] = [
//            float2(0, 1),  float2(0.25, 1.1), float2(0.5, 1.1), float2(0.75, 1),  float2(1, 1),
//            float2(0, 0),   float2(0.25, 0), float2(0.5, 0), float2(0.75, 0),  float2(1, 0)
//        ]
//        let destinationPositions1: [float2] = [
//            float2(0, 1),  float2(0.25, 1.1), float2(0.5, 1.2), float2(0.75, 1.1),  float2(1, 1),
//            float2(0, 0),   float2(0.25, 0), float2(0.5, 0), float2(0.75, 0),  float2(1, 0)
//        ]
//
//        let destinationPositions2: [float2] = [
//            float2(0, 1),  float2(0.25, 1), float2(0.5, 1.1), float2(0.75, 1.2),  float2(1, 1.1),
//            float2(0, 0),   float2(0.25, 0), float2(0.5, 0), float2(0.75, 0),  float2(1, 0)
//        ]
//        let destinationPositions3: [float2] = [
//            float2(0, 1),  float2(0.25, 1), float2(0.5, 1), float2(0.75, 1.1),  float2(1, 1.2),
//            float2(0, 0),   float2(0.25, 0), float2(0.5, 0), float2(0.75, 0),  float2(1, 0)
//        ]
//        let destinationPositions4: [float2] = [
//            float2(0, 1),  float2(0.25, 1), float2(0.5, 1), float2(0.75, 1),  float2(1, 1.1),
//            float2(0, 0),   float2(0.25, 0), float2(0.5, 0), float2(0.75, 0),  float2(1, 0)
//        ]
//
//        let warpGeometryGrid1 = SKWarpGeometryGrid(columns: 4, rows: 1,
//                                                  sourcePositions: sourcePositions,
//                                                  destinationPositions: destinationPositions)
//        let warpGeometryGrid2 = SKWarpGeometryGrid(columns: 4, rows: 1,
//                                                   sourcePositions: sourcePositions,
//                                                   destinationPositions: destinationPositions1)
//        let warpGeometryGrid3 = SKWarpGeometryGrid(columns: 4, rows: 1,
//                                                   sourcePositions: sourcePositions,
//                                                   destinationPositions: destinationPositions2)
//        let warpGeometryGrid4 = SKWarpGeometryGrid(columns: 4, rows: 1,
//                                                   sourcePositions: sourcePositions,
//                                                   destinationPositions: destinationPositions3)
//        let warpGeometryGrid5 = SKWarpGeometryGrid(columns: 4, rows: 1,
//                                                   sourcePositions: sourcePositions,
//                                                   destinationPositions: destinationPositions4)
//        let warpGeometryGrid6 = SKWarpGeometryGrid(columns: 4, rows: 1,
//                                                   sourcePositions: sourcePositions,
//                                                   destinationPositions: sourcePositions)
//
//        effectNode.warpGeometry = warpGeometryGrid1
//        let warpAction = SKAction.repeatForever(SKAction.animate(withWarps:[warpGeometryGrid1,
//                                                             warpGeometryGrid2,
//                                                             warpGeometryGrid3,
//                                                             warpGeometryGrid4,
//                                                             warpGeometryGrid5,
//                                                             warpGeometryGrid6],
//                                                                         times: [0.5, 1.0, 1.5, 2.0, 2.5, 3.0])!)
//        effectNode.run(warpAction)
