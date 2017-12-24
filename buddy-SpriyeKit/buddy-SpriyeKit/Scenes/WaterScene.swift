//
//  WaterScene.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/20/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class WaterScene: SKScene, SKPhysicsContactDelegate {
    
    private var lastUpdateTime : TimeInterval = 0
    private var dt: TimeInterval = 0.0
    
    var fishIndex: UInt32 = 0
    
    private var isExitingScene = false

    private let emitter = SKEmitterNode(fileNamed: "BubbleParticles.sks")
    private let highScoreNode = SKLabelNode(fontNamed: "Damascus")

    private var backgroundDarkNode: SKSpriteNode!
    private var backgroundLightNode: SKSpriteNode!
    
    
    private var foodNode = FoodNode()
    
    private var allFish = [FishNode]()
    
    override func didMove(to view: SKView) {
        //Adds swipe handler to the scene.
        let swipeHandler = #selector(handleSwipeDown(byReactingTo:))
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: swipeHandler)
        swipeRecognizer.direction = .down
        self.view?.addGestureRecognizer(swipeRecognizer)
    }
    
    override func sceneDidLoad() {
        
        //Creating init background
        backgroundDarkNode = SKSpriteNode(imageNamed: "waterBackgroundDark")
        backgroundDarkNode.name = "backgroundDarkNode"
        backgroundDarkNode.size = size
        backgroundDarkNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundDarkNode.zPosition = zPositionFish + 1
        addChild(backgroundDarkNode)
        
        //Creating background light
        backgroundLightNode = SKSpriteNode(imageNamed: "waterBackgroundLight")
        backgroundLightNode.size = size
        backgroundLightNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundLightNode.alpha = 0
        backgroundLightNode.zPosition = zPositionSky + 1
        addChild(backgroundLightNode)
        
        //Creating background
        let backgroundNode = SKSpriteNode(imageNamed: "waterBackground")
        backgroundNode.size = size
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundNode.zPosition = zPositionSky
        addChild(backgroundNode)
        
        
        //Loop to create 3 fish initially in the scene.
        for _ in 0...2 {
            spawnFish()
        }
        
        //Loop to create 3 fish food initially in the scene.
        for _ in 0...2 {
            spawnFishFood()
        }
        

        
    
        //Adds bubbles to the background.
        if let emitter = emitter {
            emitter.position = CGPoint(x: self.size.width / 2, y: 0)
            emitter.particlePositionRange.dx = self.size.width / 2
            emitter.zPosition = zPositionFish - 1
            emitter.alpha = 0.6
            emitter.particleLifetime = 10.0
            emitter.particleBirthRate = 0.3
            addChild(emitter)
        }
        
        let waterGrass = SKSpriteNode(texture: SKTexture(imageNamed: "waterBackgroundGrass"))
        waterGrass.size = size
        waterGrass.position = CGPoint(x: size.width / 2, y: size.height / 2)
        waterGrass.zPosition = backgroundNode.zPosition + 1
        addChild(waterGrass)
        
        
        //Adding WorldFrame
        let worldFrame = frame
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: worldFrame)
        self.physicsBody?.categoryBitMask = WorldCategory
        self.physicsWorld.contactDelegate = self
//        self.physicsWorld.gravity.dy = -0.1
    }
    
   
    
    
    
    //Called before each frame is rendered
    override func update(_ currentTime: TimeInterval) {
        
        //Initialize _lastUpdateTime if it has not already been.
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        //Calculate time since last update.
        dt = currentTime - self.lastUpdateTime
        
        //Scene emerges from behind the dark water background node.
        if currentTime > 2 {
            let disappearAction = SKAction.fadeOut(withDuration: 2)
            backgroundDarkNode.run(disappearAction)
            
            let lightAppearAction = SKAction.sequence([SKAction.wait(forDuration: 2), SKAction.fadeIn(withDuration: 2)])
            backgroundLightNode.run(lightAppearAction)
        }
        
        //Scene disappears underneath the dark water node before transition.
        if isExitingScene {
            let appearAction = SKAction.sequence([SKAction.fadeIn(withDuration: 0.05), SKAction.wait(forDuration: 0.1)])
            backgroundDarkNode.run(appearAction, completion: { [weak self] in
                self?.switchToTheGameScene()
            })
        }
        
        
        //Fish movement.
        
//        for index in 0..<allFish.count {
//            
//            let distanceToDestination = sqrt(pow((allFish[index].0.position.x - allFish[index].1.x), 2) + pow((allFish[index].0.position.y - allFish[index].1.y), 2))
//            
//            //Sets the helicopter speed.
//            if distanceToDestination > 6 {
//                let directionX = allFish[index].1.x - allFish[index].0.position.x
//                let directionY = allFish[index].1.y - allFish[index].0.position.y
//                
//                let deltaX = directionX * 0.01
//                let deltaY = directionY * 0.01
//                
//                let delta = CGPoint(x: deltaX, y: deltaY)
//                
//                allFish[index].0.moveFish(by: delta)
//                
//            } else {
//                allFish[index].1 = generateFishDestinationPoint(for: allFish[index].0.position)
//               
//            }
//        }
    }
    
    
    
    ///Handles swipe up behaviour, by changing `isExitingScene` to true.
    @objc private func handleSwipeDown(byReactingTo: UISwipeGestureRecognizer){
        isExitingScene = true
    }
    
    ///Moves the current scene out of frame.
    private func switchToTheGameScene() {
        
        let transition = SKTransition.push(with: .down, duration: 0.5)
        let gameSceneSize = CGSize.init(width: self.size.width * xScaleForSceneSize, height: self.size.height)
        let gameScene = GameScene(size: gameSceneSize)
        gameScene.scaleMode = self.scaleMode
        self.view?.presentScene(gameScene, transition: transition)
    }
    
    
    
    ///creates a new fish
    private func spawnFish(){
        //Creating swimming fish.
        fishIndex = arc4random_uniform(2) + 1
        
        let fish = FishNode().newInstance(size: size, randFishNumber: fishIndex)
        fish.size.width *= 3
        fish.physicsBody = nil

        fish.zPosition += CGFloat(drand48())
        
        let margin = size.height / 10
        fish.position = CGPoint(x: CGFloat(arc4random_uniform(UInt32( size.width))),
                                y: margin + CGFloat(arc4random_uniform( UInt32( 8 * size.height / 10))))
        
        fish.swim(randFishNumber: fishIndex)
        fish.moveAround(in: size)
        
        allFish.append(fish)
        addChild(fish)
    }
    
    private func spawnFishFood(){

        let food = foodNode.newInstance(size: size)
        food.position = CGPoint(
            x: CGFloat(arc4random_uniform(UInt32(size.width))),
            y: size.height - 10.0)
        
        food.fallingInTheWater()
        
        addChild(food)
    }
}
