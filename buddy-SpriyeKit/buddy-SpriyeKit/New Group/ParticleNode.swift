//
//  ParticleNode.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/14/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class ParticleNode: SKEmitterNode {
    
    let emitter = SKEmitterNode(fileNamed: "MagicParticles.sks")
    
    func setup(){
        
        if let emitter = emitter {
            
            emitter.name = "magic"
            emitter.zPosition = 99
            emitter.targetNode = self

            addChild(emitter)
        }
    }
    
    
    func emitParticles(at point: CGPoint, direction: Direction){
        
        if let emitter = emitter {
            
            emitter.position = point
            
            switch direction {
            case .left:
                emitter.emissionAngle = 0
                emitter.emissionAngleRange = .pi / 9
                emitter.xAcceleration = 200
            case .right:
                emitter.emissionAngle = .pi
                emitter.emissionAngleRange = .pi / 9
                emitter.xAcceleration = -200
            default:
                break
            }
        }
    }
}

