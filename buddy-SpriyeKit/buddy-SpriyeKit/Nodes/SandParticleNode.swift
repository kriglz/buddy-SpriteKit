//
//  SandParticleNode.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 1/2/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class SandParticleNode: SKSpriteNode {
    
    
    public func newInstance(in size: CGSize) -> SandParticleNode {
        let sandParticle = SandParticleNode(imageNamed: "sandParticle")
        
        if let sandTexture = sandParticle.texture {
            //Adding physics body of shape of still buddy.
            let sandParticleSize = CGSize(width: 5, height: 5)
            sandParticle.size = sandParticleSize
            
            sandParticle.physicsBody = SKPhysicsBody.init(texture: sandTexture, alphaThreshold: 0.1, size: sandParticleSize)
//            sandParticle.physicsBody?.allowsRotation = false
//            sandParticle.zPosition = zPositionBuddy
//
            //Adding contactTestBitMask for buddy.
            sandParticle.physicsBody?.categoryBitMask = SandCategory
            sandParticle.physicsBody?.contactTestBitMask = FloorCategory
        }
        return sandParticle
    }
    
    public func animation(){
        
        let drop = SKAction.run(SKAction.move(by: CGVector(dx: 0, dy: 0.01), duration: 1), onChildWithName: "sand")
        let wait = SKAction.wait(forDuration: 1)
        let remove = SKAction.run { [weak self] in
            self?.removeFromParent()
        }
        
        let seq = SKAction.sequence([drop, wait, remove])
        run(seq)
        
    }
    
    
}
