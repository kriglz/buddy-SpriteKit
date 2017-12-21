//
//  MenuScene.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/20/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        let swipeHandler = #selector(handleSwipeBack(byReactingTo:))
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: swipeHandler)
        swipeRecognizer.direction = .left
        self.view?.addGestureRecognizer(swipeRecognizer)
    }
    
    override func sceneDidLoad() {
        
        let fish = FishNode().newInstance(size: size)
        fish.size.width *= 3
        fish.position = CGPoint(x: 2 * size.width / 3 - fish.size.width / 2, y: 3 * size.height / 4)
        fish.physicsBody = nil
        
        fish.swim()
        fish.moveAround(in: size)
        addChild(fish)
        
        
    }
    
    
    
    ///Handles swipe left (back) behaviour.
    @objc private func handleSwipeBack(byReactingTo: UISwipeGestureRecognizer){
        
        let transition = SKTransition.reveal(with: .left, duration: 0.5)
        let gameWorldSize = CGSize.init(width: size.width * xScaleForSceneSize, height: size.height)
        let gameScene = GameScene(size: gameWorldSize)
        gameScene.scaleMode = scaleMode
        view?.presentScene(gameScene, transition: transition)
    }
}
