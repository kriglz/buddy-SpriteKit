//
//  FloorNode.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/12/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class FloorNode: SKSpriteNode {
    
    var floorSprite: SKSpriteNode!
    
    private let waterWaveFrame = [
        SKTexture(imageNamed: "groundwater1"),
        SKTexture(imageNamed: "groundwater2"),
        SKTexture(imageNamed: "groundwater3"),
        SKTexture(imageNamed: "groundwater4"),
        SKTexture(imageNamed: "groundwater5")
    ]
    
    
    public func setup(size: CGSize){
        
        //Init of ground grass - the walking surface.
        let groundSize = CGSize(width: size.width, height: size.height * yForGrass)
        
        
        floorSprite = SKSpriteNode(texture: SKTexture(imageNamed: "groundwater1"))
        floorSprite.size = groundSize
        floorSprite.position = CGPoint(x: floorSprite.size.width / 2, y: floorSprite.size.height / 2)
        floorSprite.zPosition = 10
        
        
        floorSprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "groundwater1"), alphaThreshold: 0.2, size: CGSize(width: floorSprite.size.width, height: floorSprite.size.height - 7))
        physicsBody?.isDynamic = false
        
        physicsBody?.categoryBitMask = FloorCategory
        physicsBody?.contactTestBitMask = BuddyCategory
        
        addChild(floorSprite)
    }
    
    public func runWaves(){
        
        if action(forKey: "runWaves") == nil {
            let waveAction = SKAction.repeatForever( SKAction.animate(with: waterWaveFrame,
                                                                      timePerFrame: 0.3,
                                                                      resize: false,
                                                                      restore: false)
            )
            run(waveAction, withKey: "runWaves")
        }
        
    }
}


