//
//  WaterScene.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/20/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class WaterScene: SKScene {
    
    let fishIndex: UInt32 = arc4random_uniform(2) + 1

    private let emitter = SKEmitterNode(fileNamed: "BubbleParticles.sks")
    private let highScoreNode = SKLabelNode(fontNamed: "Damascus")

    
    override func didMove(to view: SKView) {
        //Adds swipe handler to the scene.
        let swipeHandler = #selector(handleSwipeDown(byReactingTo:))
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: swipeHandler)
        swipeRecognizer.direction = .down
        self.view?.addGestureRecognizer(swipeRecognizer)
    }
    
    override func sceneDidLoad() {
        
        //Creating background
        let backgroundNode = SKSpriteNode(imageNamed: "waterBackground")
        backgroundNode.size = size
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundNode.zPosition = zPositionSky
        addChild(backgroundNode)
        
        
        //Loop to create 3 fish stack.
        for index in 0...2 {
            //Creating swimming fish.
            let fish = FishNode().newInstance(size: size, randFishNumber: fishIndex)
            fish.texture = SKTexture(imageNamed: "fish\(fishIndex)")

            fish.size.width *= 3
            let topMargin = 3 * size.height / 4
            fish.position = CGPoint(x: 2 * size.width / 3 - fish.size.width / 2,
                                    y: topMargin * ( 1 - CGFloat(index) / 4))
            fish.physicsBody = nil
            
            fish.swim(randFishNumber: fishIndex)
            fish.moveAround(in: size)
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
    
    
    
    ///Handles swipe left (back) behaviour.
    @objc private func handleSwipeDown(byReactingTo: UISwipeGestureRecognizer){
        
        let transition = SKTransition.push(with: .down, duration: 0.5)
        let gameWorldSize = CGSize.init(width: size.width * xScaleForSceneSize, height: size.height)
        let gameScene = GameScene(size: gameWorldSize)
        gameScene.scaleMode = scaleMode
        view?.presentScene(gameScene, transition: transition)
    }
}
