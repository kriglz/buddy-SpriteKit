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
            let randSize = Int(arc4random_uniform(3))
            let sandParticleSize = CGSize(width: 5 + randSize, height: 5 + randSize)
            sandParticle.size = sandParticleSize
            sandParticle.zPosition = zPositionWater - 1

            sandParticle.physicsBody = SKPhysicsBody.init(texture: sandTexture, alphaThreshold: 0.1, size: CGSize(width: sandParticleSize.width * 0.3, height: sandParticleSize.height * 0.3))


            //Adding contactTestBitMask for buddy.
            sandParticle.physicsBody?.categoryBitMask = SandCategory
            sandParticle.physicsBody?.contactTestBitMask = FloorCategory
        }
        return sandParticle
    }
    
    public func animation(){
        
        let drop = SKAction.applyImpulse(CGVector(dx: 0, dy: 0.012), duration: 0.1)
        let wait = SKAction.wait(forDuration: 1)
        let remove = SKAction.run { [weak self] in
            self?.removeFromParent()
        }
        
        let seq = SKAction.sequence([drop, wait, remove])
        run(seq)
        
    }
    
    
}
