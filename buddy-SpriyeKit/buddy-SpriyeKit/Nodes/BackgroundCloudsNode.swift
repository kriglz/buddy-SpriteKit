//
//  BackgroundCloudsNode.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/16/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class BackgroundCloudsNode: SKSpriteNode {
    
    ///Creates a new cloud node.
    public static func newInstance(size: CGSize) -> BackgroundCloudsNode {
        
        let cloud = BackgroundCloudsNode(imageNamed: "skyClouds1")
        
        if let cloudTexture = cloud.texture {
            
            //Adding physics body of shape of still buddy.
            let cloudSize = CGSize(width: size.width / 20, height: size.height / 12)
            cloud.size = cloudSize
            cloud.alpha = 0.8
            
            cloud.physicsBody = SKPhysicsBody.init(texture: cloudTexture, alphaThreshold: 0.1, size: cloudSize)
            cloud.physicsBody?.allowsRotation = false
            cloud.physicsBody?.isDynamic = false
            
            //Adding contactTestBitMask for buddy.
            cloud.physicsBody?.categoryBitMask = CloudCategory
            cloud.physicsBody?.contactTestBitMask = WorldCategory
    
        }
        return cloud
    }
    
    
}
