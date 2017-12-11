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
        
        let yPositionOfFloor = size.height * yForGrass - 30
        let startPoint = CGPoint(x: 0, y: yPositionOfFloor)
        let endPoint = CGPoint(x: size.width, y: yPositionOfFloor)
        
        physicsBody = SKPhysicsBody(edgeFrom: startPoint, to: endPoint)
        physicsBody?.categoryBitMask = FloorCategory
        physicsBody?.contactTestBitMask = BuddyCategory
        

        //Init of ground grass - the walking surface.
        let groundGrassSize = CGSize(width: size.width, height: size.height * yForGrass)
        let groundGrassRect = CGRect(origin: CGPoint(), size: groundGrassSize)
        
        let groundGrass = SKShapeNode(rect: groundGrassRect)
        groundGrass.fillColor = .white
        groundGrass.strokeColor = .clear
        groundGrass.fillTexture = SKTexture(imageNamed: "ground")
        groundGrass.zPosition = 10
        
        
        addChild(groundGrass)
        
        print(size.height * yForMountains)
        
        
        
        //Init of horizon grass .
        let horizonGrassSize = CGSize(width: size.width, height: size.height * yForGrassHorizon + 20)
        let horizonGrassOrigin = CGPoint(x: CGPoint().x, y: size.height * yForGrass - 20)
        let horizonGrassRect = CGRect(origin: horizonGrassOrigin, size: horizonGrassSize)
        
        let horizonGrass = SKShapeNode(rect: horizonGrassRect)
        horizonGrass.fillColor = .white
        horizonGrass.strokeColor = .clear
        horizonGrass.fillTexture = SKTexture(imageNamed: "horizonGrass")
        horizonGrass.zPosition = 4
        
        addChild(horizonGrass)
        
        
        
        
        
        
        //Init of mountains.
        let mountainsSize = CGSize(width: size.width, height: size.height * yForMountains)
        let mountainsOrigin = CGPoint(x: CGPoint().x, y: size.height * (yForGrass + yForGrassHorizon) - 20)
        let mountainsSizeRect = CGRect(origin: mountainsOrigin, size: mountainsSize)
        
        let mountains = SKShapeNode(rect: mountainsSizeRect)
        mountains.fillColor = .white
        mountains.strokeColor = .clear
        mountains.fillTexture = SKTexture(imageNamed: "mountains")
        mountains.zPosition = 3
        
        addChild(mountains)
        
        let mountainsBack = SKShapeNode(rect: mountainsSizeRect)
        mountainsBack.fillColor = .white
        mountainsBack.strokeColor = .clear
        mountainsBack.fillTexture = SKTexture(imageNamed: "mountainsBack")
        mountainsBack.zPosition = 2
        
        addChild(mountainsBack) 

        
        
        //Init of sky.
        let skySize = CGSize(width: size.width, height: size.height * (yForSky + yForMountains))
        let skyOrigin = CGPoint(x: CGPoint().x, y: size.height * (yForGrass + yForGrassHorizon))
        let skynRect = CGRect(origin: skyOrigin, size: skySize)
        
        let sky = SKShapeNode(rect: skynRect)
        sky.fillColor = UIColor.init(red: 255/255, green: 254/255, blue: 240/255, alpha: 1.0)
        sky.strokeColor = .clear
        sky.zPosition = 1
        
        addChild(sky)
        
        //Init sun in the sky.
        let sunSize = CGSize(width: size.height * yForGrass * 1.68, height: size.height * yForGrass)
        let sunOrigin = CGPoint(x: CGPoint().x, y: size.height - size.height * yForGrass)
        let sunRect = CGRect(origin: sunOrigin, size: sunSize)
        
        let sun = SKShapeNode(rect: sunRect)
        sun.fillColor = .white
        sun.strokeColor = .clear
        sun.fillTexture = SKTexture(imageNamed: "skySun")
        sun.zPosition = 4
        
        addChild(sun)
        
       
        
        
