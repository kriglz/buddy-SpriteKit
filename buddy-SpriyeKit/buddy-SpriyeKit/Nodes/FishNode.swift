//
//  FishNode.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/19/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class FishNode: SKSpriteNode {
    
    var fishSwimFrame = [
        SKTexture(imageNamed: "fishswing1"),
        SKTexture(imageNamed: "fishswing2"),
        SKTexture(imageNamed: "fishswing3")
    ]
    
    public static func newInstance(size: CGSize) -> FishNode{
    
        let fish = FishNode(imageNamed: "fishswing1") // \(arc4random_uniform(2)+1)")
        
        if fish.texture != nil {
            
            fish.size = CGSize(width: size.width / 9.6, height: size.height / 7.94)
            fish.position = CGPoint(x: size.width / 2 + CGFloat(arc4random_uniform(200)), y: size.height / 3 - CGFloat(arc4random_uniform(200)))
            fish.zPosition = zPositionFish

            
            
        }
        
        return fish
    }
    
    
    public func swim(){
        let swimAction = SKAction.repeatForever(
            SKAction.animate(with: fishSwimFrame, timePerFrame: 0.3))
        
        run(swimAction)
    }
    
}
