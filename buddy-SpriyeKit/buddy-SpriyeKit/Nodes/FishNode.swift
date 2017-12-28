//
//  FishNode.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/19/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class FishNode: SKSpriteNode {
    
    var fishSwimFrame1 = [
        SKTexture(imageNamed: "fishswing11"),
        SKTexture(imageNamed: "fishswing21"),
        SKTexture(imageNamed: "fishswing31")
    ]
    
    var fishSwimFrame2 = [
        SKTexture(imageNamed: "fishswing12"),
        SKTexture(imageNamed: "fishswing22"),
        SKTexture(imageNamed: "fishswing32")
    ]
    
    private let fishScaleConstant = CGFloat(drand48())
    public var isSeekingFishFood = false
    
    public let emitter = SKEmitterNode(fileNamed: "BubbleParticles.sks")

    ///Creates new fish node.
    public func newInstance(size: CGSize, randFishNumber: UInt32) -> FishNode {
        
        let fish = FishNode(imageNamed: "fish\(randFishNumber)")
        
        if fish.texture != nil {
            fish.size = CGSize(
                width: (size.width / 9.6) * (0.8 + 0.5 * fishScaleConstant),
                height: (size.height / 7.94) * (0.8 + 0.5 * fishScaleConstant))
            fish.position = CGPoint(
                x: CGFloat(arc4random_uniform(UInt32(size.width))),
                y: size.height / 5 - 100 * fishScaleConstant)
            fish.zPosition = zPositionFish
        }
                
        return fish
    }
    
    
    
    
    ///Adds physics body to the fish.
    public func addPhysicsBody(){
        physicsBody = SKPhysicsBody.init(texture: SKTexture(imageNamed: "fishPB"), size: size)

        physicsBody?.categoryBitMask = FishCategory
        physicsBody?.contactTestBitMask = WorldCategory | FishFoodCategory
        physicsBody?.isDynamic = false
        physicsBody?.allowsRotation = false
        physicsBody?.restitution = 1.0
        physicsBody?.affectedByGravity = false
    }
    
    
    
    
    ///Adds swim animation to the fish.
    public func swim(randFishNumber: UInt32){
        
        var fishFrame = fishSwimFrame2
        if randFishNumber == 1 {
            fishFrame = fishSwimFrame1
        }
        
        let swimAction = SKAction.repeatForever(
            SKAction.animate(with: fishFrame, timePerFrame: Double(0.1 * (1 + 2 * fishScaleConstant))))
        
        run(swimAction)
        
        if let emitter = emitter {
            emitter.position.x = 15.0 - self.size.width / 2
            emitter.particleScale = 0.04
            emitter.particleScaleSpeed = 0.01
            emitter.zPosition = zPositionFish - 10
            addChild(emitter)
        }
    }
    
    
    public var fishSpeed: CGFloat = 0

    ///Fish movement direction.
    private var direction: Direction = .left
    
    //Buddy properties.
    private var buddyDirection: Direction?
    private var buddySpeed: CGFloat?
    
    private var currentTime: TimeInterval = 0.0
    
    ///Adds swim-move action to the fish. For GAME SCENE.
    public func move(deltaTime: TimeInterval, in frameSize: CGSize){
       
        //Changes fish "swing" - y position.
        currentTime += deltaTime
        
        if currentTime > 2 {
            currentTime = 0
        }
        
        if currentTime >= 0 && currentTime <= 1 {
            position.y -= 0.1
        } else if currentTime > 1 && currentTime <= 2 {
            position.y += 0.1
        }
        
        
        
        
        var newFishSpeed = fishSpeed
    
        //Moves fish in different speed if buddy moves too.
        if let buddySpeed = buddySpeed,
            let buddyDirection = buddyDirection {
            
            switch buddyDirection {
            case .right:
                if direction == .left {
                    newFishSpeed += buddySpeed / 4
                } else {
                    newFishSpeed -= buddySpeed / 4
                }
                
            case .left:
                if direction == .left {
                    newFishSpeed -= buddySpeed / 4
                } else {
                    newFishSpeed += buddySpeed / 4
                }
                
            default:
                break
            }
        }
        
        ///Value which shows how much x is changed every `deltaTime`.
        let deltaX: CGFloat = newFishSpeed * CGFloat(deltaTime)
        
        switch direction {
        case .left:
            position.x -= deltaX
            if position.x < -size.width / 2 {
                direction = .right
                xScale = -1
            }
            
        case .right:
            position.x += deltaX * 2
            
            if position.x > frameSize.width + size.width / 2 {
                direction = .left
                xScale = 1
            }
            
        case .none:
            break
        }
        
        
        buddyDirection = nil
        buddySpeed = nil
    }
    
    @objc func moveTheFish(notification: Notification) -> Void {
        
        guard let buddysDirection = notification.userInfo!["DirectionToMove"],
            let buddysSpeed = notification.userInfo!["BuddySpeed"] else { return }
        
        buddyDirection = buddysDirection as? Direction
        buddySpeed = buddysSpeed as? CGFloat
    }
    
    public func fadeInOut(){
        
        let scaleConstant = drand48()
        self.alpha = 1.0
        let fadeInAnimation = SKAction.fadeIn(withDuration: 3 * (1 + scaleConstant))
        let fadeOutAniamtion = SKAction.fadeOut(withDuration: 1 * (1 + scaleConstant))
        let actions = SKAction.sequence([fadeInAnimation,
                                         fadeOutAniamtion,
                                         SKAction.wait(forDuration: 10 * (1 + scaleConstant))])
        
        self.run(SKAction.repeatForever(actions))
    }
  
    
    
    
    
    
    
    ///Adds swim-move action to the fish. For WATER SCENE.
    public func moveAround(in size: CGSize){
        
        let deltaX = size.width / 4
        let duration = 3.0 + Double(arc4random_uniform(6))
        
        if xScale < 1 {
            xScale = 1
        }
        
        let moveToPointAnimation = SKAction.move(to: CGPoint(x: self.position.x - deltaX, y: self.position.y + CGFloat(drand48())),
                                                 duration: duration)
        
        let flipAnimation = SKAction.run { [weak self] in
            self?.xScale *= -1
        }
        
        let moveBackToPointAnimation = SKAction.move(to: CGPoint(x: self.position.x + deltaX, y: self.position.y + CGFloat(drand48())),
                                                     duration: duration)
  
        let sequenceOfAnimations = SKAction.sequence([moveToPointAnimation,
                                                      flipAnimation,
                                                      moveBackToPointAnimation,
                                                      flipAnimation])
        
        
        run(SKAction.repeatForever(sequenceOfAnimations), withKey: fishMoveAroundActionKey)
    }
    
    
    ///Adds food following action to the fish.
    public func seekFood(node: FoodNode){
        
        if node.position.x > self.position.x {
            self.xScale = -1.0
        } else {
            self.xScale = 1.0
        }
        
        self.zRotation = atan((node.position.y - self.position.y) / (node.position.x - self.position.x))
        
        let distance = sqrt(pow((node.position.y - self.position.y), 2) + pow((node.position.x - self.position.x), 2))
        let time = Double(distance) / 70
        
        let seekAction = SKAction.move(to: node.position, duration: time)
        self.run(seekAction, withKey: fishSeekFoodActionKey)
    }
    
    
    ///Moves fish to new destination after food seeking.
    public func moveToNewDestination(in size: CGSize){
        
        let marginY = size.height / 3
        let destination = CGPoint(x: CGFloat(arc4random_uniform(UInt32( size.width))),
                                  y: CGFloat(arc4random_uniform(UInt32( size.height - 2 * marginY))) + marginY)
        
        if destination.x > self.position.x {
            self.xScale = -1.0
        } else {
            self.xScale = 1.0
        }
        
        self.zRotation = atan((destination.y - self.position.y) / (destination.x - self.position.x)) / 2
        
        let moveAction = SKAction.move(to: destination, duration: 10 * (1 + Double(drand48())))
        
        let moveAroundAction = SKAction.run { [weak self] in
            self?.zRotation = 0
            self?.moveAround(in: size)
        }
        
        let moveSequence = SKAction.sequence([moveAction, moveAroundAction])
        
        run(moveSequence, withKey: fishMoveToNewDestinationActionKey)
    }
    
    
  
    
    
    ///Makes fish jump.
//    public func jump(randFishNumber: UInt32){
//
//        var fishFrame = fishSwimFrame2
//        if randFishNumber == 1 {
//            fishFrame = fishSwimFrame1
//        }
//
//        let randAnimationCount = Int(arc4random_uniform(10))
//
//        let swimAction = SKAction.repeat(
//            SKAction.animate(with: fishFrame, timePerFrame: 0.3),
//            count: randAnimationCount)
//
//
//        let changeStateAction = SKAction.run { [weak self] in
//
//            self?.texture = SKTexture(imageNamed: "fishFly\(Int(randFishNumber))")
//            self?.size = CGSize(width: (self?.size.height)!, height: (self?.size.width)!)
//            self?.physicsBody?.affectedByGravity = true
//        }
//
//        let duration = Double(randAnimationCount) / 20 + 0.2
//
//        let jumpAction = SKAction.applyImpulse(CGVector(dx: -30.0, dy: 200.0), duration: duration)
//
//        let flipAction = SKAction.applyAngularImpulse(-1.0, duration: 20.0)
//
//        let swimJumpSequence = SKAction.sequence([swimAction, changeStateAction, jumpAction, flipAction])
//
//        run(swimJumpSequence)
//    }
    
}
