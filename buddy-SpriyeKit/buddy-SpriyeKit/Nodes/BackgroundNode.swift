//
//  BackgroundNode.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/8/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class BackgroundNode: SKNode {
    
    public func setup(size: CGSize){
        
        let yPositionOfFloor = size.height * 0.1
        let startPoint = CGPoint(x: 0, y: yPositionOfFloor)
        let endPoint = CGPoint(x: size.width, y: yPositionOfFloor)
        
        physicsBody = SKPhysicsBody(edgeFrom: startPoint, to: endPoint)
        physicsBody?.categoryBitMask = FloorCategory
        physicsBody?.contactTestBitMask = BuddyCategory
        

        let groundGrassSize = CGSize(width: size.width, height: size.height * 0.12)
        let groundGrassRect = CGRect(origin: CGPoint(), size: groundGrassSize)
        
        let groundGrass = SKShapeNode(rect: groundGrassRect)
        groundGrass.fillColor = .white
        groundGrass.strokeColor = .clear
        groundGrass.fillTexture = SKTexture(imageNamed: "ground")
        groundGrass.zPosition = 10
        
        addChild(groundGrass)
        
        
        let grassLine = SKShapeNode(rect: CGRect(x: size.width / 2, y: size.height / 2, width: 200, height: 30))
        grassLine.physicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width: 200, height: 30))
        grassLine.fillColor = .orange
        grassLine.physicsBody?.isDynamic = false
     
        let effectNode = SKEffectNode()
        effectNode.addChild(grassLine)
        addChild(effectNode)
        let sourcePositions: [float2] = [
            float2(0, 1),  float2(0.25, 1), float2(0.5, 1), float2(0.75, 1),  float2(1, 1),
            float2(0, 0),   float2(0.25, 0), float2(0.5, 0), float2(0.75, 0),  float2(1, 0)
        ]
        let destinationPositions: [float2] = [
            float2(0, 1),  float2(0.25, 1.1), float2(0.5, 1.1), float2(0.75, 1),  float2(1, 1),
            float2(0, 0),   float2(0.25, 0), float2(0.5, 0), float2(0.75, 0),  float2(1, 0)
        ]
        let destinationPositions1: [float2] = [
            float2(0, 1),  float2(0.25, 1.1), float2(0.5, 1.2), float2(0.75, 1.1),  float2(1, 1),
            float2(0, 0),   float2(0.25, 0), float2(0.5, 0), float2(0.75, 0),  float2(1, 0)
        ]
      
        let destinationPositions2: [float2] = [
            float2(0, 1),  float2(0.25, 1), float2(0.5, 1.1), float2(0.75, 1.2),  float2(1, 1.1),
            float2(0, 0),   float2(0.25, 0), float2(0.5, 0), float2(0.75, 0),  float2(1, 0)
        ]
        let destinationPositions3: [float2] = [
            float2(0, 1),  float2(0.25, 1), float2(0.5, 1), float2(0.75, 1.1),  float2(1, 1.2),
            float2(0, 0),   float2(0.25, 0), float2(0.5, 0), float2(0.75, 0),  float2(1, 0)
        ]
        let destinationPositions4: [float2] = [
            float2(0, 1),  float2(0.25, 1), float2(0.5, 1), float2(0.75, 1),  float2(1, 1.1),
            float2(0, 0),   float2(0.25, 0), float2(0.5, 0), float2(0.75, 0),  float2(1, 0)
        ]
        
        let warpGeometryGrid1 = SKWarpGeometryGrid(columns: 4, rows: 1,
                                                  sourcePositions: sourcePositions,
                                                  destinationPositions: destinationPositions)
        let warpGeometryGrid2 = SKWarpGeometryGrid(columns: 4, rows: 1,
                                                   sourcePositions: sourcePositions,
                                                   destinationPositions: destinationPositions1)
        let warpGeometryGrid3 = SKWarpGeometryGrid(columns: 4, rows: 1,
                                                   sourcePositions: sourcePositions,
                                                   destinationPositions: destinationPositions2)
        let warpGeometryGrid4 = SKWarpGeometryGrid(columns: 4, rows: 1,
                                                   sourcePositions: sourcePositions,
                                                   destinationPositions: destinationPositions3)
        let warpGeometryGrid5 = SKWarpGeometryGrid(columns: 4, rows: 1,
                                                   sourcePositions: sourcePositions,
                                                   destinationPositions: destinationPositions4)
        let warpGeometryGrid6 = SKWarpGeometryGrid(columns: 4, rows: 1,
                                                   sourcePositions: sourcePositions,
                                                   destinationPositions: sourcePositions)
        
        effectNode.warpGeometry = warpGeometryGrid1
        let warpAction = SKAction.repeatForever(SKAction.animate(withWarps:[warpGeometryGrid1,
                                                             warpGeometryGrid2,
                                                             warpGeometryGrid3,
                                                             warpGeometryGrid4,
                                                             warpGeometryGrid5,
                                                             warpGeometryGrid6],
                                                                         times: [0.5, 1.0, 1.5, 2.0, 2.5, 3.0])!)
        effectNode.run(warpAction)
        
       

        
        
      
        
    }
    
    
}
