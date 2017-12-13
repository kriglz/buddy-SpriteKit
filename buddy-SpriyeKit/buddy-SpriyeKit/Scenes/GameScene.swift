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

    private var buddy: BuddyNode!
    private var background = BackgroundNode()
    private var floor = FloorNode()
    private let cameraNode = SKCameraNode()

    private let controlButtons = ControlButtons()

    
    
    
    
    
    
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
        controlButtons.setup(size: CGSize(width: cameraNode.xScale * size.width, height: cameraNode.yScale * size.height), position: buddy.position)
        addChild(controlButtons)
        
      
    }

    

    
    //            if self.buddy.position.x > self.size.width / (2.0 * xScaleForSceneSize) && self.buddy.position.x < selfsize.width * (2.0 * xScaleForSceneSize - 1.0) / (2.0 * xScaleForSceneSize) {
    //
    //
    //                cameraNode.position.x = buddy.position.x
    //                controlButtons.position.x = buddy.position.x - cameraNode.xScale * size.width / 2
    //            }
    
    
//    private func makeBuddyToWalk() {
//        controlButtons.buttonAction = {
//
//        }
//    }
    
    
    
    
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
        
        if buddy.isWalking {
            
            buddy.walk( .none)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if buddy.isWalking {
            
            buddy.walk( .none)
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        //Called before each frame is rendered
        
        //Initialize _lastUpdateTime if it has not already been.
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        //Calculate time since last update.
        let dt = currentTime - self.lastUpdateTime

        //Updates the buddy behaviour.
        buddy.update(deltaTime: dt)
        
        
        
        
        background.direction = .right
        background.update(currentTime)

        

        
        self.lastUpdateTime = currentTime
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
    
    
    
    
    
    
    ///Creates a new buddy.
    private func spawnBuddy(){
        
        //Checks if the buddy already exists.
        if let currentBuddy = buddy, children.contains(currentBuddy){
            currentBuddy.removeFromParent()
            currentBuddy.removeAllActions()
            currentBuddy.physicsBody = nil
        }
        
        //Creates a new buddy.
        buddy = BuddyNode.newInstance()
        let buddyInitPosition = CGPoint(x: size.width / 2, y: size.height * yForGrass + buddy.size.height / 2 - 30)
        buddy.updatePosition(point: buddyInitPosition)
        buddy.zPosition = 100
        
        addChild(buddy)
    }
    
}
