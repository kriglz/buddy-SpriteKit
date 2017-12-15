//
//  GameScene.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/6/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    private var lastUpdateTime : TimeInterval = 0
    private var dt: TimeInterval = 0.0

    
    private var buddy: BuddyNode!
    private var background = BackgroundNode()
    private var floor = FloorNode()
    private let cameraNode = SKCameraNode()
    private let controlButtons = ControlButtons()
    private let particleEmitter = ParticleNode()
    
    lazy var margin: CGFloat = size.width / 10.35

    
    
    
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        
        //Setting up scene background.
        background.setup(size: size)
        addChild(background)
        
        //Setting up the floor for buddy - grass.
        floor.setup(size: size)
        addChild(floor)
        
        //Initializes a buddy.
        spawnBuddy()
        
        //Setting up particle emitter.
        particleEmitter.setup()
        particleEmitter.name = "particleEmitter"
        
        //Setting up camera.
        cameraNode.position = CGPoint(x: buddy.position.x, y: size.height / 2)
        cameraNode.xScale = 1.0/xScaleForSceneSize
        cameraNode.yScale = 1.0
        camera = cameraNode
        addChild(cameraNode)
        
        
        //Adding WorldFrame
        let worldFrame = frame

        self.physicsBody = SKPhysicsBody(edgeLoopFrom: worldFrame)
        self.physicsBody?.categoryBitMask = WorldCategory
        self.physicsBody?.contactTestBitMask = BuddyCategory
        self.physicsWorld.contactDelegate = self
        
        
        //Adds control buttons to the scene.
        controlButtons.setup(size: size)
        controlButtons.centerOnPoint(point: buddy.position, with: margin)
        addChild(controlButtons)
    }

    
    
    ///Updates scene every 1/60 sec.
    override func update(_ currentTime: TimeInterval) {
        //Called before each frame is rendered
        
        //Initialize _lastUpdateTime if it has not already been.
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        //Calculate time since last update.
        dt = currentTime - self.lastUpdateTime
        
        
        //Updates the buddy behaviour.
        buddy.update(deltaTime: dt)
        
        //Updates camera and control buttons position if buddy has moved.
        if buddy.isWalking {
            
            //Move camera only if buddy is not by the edge of the scene.
            if buddy.position.x > self.size.width / (2.0 * xScaleForSceneSize) && buddy.position.x < self.size.width * (2.0 * xScaleForSceneSize - 1.0) / (2.0 * xScaleForSceneSize) {
                
                centerCameraOnPoint(point: buddy.position)
                controlButtons.centerOnPoint(point: buddy.position, with: margin)
            }
            
            
            
//            if action(forKey: "disappearingAction") != nil {
//                particleEmitter.removeAllActions()
//                particleEmitter.removeFromParent()
//            }
            
            particleEmitter.alpha = 1.0
 
            switch controlButtons.direction {
            case .left:
                
                if childNode(withName: "particleEmitter") == nil {
                    addChild(particleEmitter)
                }
                particleEmitter.emitParticles(at: CGPoint(x: buddy.position.x + buddy.size.width / 10, y: buddy.position.y - buddy.size.height / 2), direction: .left)
                
            case .right:
                
                if childNode(withName: "particleEmitter") == nil {
                    addChild(particleEmitter)
                }
                particleEmitter.emitParticles(at: CGPoint(x: buddy.position.x - buddy.size.width / 10, y: buddy.position.y - buddy.size.height / 2), direction: .right)
                
            default:
                break
            }
            
            
            
            
        } else {
            if childNode(withName: "particleEmitter") != nil {
                
                particleEmitter.numParticlesToEmit = 0
              
                let disappearingAction = SKAction.sequence([SKAction.fadeOut(withDuration: 0.4),
                                                            SKAction.wait(forDuration: 0.6),
                                                            
                                                            SKAction.removeFromParent()
                ])
                
                
                particleEmitter.run(disappearingAction)//, withKey: "disappearingAction")
                particleEmitter.resetSimulation()
            }
               
        }
        
        self.lastUpdateTime = currentTime
    }
    
    
   
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)
        
        if let touchPoint = touchPoint {
            
            controlButtons.touchBegan(at: touchPoint)
            
            switch controlButtons.direction {
            case .left:
                buddy.walk( .left)
                
            case .right:
                buddy.walk( .right)

            case .none:
                buddy.walk( .none)
            }
        }
    }

    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)
        
        if let touchPoint = touchPoint {
            
            controlButtons.touchMoved(to: touchPoint)
            
            switch controlButtons.direction {
            case .left:
                buddy.walk( .left)
                                
            case .right:
                buddy.walk( .right)
                
            case .none:
                buddy.walk( .none)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)

        if let touchPoint = touchPoint {
            controlButtons.touchEnded(at: touchPoint)
            
            if buddy.isWalking {
                
                buddy.walk( .none)
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if buddy.isWalking {
            
            buddy.walk( .none)
        }
    }
    
    
    
    ///Contact beginning delegate
    func didBegin(_ contact: SKPhysicsContact) {
        
        //Removes node, when it hits worldframe.
        if contact.bodyA.categoryBitMask == WorldCategory {
            
            contact.bodyB.node?.removeAllActions()
            
        } else if contact.bodyB.categoryBitMask == WorldCategory {
            
            contact.bodyA.node?.removeAllActions()
            
        }
    }

    
    
    ///Updates camera position.
    private func centerCameraOnPoint(point: CGPoint){
        
        cameraNode.position.x = point.x
        
        //Sends noficication that camera has moved.
        NotificationCenter.default.post(name: Notification.Name(rawValue: cameraMoveNotificationKey), object: nil, userInfo: [ "DirectionToMove" : controlButtons.direction,
              "BuddySpeed": buddy.walkingSpeed,
              "DeltaTime": dt])
    }

    
    
    ///Creates a new buddy.
    private func spawnBuddy(){
        
        //Checks if the buddy already exists.
        if let currentBuddy = buddy, children.contains(currentBuddy){
            currentBuddy.removeFromParent()
            currentBuddy.removeAllActions()
            currentBuddy.physicsBody = nil
        }
        
        //Creates a new buddy.
        buddy = BuddyNode.newInstance(size: size)
        let buddyInitPosition = CGPoint(x: size.width / 2, y: size.height * yForGrass + buddy.size.height / 2)
        buddy.updatePosition(point: buddyInitPosition)
        buddy.zPosition = 100
        
        addChild(buddy)
    }
}
