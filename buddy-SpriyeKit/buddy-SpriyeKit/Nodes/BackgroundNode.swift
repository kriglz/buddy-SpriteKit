//
//  BackgroundNode.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/8/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class BackgroundNode: SKNode {
    
    public func setup(size: CGSize){
        
        let yPositionOfFloor = size.height * 0.1
        let startPoint = CGPoint(x: 0, y: yPositionOfFloor)
        let endPoint = CGPoint(x: size.width, y: yPositionOfFloor)
        
        physicsBody = SKPhysicsBody(edgeFrom: startPoint, to: endPoint)
        physicsBody?.categoryBitMask = FloorCategory
        physicsBody?.contactTestBitMask = BuddyCategory
        
        
        
        
        let groundGrassSize = CGSize(width: size.width, height: size.height * 0.12)
        let groundGrassRect = CGRect(origin: CGPoint(), size: groundGrassSize)
        
        let groundGrass = SKShapeNode(rect: groundGrassRect)
        groundGrass.fillColor = .white
        groundGrass.fillTexture = SKTexture(imageNamed: "ground")
        groundGrass.zPosition = 10
        
        addChild(groundGrass)
        
        
    }
    
    
}