//        let grassLine = SKShapeNode(rect: CGRect(x: size.width / 2, y: size.height / 2, width: 200, height: 30))
//        grassLine.physicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width: 200, height: 30))
//        grassLine.fillColor = .orange
//        grassLine.physicsBody?.isDynamic = false
//
//        let effectNode = SKEffectNode()
//        effectNode.addChild(grassLine)
//        addChild(effectNode)
//        let sourcePositions: [float2] = [
//            float2(0, 1),  float2(0.25, 1), float2(0.5, 1), float2(0.75, 1),  float2(1, 1),
//            float2(0, 0),   float2(0.25, 0), float2(0.5, 0), float2(0.75, 0),  float2(1, 0)
//        ]
//        let destinationPositions: [float2] = [
//            float2(0, 1),  float2(0.25, 1.1), float2(0.5, 1.1), float2(0.75, 1),  float2(1, 1),
//            float2(0, 0),   float2(0.25, 0), float2(0.5, 0), float2(0.75, 0),  float2(1, 0)
//        ]
//        let destinationPositions1: [float2] = [
//            float2(0, 1),  float2(0.25, 1.1), float2(0.5, 1.2), float2(0.75, 1.1),  float2(1, 1),
//            float2(0, 0),   float2(0.25, 0), float2(0.5, 0), float2(0.75, 0),  float2(1, 0)
//        ]
//
//        let destinationPositions2: [float2] = [
//            float2(0, 1),  float2(0.25, 1), float2(0.5, 1.1), float2(0.75, 1.2),  float2(1, 1.1),
//            float2(0, 0),   float2(0.25, 0), float2(0.5, 0), float2(0.75, 0),  float2(1, 0)
//        ]
//        let destinationPositions3: [float2] = [
//            float2(0, 1),  float2(0.25, 1), float2(0.5, 1), float2(0.75, 1.1),  float2(1, 1.2),
//            float2(0, 0),   float2(0.25, 0), float2(0.5, 0), float2(0.75, 0),  float2(1, 0)
//        ]
//        let destinationPositions4: [float2] = [
//            float2(0, 1),  float2(0.25, 1), float2(0.5, 1), float2(0.75, 1),  float2(1, 1.1),
//            float2(0, 0),   float2(0.25, 0), float2(0.5, 0), float2(0.75, 0),  float2(1, 0)
//        ]
//
//        let warpGeometryGrid1 = SKWarpGeometryGrid(columns: 4, rows: 1,
//                                                  sourcePositions: sourcePositions,
//                                                  destinationPositions: destinationPositions)
//        let warpGeometryGrid2 = SKWarpGeometryGrid(columns: 4, rows: 1,
//                                                   sourcePositions: sourcePositions,
//                                                   destinationPositions: destinationPositions1)
//        let warpGeometryGrid3 = SKWarpGeometryGrid(columns: 4, rows: 1,
//                                                   sourcePositions: sourcePositions,
//                                                   destinationPositions: destinationPositions2)
//        let warpGeometryGrid4 = SKWarpGeometryGrid(columns: 4, rows: 1,
//                                                   sourcePositions: sourcePositions,
//                                                   destinationPositions: destinationPositions3)
//        let warpGeometryGrid5 = SKWarpGeometryGrid(columns: 4, rows: 1,
//                                                   sourcePositions: sourcePositions,
//                                                   destinationPositions: destinationPositions4)
//        let warpGeometryGrid6 = SKWarpGeometryGrid(columns: 4, rows: 1,
//                                                   sourcePositions: sourcePositions,
//                                                   destinationPositions: sourcePositions)
//
//        effectNode.warpGeometry = warpGeometryGrid1
//        let warpAction = SKAction.repeatForever(SKAction.animate(withWarps:[warpGeometryGrid1,
//                                                             warpGeometryGrid2,
//                                                             warpGeometryGrid3,
//                                                             warpGeometryGrid4,
//                                                             warpGeometryGrid5,
//                                                             warpGeometryGrid6],
//                                                                         times: [0.5, 1.0, 1.5, 2.0, 2.5, 3.0])!)
//        effectNode.run(warpAction)
        
       

        
        
      
        
    }
    
    
}
