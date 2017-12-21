//
//  MenuScene.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/20/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    private let playButton = MenuButtons()

    
    override func didMove(to view: SKView) {
        let swipeHandler = #selector(handleSwipeBack(byReactingTo:))
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: swipeHandler)
        swipeRecognizer.direction = .left
        self.view?.addGestureRecognizer(swipeRecognizer)
    }
    
    override func sceneDidLoad() {
        
        //Loop to create 3 fish stack.
        for index in 0...2 {
            //Creating swimming fish.
            let fish = FishNode().newInstance(size: size)
            fish.size.width *= 3
            let topMargin = 3 * size.height / 4
            fish.position = CGPoint(x: 2 * size.width / 3 - fish.size.width / 2,
                                    y: topMargin * ( 1 - CGFloat(index) / 4))
            fish.physicsBody = nil
            
            fish.swim()
            fish.moveAround(in: size)
            addChild(fish)
        }
        
        //Sets up play button.
        
        playButton.setup(size: size)
        playButton.position = CGPoint(x: size.width / 2, y: size.height / 6)
        playButton.menuPlayButtonAction = {
            let transition = SKTransition.reveal(with: SKTransitionDirection.right , duration: 0.5)
//            let playScene = PlayScene(size: CGSize(width: self.size.width / xScaleForSceneSize, height: self.size.height))
//            playScene.scaleMode = self.scaleMode
//            self.view?.presentScene(playScene, transition: transition)
//            self.playButton.menuPlayButtonAction = nil
        }
        addChild(playButton)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)
        
        if let touchPoint = touchPoint {
            playButton.touchBegan(at: touchPoint)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)
        
        if let touchPoint = touchPoint {
            playButton.touchMoved(to: touchPoint)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)

        if let touchPoint = touchPoint {
            playButton.touchEnded(at: touchPoint)
        }
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
