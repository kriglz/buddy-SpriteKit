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
    
    private var isExitingScene = false

    private var backgroundDarkNode: SKSpriteNode!
    private var backgroundLightNode: SKSpriteNode!
    
    private var fishIndex: UInt32 = 0

    private var allFish = [FishNode]()
    private var fishFoodNode = FoodNode()
    private var isFishFoodReleased = false
    private var fishSeekingTime: TimeInterval = 0.0
    private var tapCount = 0

    private let emitter = SKEmitterNode(fileNamed: "BubbleParticles.sks")

    
    ///Button to feed fish.
    private var fishFoodButton = SKSpriteNode()
    
    ///Button to fish.
    private var spearButton: SKSpriteNode!
    private let spearButtonTexture = SKTexture(imageNamed: "Spear")
    
    override func didMove(to view: SKView) {
        //Adds swipe handler to the scene.
        let swipeHandler = #selector(handleSwipeDown(byReactingTo:))
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: swipeHandler)
        swipeRecognizer.direction = .down
        self.view?.addGestureRecognizer(swipeRecognizer)
        
        //Adds tap handler to the scene.
        let tapHandler = #selector(handleTapGesture(byReactingTo:))
        let tapRecognizer = UITapGestureRecognizer(target: self, action: tapHandler)
        tapRecognizer.numberOfTapsRequired = 1
        self.view?.addGestureRecognizer(tapRecognizer)
        
    }
    
    override func sceneDidLoad() {
        
        //Creating init background
        backgroundDarkNode = SKSpriteNode(imageNamed: "waterBackgroundDark")
        backgroundDarkNode.name = "backgroundDarkNode"
        backgroundDarkNode.size = size
        backgroundDarkNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundDarkNode.zPosition = zPositionFish + 10
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
        for _ in 0...5 {
            spawnFish()
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

        //Adds shader which makes water grass to wave.
        let waveShader = SKShader(fileNamed: "waveShader.fsh")
        waveShader.attributes = [
            SKAttribute(name: "a_sprite_size", type: .vectorFloat2)
        ]
        waterGrass.shader = waveShader
        
        let waterGrassSize = vector_float2(Float(waterGrass.frame.size.width),
                                       Float(waterGrass.frame.size.height))
        waterGrass.setValue(SKAttributeValue(vectorFloat2: waterGrassSize),
                        forAttribute: "a_sprite_size")
        
        
        
        //Adding WorldFrame
        let worldFrame = CGRect(origin: CGPoint(x: frame.origin.x - 20, y: frame.origin.y - 20),
                                size: CGSize(width: frame.size.width + 40, height: frame.size.height + 40))        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: worldFrame)
        self.physicsBody?.categoryBitMask = WorldCategory
        self.physicsWorld.contactDelegate = self
        
        
        
        //Adda fish food button
        fishFoodButton = SKSpriteNode(texture: SKTexture(imageNamed: "buttonFishFood"))
        let buttonSize = CGSize(width: size.width / 5.91, height: size.height / 10.51)
        fishFoodButton.size = buttonSize
    
        let margin = size.width / 26.565
        fishFoodButton.position = CGPoint(x: size.width - fishFoodButton.size.width / 2 - margin, y: fishFoodButton.size.height / 2 + margin)
        fishFoodButton.zPosition = backgroundDarkNode.zPosition - 1
        fishFoodButton.alpha = alphaDefault
        addChild(fishFoodButton)
        
        spearButton = SKSpriteNode(texture: spearButtonTexture)
        spearButton.size = buttonSize
        spearButton.position = CGPoint(x: fishFoodButton.size.width / 2 + margin, y: fishFoodButton.size.height / 2 + margin)
        spearButton.zPosition = backgroundDarkNode.zPosition - 1
        spearButton.alpha = alphaDefault
        addChild(spearButton)
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
        
        //Set `isFoodReleased` to false if there are no food left.
        if childNode(withName: "fishFood") == nil && isFishFoodReleased {
            isFishFoodReleased = false
            tapCount = 0
            
            for fish in allFish {
                if fish.isSeekingFishFood {
                    fish.removeAction(forKey: fishSeekFoodActionKey)
                    fish.isSeekingFishFood = false
                    fish.physicsBody?.isDynamic = false
                    
                    fish.run(SKAction.wait(forDuration: 0.5), completion: { [weak self] in
                        fish.moveToNewDestination(in: (self?.size)!)
                    })
                }
            }
        }
        

        
        
        //Make fish to seek food.
        if isFishFoodReleased {
            fishSeekingTime += dt
            
            if fishSeekingTime > 1 {
                
                for fish in allFish {
                    
                    if fish.isSeekingFishFood {
                        
                        //Removes other actions first.
                        removeFishMoveAction(for: fish)
                        
                        if fish.action(forKey: fishMoveAroundActionKey) == nil {
                            
                            fish.removeAction(forKey: fishSeekFoodActionKey)
                            
                            //Adds seeking action to the fish.
                            let goalFood = closestFishFoodNode(for: fish)
                            fish.seekFood(node: goalFood)
                        }
                    } else {
                        //If fish is not seeking food anymore, removes eseeking action.
                        if fish.action(forKey: fishSeekFoodActionKey) != nil {
                            fish.removeAction(forKey: fishSeekFoodActionKey)
                        }
                        //Checks if new action needs to be added.
                        if fish.action(forKey: fishMoveAroundActionKey) == nil && fish.action(forKey: fishMoveToNewDestinationActionKey) == nil {
                            
                            fish.run(SKAction.wait(forDuration: 0.5), completion: { [weak self] in
                                fish.moveToNewDestination(in: (self?.size)!)})
                        }
                    }
                }
                //Resets seeking action timer.
                fishSeekingTime = 0.0
            }
        }
        self.lastUpdateTime = currentTime
    }
    
    
    
    
    ///Finds closest food node for fish to seek.
    private func closestFishFoodNode(for fish: FishNode) -> FoodNode {
        
        let foodArray = self["fishFood"]

        let sorted = foodArray.sorted {abs($0.position.x - fish.position.x) < abs($1.position.x - fish.position.x)}
        let food = sorted[0] as! FoodNode
        
        return food
    }
    
    
    ///Removes fish move actions before it starts to seek food.
    private func removeFishMoveAction(for fish: FishNode){
        if fish.action(forKey: fishMoveAroundActionKey) != nil || fish.action(forKey: fishMoveToNewDestinationActionKey) != nil {
            
            let removeAction = SKAction.run {
                fish.removeAction(forKey: fishMoveAroundActionKey)
                fish.removeAction(forKey: fishMoveToNewDestinationActionKey)
            }
            
            fish.run(removeAction)
        }
    }
    

    ///Handles tap gesture.
    @objc private func handleTapGesture(byReactingTo: UISwipeGestureRecognizer){
        //Loop to create 3 fish food after tap.
        tapCount += 1

        let fadeOut = SKAction.fadeAlpha(to: alphaPressed, duration: 0)
        let wait = SKAction.wait(forDuration: 0.1)
        let fadeIn = SKAction.fadeAlpha(to: alphaDefault, duration: 0)
        
        fishFoodButton.run(SKAction.sequence([fadeOut, wait, fadeIn]))
        
        
        for _ in 0...1 {
            spawnFishFood()
            
            //Makes a decision for fish if it needs to seek the food.
            //Also resets the decision if more than 4 times fish food was released.
            if !isFishFoodReleased || tapCount > 4 {
                isFishFoodReleased = true
                tapCount = 0
                
                ///Sets fish seek or not seek fish food.
                for fish in allFish {
                    if arc4random_uniform(3) == 0 {
                        fish.isSeekingFishFood = true
                        fish.physicsBody?.isDynamic = true
                    } else {
                        fish.isSeekingFishFood = false
                        fish.physicsBody?.isDynamic = false
                    }
                }
            }
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
    
    
    
    
    
    
    
    
    ///creates a new fish
    private func spawnFish(){
        //Creating swimming fish.
        fishIndex = arc4random_uniform(2) + 1
        
        let fish = FishNode().newInstance(size: size, randFishNumber: fishIndex)
        fish.size.height /= 1.5
        fish.size.width *= 3/1.5


        
        fish.zPosition += CGFloat(drand48())
        
        let margin = size.height / 10
        fish.position = CGPoint(x: CGFloat(arc4random_uniform(UInt32( size.width))),
                                y: margin + CGFloat(arc4random_uniform( UInt32( 8 * size.height / 10))))
        
        fish.swim(randFishNumber: fishIndex)
        fish.moveAround(in: size)
        fish.addPhysicsBody()
        
        allFish.append(fish)
        addChild(fish)
    }
    
    
    ///Adds fish food to the scene.
    private func spawnFishFood(){

        let food = fishFoodNode.newInstance(size: size)
        food.position = CGPoint(
            x: 2 * size.width / 8 + CGFloat(arc4random_uniform(UInt32(size.width / 2))),
            y: size.height - 10.0)
        
        food.fallingInTheWater()
        food.disintegrating()
        
        food.name = "fishFood"
        
        addChild(food)
    }
    
    
    
    
    
    
    
    
    
    ///Contact beginning delegate
    func didBegin(_ contact: SKPhysicsContact) {
        
        //Checks if fish food was hit.
        if contact.bodyA.categoryBitMask == FishFoodCategory || contact.bodyB.categoryBitMask == FishFoodCategory {
            
            handleFishFoodCollision(contact: contact)
            return
        }
    }
    
    
    ///Removes fish food node if fish touch it or it touches the worl frame.
    private func handleFishFoodCollision(contact: SKPhysicsContact) {
        var otherBody: SKPhysicsBody
        var foodBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask == FishFoodCategory {
            otherBody = contact.bodyB
            foodBody = contact.bodyA
        } else {
            otherBody = contact.bodyA
            foodBody = contact.bodyB
        }
        
        switch otherBody.categoryBitMask {
         
        case FishCategory:
            foodBody.node?.removeFromParent()

        case WorldCategory:
            foodBody.node?.removeFromParent()
            
        default:
            break
        }
    }
}
