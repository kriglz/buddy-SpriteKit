//
//  BackgroundCloudsNode.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/16/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class BackgroundCloudsNode: SKSpriteNode {

    /// Cloud movement direction.
    private var direction: Direction = .right
    
    private var buddySpeed: CGFloat?
    private var buddyDirection: Direction?

    
    /// Creates a new cloud node.
    public static func newInstance(size: CGSize) -> (BackgroundCloudsNode, CGFloat) {
        
        // Inits cloud node
        let cloudImageNumber = arc4random_uniform(5) + 1
        let cloud = BackgroundCloudsNode(imageNamed: "skyClouds\(cloudImageNumber)")
        let sizeScale = drand48()

        if cloud.texture != nil {
            
            // Adding physics body of shape of still buddy.
            let cloudSize = CGSize(width: size.width * CGFloat(sizeScale) / 20, height: size.height * CGFloat(sizeScale) / 16)
            cloud.size = cloudSize
            
            if sizeScale < 0.4 {
                cloud.alpha = CGFloat(sizeScale)
            } else {
                cloud.alpha = CGFloat(sizeScale) - 0.1
            }
            
            let randomInitPositionY = size.height / 2 + 200.0 * CGFloat(sizeScale)
            let randomInitPositionX = CGFloat(arc4random_uniform(UInt32(size.width)))
            let cloudInitPosition = CGPoint(x: randomInitPositionX, y: randomInitPositionY)
            cloud.position = cloudInitPosition
            cloud.zPosition = zPositionClouds
        }
        
        let cloudSpeed: CGFloat = 10.0 * CGFloat(sizeScale)
        
        return (cloud, cloudSpeed)
    }

    
    
    /// Moves the cloud.
    public func moveTheCloud(deltaTime: TimeInterval, speed: CGFloat, in frameSize: CGSize){
        
        var cloudSpeed: CGFloat = speed
        
        // Moves clouds in different speed if buddy moves too.
        if let buddySpeed = buddySpeed,
            let buddyDirection = buddyDirection {
            
            switch buddyDirection {
                
            case .right:
                cloudSpeed += buddySpeed / 5.4
            case .left:
                cloudSpeed -= buddySpeed / 5.4
            default:
                break
            }
        }

        /// Value which shows how much x is changed every `deltaTime`.
        let deltaX: CGFloat = cloudSpeed * CGFloat(deltaTime)
        
        // Move sprite based on speed
        var newPosition: CGPoint = CGPoint.zero
        newPosition = position
        
        switch direction {
            
        case .right:
            newPosition.x -= deltaX
            position = newPosition
            
        case .left:
            newPosition.x += deltaX
            position = newPosition
            
            if position.x > frameSize.width + size.width / 2 {
                position.x = -size.width / 2
            }
            
        case .none:
            break
        }
        
        buddyDirection = nil
        buddySpeed = nil
    }
    
    
    /// Moves the clouds relative to the buddy movement.
    @objc func moveTheClouds(notification: Notification) -> Void {
        
        guard let bDirection = notification.userInfo!["DirectionToMove"],
            let bSpeed = notification.userInfo!["BuddySpeed"] else { return }
        
        buddyDirection = bDirection as? Direction
        buddySpeed = bSpeed as? CGFloat
    }
}
