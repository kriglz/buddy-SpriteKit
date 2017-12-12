//
//  FloorNode.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/12/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class FloorNode: SKSpriteNode {
    
    var groundGrass: SKSpriteNode!
    var groundGrassNext: SKSpriteNode!
    
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
        groundGrassNext.position = CGPoint(x: groundGrass.position.x + groundGrass.size.width, y: groundGrass.position.y)
        groundGrassNext.zPosition = groundGrass.zPosition
        addChild(groundGrassNext)

    
    
    }
}


