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
    
    private var particleEmitter = ParticleNode()
    private var isEmittingOver: Bool = false

    private var allClouds = [(BackgroundCloudsNode, CGFloat)]()
    private var allPalms = [PalmNode]()
    
    private let controlButtons = ControlButtons()
    lazy var margin: CGFloat = size.width / 10.35

    private var fishIndex: UInt32 = 0

    
    
    override func didMove(to view: SKView) {
        //Adds swipe handler to the scene.
        let swipeHandler = #selector(handleSwipeUp(byReactingTo:))
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: swipeHandler)
        swipeRecognizer.direction = .up
        self.view?.addGestureRecognizer(swipeRecognizer)
    }
    
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
                
        //Setting up scene background.
        background.setup(size: size)
        addChild(background)
        
        //Setting up the floor for buddy - grass.
        floor.setup(size: size)
        addChild(floor)
        //Updates floor node (water) to wave.
        floor.runWaves()
        
        //Initializes a buddy.
        spawnBuddy()

        //Setting up clouds.
        spawnCloud()
        
        //Setting up palms.
        spawnPalm()
        
        //Setting up fish.
        for _ in 1...3 {
            fishIndex = arc4random_uniform(2) + 1
            spawnFish()
        }
        
        
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
        self.physicsWorld.contactDelegate = self
        

        //Adds control buttons to the scene.
        controlButtons.setup(size: size)
        controlButtons.centerOnPoint(point: buddy.position, with: margin, in: size)
        addChild(controlButtons)
    }

    
    
    ///Handles swipe left (back) behaviour.
    @objc private func handleSwipeUp(byReactingTo: UISwipeGestureRecognizer){
        guard (view?.scene?.frame.width)! == size.width else {
            return
        }
        
        controlButtons.isHidden = true
        
        let transition = SKTransition.push(with: .up, duration: 0.5)
        let waterSceneSize = CGSize.init(width: size.width / xScaleForSceneSize, height: size.height)
        let waterScene = WaterScene(size: waterSceneSize)
        waterScene.scaleMode = scaleMode
        view?.presentScene(waterScene, transition: transition)
    }

    
    
    
    ///Updates scene every 1/60 sec.
    ///Called before each frame is rendered
    override func update(_ currentTime: TimeInterval) {
        
        //Initialize _lastUpdateTime if it has not already been.
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        //Calculate time since last update.
        dt = currentTime - self.lastUpdateTime
        
        
        //Updates the buddy behaviour.
        buddy.update(deltaTime: dt)
        

        for cloud in allClouds {
            cloud.0.moveTheCloud(deltaTime: dt, speed: cloud.1, in: size)
        }
        
        
        if childNode(withName: "fish") == nil {
            for _ in 1...2 {
                fishIndex = arc4random_uniform(2)+1
                spawnFish()
            }
        }
        
        
        //Updates camera and control buttons position if buddy has moved.
        if buddy.isWalking {
            
            //Move camera only if buddy is not by the edge of the scene.
            //            if buddy.position.x > self.size.width / (2.0 * xScaleForSceneSize) && buddy.position.x < self.size.width * (2.0 * xScaleForSceneSize - 1.0) / (2.0 * xScaleForSceneSize) {
            
            centerCameraOnPoint(point: buddy.position)
            controlButtons.centerOnPoint(point: buddy.position, with: margin, in: size)
            //            }
            
            
            //Emits particles
            emitBuddysParticles()
            
        } else {
            //Removes particles
            removeBuddysParticles()
        }
        
        
        self.lastUpdateTime = currentTime
    }

    
    
    
    
    
    private func emitBuddysParticles(){
        
        if isEmittingOver {
            particleEmitter.removeAllActions()
            particleEmitter.removeFromParent()
            particleEmitter.resetSimulation()
            particleEmitter.alpha = 0.3
            isEmittingOver = false
        }
                
        switch controlButtons.direction {
        case .left:
            
            particleEmitter.emitParticles(at: CGPoint(x: buddy.position.x + buddy.size.width / 3, y: buddy.position.y - buddy.size.height / 2 + 5), direction: .left)
            
            if childNode(withName: "particleEmitter") == nil {
                addChild(particleEmitter)
            }
            
        case .right:
            
            particleEmitter.emitParticles(at: CGPoint(x: buddy.position.x - buddy.size.width / 3, y: buddy.position.y - buddy.size.height / 2 + 5), direction: .right)
            
            if childNode(withName: "particleEmitter") == nil {
                addChild(particleEmitter)
            }
            
        default:
            removeBuddysParticles()
        }
    }
    
    private func removeBuddysParticles() {
        if childNode(withName: "particleEmitter") != nil {
            
            particleEmitter.numParticlesToEmit = 0
            
            let disappearingAction = SKAction.sequence([SKAction.fadeOut(withDuration: 0.2),
                                                        SKAction.removeFromParent()
                                                        ])
            particleEmitter.run(disappearingAction)
            isEmittingOver = true
        }
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
        
        //Checks if buddy was hit.
        if contact.bodyA.categoryBitMask == BuddyCategory || contact.bodyB.categoryBitMask == BuddyCategory {
            
            handleBuddyCollision(contact: contact)
            return
        }
        
        //Checks if fish was hit.
        if contact.bodyA.categoryBitMask == FishCategory || contact.bodyB.categoryBitMask == FishCategory {
            
            handleFishCollision(contact: contact)
            return
        }
    }

    
    private func handleBuddyCollision(contact: SKPhysicsContact) {
        var otherBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask == BuddyCategory {
            otherBody = contact.bodyB
        } else {
            otherBody = contact.bodyA
        }
        
        switch otherBody.categoryBitMask {
        case WorldCategory:
            buddy.removeAllActions()
       
        default:
            break
        }
    }

    private func handleFishCollision(contact: SKPhysicsContact) {
        var otherBody: SKPhysicsBody
        var fishBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask == FishCategory {
            otherBody = contact.bodyB
            fishBody = contact.bodyA
        } else {
            otherBody = contact.bodyA
            fishBody = contact.bodyB
        }
        
        switch otherBody.categoryBitMask {
        case WorldCategory:
            fishBody.node?.removeAllActions()
            fishBody.node?.removeFromParent()
            
            //Release a new fish
            spawnFish()
            
        default:
            break
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
        let buddyInitPosition = CGPoint(x: size.width / 2, y: size.height * yForGrass - 10.0 + buddy.size.height / 2 )
        buddy.updatePosition(point: buddyInitPosition)
        
        addChild(buddy)
    }
    
    ///Creates a new cloud.
    private func spawnCloud(){
        
        //Creating clouds, adding them to cloud array.
        allClouds.append(BackgroundCloudsNode.newInstance(size: size))
        allClouds.append(BackgroundCloudsNode.newInstance(size: size))
        allClouds.append(BackgroundCloudsNode.newInstance(size: size))
        allClouds.append(BackgroundCloudsNode.newInstance(size: size))
        allClouds.append(BackgroundCloudsNode.newInstance(size: size))
        allClouds.append(BackgroundCloudsNode.newInstance(size: size))
        allClouds.append(BackgroundCloudsNode.newInstance(size: size))

        //Every cloud is added to the parent and gets a notification observer for camera movement, so that speed could be adjusted.
        for cloud in allClouds {
            addChild(cloud.0)
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name(rawValue: cameraMoveNotificationKey),
                object: nil,
                queue: nil,
                using: cloud.0.moveTheClouds)
        }
    }
    
    ///Creates a new palm.
    private func spawnPalm(){
        
        allPalms.append(PalmNode.newInstance(size: size))
        allPalms.append(PalmNode.newInstance(size: size))
        allPalms.append(PalmNode.newInstance(size: size))
        allPalms.append(PalmNode.newInstance(size: size))
        allPalms.append(PalmNode.newInstance(size: size))
        allPalms.append(PalmNode.newInstance(size: size))
        allPalms.append(PalmNode.newInstance(size: size))
        allPalms.append(PalmNode.newInstance(size: size))
        
        for palm in allPalms {
            addChild(palm)
            palm.swing()
            
            //Makes background nodes observe notification about camera movements.
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name(rawValue: cameraMoveNotificationKey),
                object: nil,
                queue: nil,
                using: palm.moveThePalm)
        }
    }
    
    ///Creates a new fish.
    private func spawnFish(){
        let fish = FishNode().newInstance(size: size, randFishNumber: fishIndex)
                
        fish.swim(randFishNumber: fishIndex)
        fish.move()
        fish.emitter?.removeFromParent()
        
        fish.name = "fish"
        
        addChild(fish)
        
        //Makes fish nodes observe notification about camera movements.
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: cameraMoveNotificationKey),
            object: nil,
            queue: nil,
            using: fish.moveTheFish)
    }
}
