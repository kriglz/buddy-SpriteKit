//
//  FoodNode.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/23/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class FoodNode: SKSpriteNode {
    
    /// Creates a new fish instance.
    public func newInstance(size: CGSize) -> FoodNode {
        let food = FoodNode(imageNamed: "fishFood")
        
        if food.texture != nil {
            food.size = CGSize(width: size.width / 100, height: size.height / 174)
            food.zPosition = zPositionFish - 1
            
            food.physicsBody = SKPhysicsBody.init(texture: SKTexture(imageNamed: "fishFood"), size: food.size)
            food.physicsBody?.categoryBitMask = FishFoodCategory
            food.physicsBody?.contactTestBitMask = WorldCategory | FishCategory
            food.physicsBody?.collisionBitMask = 0
            food.physicsBody?.affectedByGravity = false
        }
        return food
    }

    
    
    /// Makes food fall in the water.
    public func fallingInTheWater(){
        
        let scaleConstant = CGFloat(drand48()) // Bigger - faster, and smaller dx
        
        let fallAction = SKAction.moveTo(y: position.y - 100 - 300 * scaleConstant, duration: 40.0)
        
        let pushLeft1 = SKAction.move(by: CGVector(dx: -10 + 8 * scaleConstant, dy: -2), duration: 1.3 + 0.3 * Double(scaleConstant))
        let pushLeft2 = SKAction.move(by: CGVector(dx: -4, dy: -1), duration: 1)
        let pushLeftAction = SKAction.sequence([pushLeft1, pushLeft2])
        
        let pushRight1 = SKAction.move(by: CGVector(dx: 10 + 8 * scaleConstant, dy: -2), duration: 1.3 + 0.3 * Double(scaleConstant))
        let pushRight2 = SKAction.move(by: CGVector(dx: 4, dy: -1), duration: 1)
        let pushRightAction = SKAction.sequence([pushRight1, pushRight2])
        
        let pushActions = SKAction.repeatForever(SKAction.sequence([pushLeftAction,
                                                                   SKAction.wait(forDuration: 0.1),
                                                                   pushRightAction,
                                                                   SKAction.wait(forDuration: 0.1)]))
        
        let fallActionGroup = SKAction.group([fallAction, pushActions])
        
        run(fallActionGroup)
    }
    
    
    // Makes food dissapear.
    public func disintegrating(){
        
        let waitAction = SKAction.wait(forDuration: 10 + Double(arc4random_uniform(16)))
        let disappearAction = SKAction.fadeOut(withDuration: 13)
        let removeNodeAction = SKAction.removeFromParent()
        let disintegratingAction = SKAction.sequence([waitAction, disappearAction, removeNodeAction])
        
        run(disintegratingAction)
    }
}
