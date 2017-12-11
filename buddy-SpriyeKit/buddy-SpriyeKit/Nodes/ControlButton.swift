//
//  ControlButton.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/11/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class ControlButtons: SKNode {
    
    ///Button to go to left.
    private var goLeftButton: SKSpriteNode!
    private let goLeftButtonTexture = SKTexture(imageNamed: "buttonLeft")
    
    ///Button to go to right.
    private var goRightButton: SKSpriteNode!
    private let goRightButtonTexture = SKTexture(imageNamed: "buttonRight")
    
    
    public func setup(size: CGSize, position: CGPoint){
        
        goLeftButton = SKSpriteNode(texture: goLeftButtonTexture)
        let margin: CGFloat = 15.0
        goLeftButton.position = CGPoint(x: margin + goLeftButton.size.width / 2, y: margin + goLeftButton.size.height / 2)
        goLeftButton.zPosition = 1000
        addChild(goLeftButton)
        
        goRightButton = SKSpriteNode(texture: goRightButtonTexture)
        goRightButton.position = CGPoint(x: size.width - margin - goLeftButton.size.width / 2, y: margin + goLeftButton.size.height / 2)
        goRightButton.zPosition = 1000
        addChild(goRightButton)
    }
    
}
