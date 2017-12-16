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
    
    private let waterWaveFrame = [
        SKTexture(imageNamed: "wave1"),
        SKTexture(imageNamed: "wave2"),
        SKTexture(imageNamed: "wave3"),
        SKTexture(imageNamed: "wave4"),
        SKTexture(imageNamed: "wave5"),
        SKTexture(imageNamed: "wave6")
    ]
    
    
    public func setup(size: CGSize){
        
        //Init of ground grass - the walking surface.
        let groundSize = CGSize(width: size.width, height: size.height * yForGrass)
        
        floorSprite = SKSpriteNode(texture: waterWaveFrame[1])
        floorSprite.size = groundSize
        floorSprite.position = CGPoint(x: floorSprite.size.width / 2, y: floorSprite.size.height / 2)
        floorSprite.zPosition = 10
        
        
        floorSprite.physicsBody = SKPhysicsBody(texture: waterWaveFrame[1], alphaThreshold: 0.2, size: CGSize(width: floorSprite.size.width, height: floorSprite.size.height - 7))
        
        floorSprite.physicsBody?.isDynamic = false
        floorSprite.physicsBody?.categoryBitMask = FloorCategory
        floorSprite.physicsBody?.contactTestBitMask = BuddyCategory
        
        addChild(floorSprite)
    }
    
    private let runWavesKey = "runWaves"
    private var isWaveRunning = false
    
    public func runWaves(){
        
        guard isWaveRunning else {

            let wave = SKAction.animate(with: waterWaveFrame, timePerFrame: 0.4)
            let waveAction = SKAction.repeatForever(wave)
            floorSprite.run(waveAction)
            
            isWaveRunning = true
            return
        }
    }
}


