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
        let gameWorldSize = CGSize.init(width: view.frame.size.width * xScaleForSceneSize, height: view.frame.size.height)
        let gameSceneNode = GameScene(size: gameWorldSize)
        
        
        // Present the scene
        if let view = self.view as! SKView? {
            view.presentScene(gameSceneNode)
            
            view.ignoresSiblingOrder = true
            
//            view.showsPhysics = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        
      
        
        
    }

    override var shouldAutorotate: Bool {
        return false
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
