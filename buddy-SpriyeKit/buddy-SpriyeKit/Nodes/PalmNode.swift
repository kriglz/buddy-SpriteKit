//
//  PalmNode.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/18/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class PalmNode: SKSpriteNode {
    
    public static func newInstance(size: CGSize) -> PalmNode {
        
        let palmImageNumber = arc4random_uniform(2) + 1
        let palm = PalmNode(imageNamed: "palm\(palmImageNumber)")
        
        let scaleConstant = CGFloat(drand48())
        
        
        if palm.texture != nil {
            let sizeWidth = size.width / 12.42 * ( 1 - (1.0 - scaleConstant) * 0.4)
            let sizeHeight = size.height / 4.32 * ( 1 - (1.0 - scaleConstant) * 0.4)

            palm.size = CGSize(width: sizeWidth, height: sizeHeight)
            
            let yPosition =  size.height / 2 + 10.0 + 5 * (1 - scaleConstant)
            let xPosition = size.width / 2 + CGFloat(arc4random_uniform(200))
            palm.position = CGPoint(x: xPosition, y: yPosition)
            palm.zPosition = zPositionPalm + scaleConstant
        }
        
        return palm
    }
    
    
    var direction: Direction = .none
    var buddysSpeed: CGFloat = 0.0
    
    @objc func moveThePalm(notification: Notification) -> Void {
        
        guard let buddyDirection = notification.userInfo!["DirectionToMove"],
            let buddySpeed = notification.userInfo!["BuddySpeed"],
            let deltaTime = notification.userInfo!["DeltaTime"] else { return }
        
        direction = buddyDirection as! Direction
        buddysSpeed = buddySpeed as! CGFloat
        let dt = deltaTime as! TimeInterval
        
        
        let deltaX: CGFloat = buddysSpeed * CGFloat(dt) / horizonSpeedConstant
        
        //Move sprite based on speed
        var newPosition: CGPoint = CGPoint.zero
        newPosition = position
        
        switch direction {
        case .left:
            newPosition.x -= deltaX
            position = newPosition
            
        case .right:
            newPosition.x += deltaX
            position = newPosition
            
        case .none:
            break
        }
    }
}
