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
            food.physicsBody?.affectedByGravity = false
        
            
        }
        
        return food
        
    }
    
    public func fallingInTheWater(){
        
        let fallAction = SKAction.moveTo(y: position.y - 400.0, duration: 40.0)
        
        let pushLeftAction = SKAction.applyForce(CGVector(dx: -0.01, dy: 0), duration: 1)
        let pushRightAction = SKAction.applyForce(CGVector(dx: 0.01, dy: 0), duration: 1)

        let pushActions = SKAction.repeatForever(SKAction.sequence([pushLeftAction,
                                                                   SKAction.wait(forDuration: 0.3),
                                                                   pushRightAction,
                                                                   SKAction.wait(forDuration: 0.3)]))
        
        let fallActionGroup = SKAction.group([fallAction, pushActions])
        run(fallActionGroup)
    }
    
}
