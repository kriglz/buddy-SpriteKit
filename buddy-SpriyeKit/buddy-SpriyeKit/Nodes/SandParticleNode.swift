//
//  SandParticleNode.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 1/2/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class SandParticleNode: SKSpriteNode {
    
    /// Creates a new sand node.
    public func newInstance(in size: CGSize) -> SandParticleNode {
        let sandParticle = SandParticleNode(imageNamed: "sandParticle")
        
        if let sandTexture = sandParticle.texture {
            //Adding physics body of shape of still buddy.
            let randSize = Int(arc4random_uniform(3))
            let sandParticleSize = CGSize(width: 8 + randSize, height: 8 + randSize)
            sandParticle.size = sandParticleSize
            sandParticle.zPosition = zPositionWater + 1

            sandParticle.physicsBody = SKPhysicsBody.init(texture: sandTexture, alphaThreshold: 0.1, size: CGSize(width: sandParticleSize.width * 0.5, height: sandParticleSize.height * 0.5))
            sandParticle.physicsBody?.restitution = 0.5

            //Adding contactTestBitMask for buddy.
            sandParticle.physicsBody?.categoryBitMask = SandCategory
            sandParticle.physicsBody?.contactTestBitMask = FloorCategory
        }
        return sandParticle
    }
    
    /// Adds sand dissapear animation to the node.
    public func animation(){
        
        let fade = SKAction.fadeOut(withDuration: 1.5)
        let wait = SKAction.wait(forDuration: 1.5)
        let remove = SKAction.run { [weak self] in
            self?.removeFromParent()
        }
        
        let seq = SKAction.sequence([fade, wait, remove])
        run(seq)
    }
}
