//
//  PlayScene.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/21/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class PlayScene: SKScene, SKPhysicsContactDelegate {

    private var lastUpdateTime : TimeInterval = 0
    private var dt: TimeInterval = 0.0

    private var background = BackgroundNode()
    private var floor = FloorNode()

    private var allClouds = [(BackgroundCloudsNode, CGFloat)]()
    private var allPalms = [PalmNode]()

    private var fishIndex: UInt32 = 0



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

        //Setting up clouds.
        spawnCloud()

        //Setting up palms.
        spawnPalm()

        //Setting up fish.
        for _ in 1...3 {
            fishIndex = arc4random_uniform(2)+1
            spawnFish()
        }



        //Adding WorldFrame
        let worldFrame = frame

        self.physicsBody = SKPhysicsBody(edgeLoopFrom: worldFrame)
        self.physicsBody?.categoryBitMask = WorldCategory
        self.physicsWorld.contactDelegate = self
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



        for cloud in allClouds {
            cloud.0.moveTheCloud(deltaTime: dt, speed: cloud.1, in: size)
        }


        if childNode(withName: "fish") == nil {
            for _ in 1...2 {
                fishIndex = arc4random_uniform(2)+1
                spawnFish()
            }
        }
    }






    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)

        if let touchPoint = touchPoint {


        }
    }


    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)

        if let touchPoint = touchPoint {

        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)

        if let touchPoint = touchPoint {

        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {


    }




    ///Contact beginning delegate
    func didBegin(_ contact: SKPhysicsContact) {

        //Checks if fish was hit.
        if contact.bodyA.categoryBitMask == FishCategory || contact.bodyB.categoryBitMask == FishCategory {

            handleFishCollision(contact: contact)
            return
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




    ///Creates a new cloud.
    public func spawnCloud(){

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

    private func spawnFish(){
        let fish = FishNode().newInstance(size: size, randFishNumber: fishIndex)

        fish.physicsBody = nil

        fish.swim(randFishNumber: fishIndex)
        fish.move()

        fish.name = "fish"

        addChild(fish)
    }
}

