//
//  GameViewController.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/6/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Loading scene directly.
        
        /// Main game scene.
//        let sceneNode = MenuScene(size: view.frame.size)
        let gameWorldSize = CGSize.init(width: view.frame.size.width * xScaleForSceneSize, height: view.frame.size.height)
        let sceneNode = GameScene(size: gameWorldSize)
        
        
        // Present the scene
        if let view = self.view as! SKView? {
            view.presentScene(sceneNode)
            
            view.ignoresSiblingOrder = true
            
//            view.showsPhysics = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        
      
        
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
//        // including entities and graphs.
//        if let scene = GKScene(fileNamed: "GameScene") {
//
//            // Get the SKScene from the loaded GKScene
//            if let sceneNode = scene.rootNode as! GameScene? {
//
//                // Copy gameplay related content over to the scene
//                sceneNode.entities = scene.entities
//                sceneNode.graphs = scene.graphs
//
//                // Set the scale mode to scale to fit the window
//                sceneNode.scaleMode = .aspectFill
//
//                // Present the scene
//                if let view = self.view as! SKView? {
//                    view.presentScene(sceneNode)
//
//                    view.ignoresSiblingOrder = true
//
//                    view.showsFPS = true
//                    view.showsNodeCount = true
//                }
//            }
//        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
