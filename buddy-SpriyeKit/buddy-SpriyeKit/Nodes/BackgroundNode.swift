//
//  BackgroundNode.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/8/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class BackgroundNode: SKNode {
    
    var groundGrass: SKSpriteNode!
    var groundGrassNext: SKSpriteNode!
    
    var horizonGrass: SKSpriteNode!
    var horizonGrassNext: SKSpriteNode!
    
    var mountains: SKSpriteNode!
    var mountainsNext: SKSpriteNode!
    
    var mountainsBack: SKSpriteNode!
    var mountainsBackNext: SKSpriteNode!
    
    public func setup(size: CGSize){
        
        let yPositionOfFloor = size.height * yForGrass - 30
        let startPoint = CGPoint(x: 0, y: yPositionOfFloor)
        let endPoint = CGPoint(x: size.width, y: yPositionOfFloor)
        
        physicsBody = SKPhysicsBody(edgeFrom: startPoint, to: endPoint)
        physicsBody?.categoryBitMask = FloorCategory
        physicsBody?.contactTestBitMask = BuddyCategory
        

        
        
        //Init of ground grass - the walking surface.
        let groundGrassSize = CGSize(width: size.width, height: size.height * yForGrass)
        
        groundGrass = SKSpriteNode(texture: SKTexture(imageNamed: "ground"))
        groundGrass.size = groundGrassSize
        groundGrass.position = CGPoint(x: groundGrass.size.width / 2, y: groundGrass.size.height / 2)
        groundGrass.zPosition = 10
        addChild(groundGrass)
        
        groundGrassNext = groundGrass.copy() as! SKSpriteNode
        groundGrass.position = CGPoint(x: groundGrass.position.x + groundGrass.size.width, y: groundGrass.position.y)
        groundGrassNext.zPosition = groundGrass.zPosition
        addChild(groundGrassNext)

        
        
        //Init of horizon grass.
        let horizonGrassSize = CGSize(width: size.width, height: size.height * yForGrassHorizon + 20)
        
        horizonGrass = SKSpriteNode(texture: SKTexture(imageNamed: "horizonGrass"))
        horizonGrass.size = horizonGrassSize
        horizonGrass.position = CGPoint(x: horizonGrass.size.width / 2, y: size.height * yForGrass + horizonGrass.size.height / 2 - 20)
        horizonGrass.zPosition = 8
        addChild(horizonGrass)
        
        horizonGrassNext = horizonGrass.copy() as! SKSpriteNode
        horizonGrassNext.position = CGPoint(x: horizonGrass.position.x + horizonGrass.size.width, y: horizonGrass.position.y)
        horizonGrassNext.zPosition = horizonGrass.zPosition
        addChild(horizonGrassNext)
        
        
        
        
        //Init of mountains.
        let mountainsSize = CGSize(width: size.width, height: size.height * yForMountains)
        
        mountains = SKSpriteNode(texture: SKTexture(imageNamed: "mountains"))
        mountains.size = mountainsSize
        mountains.position = CGPoint(x: mountains.size.width / 2, y: mountains.size.height / 2 + size.height * (yForGrass + yForGrassHorizon) - 20)
        mountains.zPosition = 6
        addChild(mountains)
        
        mountainsNext = mountains.copy() as! SKSpriteNode
        mountainsNext.position = CGPoint(x: mountains.position.x + mountains.size.width, y: mountains.position.y)
        mountainsNext.zPosition = mountains.zPosition
        addChild(mountainsNext)
        
        
        mountainsBack = SKSpriteNode(texture: SKTexture(imageNamed: "mountainsBack"))
        mountainsBack.size = mountains.size
        mountainsBack.position = mountains.position
        mountainsBack.zPosition = 4
        addChild(mountainsBack)
        
        mountainsBackNext = mountainsBack.copy() as! SKSpriteNode
        mountainsBackNext.position = CGPoint(x: mountainsBack.position.x + mountainsBack.size.width, y: mountainsBack.position.y)
        mountainsBackNext.zPosition = mountainsBack.zPosition
        addChild(mountainsBackNext)

        
        
        
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
        let sunOrigin = CGPoint(x: CGPoint().x, y: size.height - size.height * yForGrass)
        let sunRect = CGRect(origin: sunOrigin, size: sunSize)
        
        let sun = SKShapeNode(rect: sunRect)
        sun.fillColor = .white
        sun.strokeColor = .clear
        sun.fillTexture = SKTexture(imageNamed: "skySun")
        sun.zPosition = 4
        
        addChild(sun)
        
       
        
        
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
        
       

        
        
      
        
    }
    
    var deltaTime : TimeInterval = 0
    var lastFrameTime : TimeInterval = 0

    
    func moveSprite(sprite: SKSpriteNode, nextSprite: SKSpriteNode, speed: Float){
        
        var newPosition = CGPoint.zero
        
        //Loop cycle for both sprite and dublicate
        for spriteToMove in [sprite, nextSprite]{
            
            //Move sprite to the left based on speed
            newPosition = spriteToMove.position
            newPosition.x -= CGFloat(speed * Float(deltaTime))
            spriteToMove.position = newPosition
            
            //If the sprite is noq offscreen (i. e. rightmost edge is farther left than scen's leftmost edge)
            if spriteToMove.frame.maxX < self.frame.minX {
                
                //Shift it over so that it's now to the immediate right of the other sprite.
                //Two sprite are leap=frogging each other as tehy both move.
                
                spriteToMove.position = CGPoint(x: spriteToMove.position.x + spriteToMove.size.width * 2, y: spriteToMove.position.y)
            }
        }
        
        
       
    }
    
    
    func update(_ currentTime: TimeInterval){
        
        //Updates the delta time value.
        if lastFrameTime <= 0 {
            lastFrameTime = currentTime
        }
        
        deltaTime = currentTime - lastFrameTime
        
        //Sets the last frame time to current time.
        lastFrameTime = currentTime
        
        
        moveSprite(sprite: groundGrass, nextSprite: groundGrassNext, speed: 150.0)
        moveSprite(sprite: horizonGrass, nextSprite: horizonGrassNext, speed: 100.0)
        moveSprite(sprite: mountains, nextSprite: mountainsNext, speed: 50.0)
        moveSprite(sprite: mountainsBack, nextSprite: mountainsBackNext, speed: 25.0)
    }

  
    
    
}
