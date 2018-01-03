//
//  PalmNode.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/18/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class PalmNode: SKSpriteNode {
    
    var direction: Direction = .none
    var buddysSpeed: CGFloat = 0.0
    
    public static func newInstance(size: CGSize) -> PalmNode {
        
        let randomSite = arc4random_uniform(2)
        let palmImageNumber = arc4random_uniform(2) + 1
        let palm = PalmNode(imageNamed: "palm\(palmImageNumber)")
        let scaleConstant = CGFloat(drand48())
        
        if palm.texture != nil {
            let sizeWidth = size.width / 12.42 * ( 1 - (1.0 - scaleConstant) * 0.4)
            let sizeHeight = size.height / 4.32 * ( 1 - (1.0 - scaleConstant) * 0.4)
            palm.size = CGSize(width: sizeWidth, height: sizeHeight)
            
            let yPosition =  size.height / 2 + 10.0 + 5 * (1 - scaleConstant)
            var xPosition = size.width / 4
            if randomSite == 0 {
               xPosition += CGFloat(arc4random_uniform(200))
            } else {
                xPosition -= CGFloat(arc4random_uniform(200)) + 200.0
            }
            palm.position = CGPoint(x: xPosition, y: yPosition)
            
            palm.zPosition = zPositionPalm + scaleConstant
        }
        return palm
    }
    
    
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
        case .right:
            newPosition.x -= deltaX
            position = newPosition
            
        case .left:
            newPosition.x += deltaX
            position = newPosition
            
        case .none:
            break
        }
    }
    
    
    
    ///Warp geometry action to make palms swing.
    func swing(){
        
        let sourcePositions: [float2] = [
            float2(0, 1),       float2(0.5, 1),     float2(1, 1),
            float2(0, 0.8),     float2(0.5, 0.8),   float2(1, 0.8),
            float2(0, 0.6),     float2(0.5, 0.6),   float2(1, 0.6),
            float2(0, 0.4),     float2(0.5, 0.4),   float2(1, 0.4),
            float2(0, 0.2),     float2(0.5, 0.2),   float2(1, 0.2),
            float2(0, 0),       float2(0.5, 0),     float2(1, 0)
        ]
        
        let destinationPositions1: [float2] = [
            float2(0.05, 0.99),   float2(0.55, 0.98),  float2(1.05, 0.96),
            float2(0.03, 0.79),   float2(0.53, 0.78),  float2(1.03, 0.76),
            float2(0.01, 0.59),  float2(0.51, 0.58),  float2(1.01, 0.56),
            
            float2(0, 0.4),      float2(0.5, 0.4),  float2(1, 0.4),
            
            float2(0, 0.2),      float2(0.5, 0.2),  float2(1, 0.2),
            float2(0, 0),        float2(0.5, 0),    float2(1, 0)
        ]
        
        let destinationPositions2: [float2] = [
            float2(0.1, 0.98),   float2(0.6, 0.96),  float2(1.1, 0.92),
            float2(0.06, 0.78),   float2(0.56, 0.76),  float2(1.06, 0.72),
            float2(0.02, 0.58),      float2(0.52, 0.56),  float2(1.02, 0.52),
            
            float2(0.01, 0.4),      float2(0.51, 0.39),  float2(1.01, 0.38),
            
            float2(0, 0.2),      float2(0.5, 0.2),  float2(1, 0.2),
            float2(0, 0),        float2(0.5, 0),    float2(1, 0)
        ]
        
        let destinationPositions3: [float2] = [
            float2(-0.04, 1),       float2(0.46, 1),     float2(0.97, 1),
            float2(-0.02, 0.8),     float2(0.47, 0.8),   float2(0.98, 0.8),
            
            float2(0, 0.6),     float2(0.5, 0.6),   float2(1, 0.6),
            float2(0, 0.4),     float2(0.5, 0.4),   float2(1, 0.4),
            float2(0, 0.2),     float2(0.5, 0.2),   float2(1, 0.2),
            float2(0, 0),       float2(0.5, 0),     float2(1, 0)
        ]
        
        let warpGeometryGrid1 = SKWarpGeometryGrid(columns: 2, rows: 5,
                                                   sourcePositions: sourcePositions,
                                                   destinationPositions: destinationPositions1)
        let warpGeometryGrid2 = SKWarpGeometryGrid(columns: 2, rows: 5,
                                                   sourcePositions: sourcePositions,
                                                   destinationPositions: destinationPositions2)
        let warpGeometryGrid3 = SKWarpGeometryGrid(columns: 2, rows: 5,
                                                   sourcePositions: sourcePositions,
                                                   destinationPositions: destinationPositions3)
        
        let randTime = drand48() + 1.0
        let randTime2 = randTime * 2
        let randTime3 = randTime * 3

        let swingAction = SKAction.animate(withWarps:[warpGeometryGrid1,
                                                      warpGeometryGrid2,
                                                      warpGeometryGrid3],
                                           times: [NSNumber(value: randTime), NSNumber(value: randTime2), NSNumber(value: randTime3)])

        let warpAction = SKAction.repeatForever(swingAction!)
        run(warpAction)
    }
}
