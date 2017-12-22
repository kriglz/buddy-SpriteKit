//
//  WaterScene.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/20/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class WaterScene: SKScene {
    
    private var lastUpdateTime : TimeInterval = 0
    private var dt: TimeInterval = 0.0
    
    var fishIndex: UInt32 = 0
    private var isExitingScene = false

    private let emitter = SKEmitterNode(fileNamed: "BubbleParticles.sks")
    private let highScoreNode = SKLabelNode(fontNamed: "Damascus")

    private var backgroundDarkNode: SKSpriteNode!
    private var backgroundLightNode: SKSpriteNode!
    
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
        
        
        //Loop to create 3 fish stack.
        for index in 0...2 {
            //Creating swimming fish.
            fishIndex = arc4random_uniform(2) + 1
            let fish = FishNode().newInstance(size: size, randFishNumber: fishIndex)
            fish.texture = SKTexture(imageNamed: "fish\(fishIndex)")

            fish.size.width *= 3
            let topMargin = 3 * size.height / 4
            fish.position = CGPoint(x: 2 * size.width / 3 - fish.size.width / 2,
                                    y: topMargin * ( 1 - CGFloat(index) / 4))
            fish.physicsBody = nil
            
            fish.swim(randFishNumber: fishIndex)
            
            allFish.append(fish)
        }
        
        for fish in allFish {
            addChild(fish)
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
        
        for fish in allFish {
            
            let point = CGPoint(x: 1.0, y: 1.0)
            
            
            fish.moveFish(by: point)
        }
        

        
        
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
}
