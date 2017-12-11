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
    private let cameraNode = SKCameraNode()

    
    private let controlButtons = ControlButtons()

    
    
    
    
    
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        
        //Setting up scene background.
        backgroundColor = .lightGray
        background.setup(size: size)
        addChild(background)
        
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
//        controlButtons.position.x =  buddy.position.x
        addChild(controlButtons)
        
        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
        
        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
    }
    
    
    
    
    
    
    
    
//    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
//    }
//
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
//    }
//
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
    
    
    ///Set point by first touch event.
    private var firstTouchPoint: CGPoint?
    
    ///Checks if touch gesture was tap (for jump) or drag (for walk).
    private func jumpOrWalk(to lastTouchPoint: CGPoint){
        
        if let firstTouchPoint = firstTouchPoint {
            
            let direction = lastTouchPoint.x - firstTouchPoint.x
            
            if abs(direction) > 2 {
                buddy.setDestination(to: direction)
                
                if buddy.position.x > size.width / (2.0 * xScaleForSceneSize) && buddy.position.x < size.width * (2.0 * xScaleForSceneSize - 1.0) / (2.0 * xScaleForSceneSize) {
                    
                    cameraNode.run(SKAction.move(to: CGPoint(
                        x: buddy.position.x,
                        y: cameraNode.position.y), duration: 0.1))
                 
                    
                    
                }
            } else {
                buddy.jump()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)
        
        if let touchPoint = touchPoint {
            
            firstTouchPoint = touchPoint
            jumpOrWalk(to: touchPoint)
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)
        
        if let touchPoint = touchPoint {
            
            jumpOrWalk(to: touchPoint)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        buddy.stopWalking()
        
        firstTouchPoint = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
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
