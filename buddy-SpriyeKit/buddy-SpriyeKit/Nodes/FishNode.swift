//
//  FishNode.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/19/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class FishNode: SKSpriteNode {
    
    public static func newInstance(size: CGSize) -> FishNode {
    
        let fish = FishNode(imageNamed: "fish\(arc4random_uniform(2)+1)")
        
        if fish.texture != nil {
            
            fish.size = CGSize(width: size.width / 9.6, height: size.height / 7.94)
            fish.position = CGPoint(x: size.width / 2, y: size.height / 3)
            fish.zPosition = zPositionFish

        }
        
        
        return fish
    }
    
}
