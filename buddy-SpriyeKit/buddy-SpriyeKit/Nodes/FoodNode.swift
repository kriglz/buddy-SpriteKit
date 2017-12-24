//
//  FoodNode.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/23/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class FoodNode: SKSpriteNode {
    
    
    public func newInstance(size: CGSize) -> FoodNode {
        
        
        let food = FoodNode(imageNamed: "fishFood")
        
        if food.texture != nil {
        
            food.size = CGSize(width: size.width / 100, height: size.height / 174)
        
            food.zPosition = zPositionFish - 1
            
            food.physicsBody = SKPhysicsBody.init(texture: SKTexture(imageNamed: "fishFood"), size: food.size)

            food.physicsBody?.categoryBitMask = FishFoodCategory
            food.physicsBody?.contactTestBitMask = WorldCategory | FishCategory
//            food.physicsBody?.collisionBitMask = 0
//            food.physicsBody?.affectedByGravity = true
        
            
        }
        
        return food
        
    }
}
