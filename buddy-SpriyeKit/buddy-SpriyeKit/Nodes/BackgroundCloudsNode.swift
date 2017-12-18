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
    public static func newInstance(size: CGSize) -> (BackgroundCloudsNode, CGFloat) {
        
        //Inits cloud node
        let cloudImageNumber = arc4random_uniform(5) + 1
        let cloud = BackgroundCloudsNode(imageNamed: "skyClouds\(cloudImageNumber)")
        
        let sizeScale = drand48()

        if cloud.texture != nil {
            
            //Adding physics body of shape of still buddy.
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
    
    
    private var direction: Direction = .right

    
    ///Moves the background if notification from camera has been received.
    func moveTheCloud(speed: CGFloat, in frameSize: CGSize){
        
        let dt: CGFloat = 1/60
        
        let deltaX: CGFloat = speed * dt
        
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
            
            if position.x > frameSize.width + size.width / 2 {
                position.x = -size.width / 2
            }
            
        case .none:
            break
        }
    }      
}
