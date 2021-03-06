//
//  ControlButton.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/11/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class ControlButtons: SKNode {
    
    /// Node which describes selected button.
    private(set) var direction: Direction = .none
    
    /// Button to go to left.
    private var goLeftButton: SKSpriteNode!
    private let goLeftButtonTexture = SKTexture(imageNamed: "buttonLeft")
    
    /// Button to go to right.
    private var goRightButton: SKSpriteNode!
    private let goRightButtonTexture = SKTexture(imageNamed: "buttonRight")
    
    /// Button night mode.
    private var nightModeButton: SKSpriteNode!
    private let nightModeButtonTexture = SKTexture(imageNamed: "buttonNightMode")

    /// Button to go to menu screen.
    private var menuButton: SKSpriteNode!
    private let menuButtonTexture = SKTexture(imageNamed: "buttonMenu")
    /// Defines if menu button is pressed.
    private(set) var isMenuButtonPressed = false
    /// Function for menu button.
    public var menuButtonAction: (() -> ())?
    

    
    /// Created control buttons.
    public func setup(size: CGSize){
        let buttonSize = CGSize(width: size.width / 17.74, height: size.height / 10.51)
        
        goLeftButton = SKSpriteNode(texture: goLeftButtonTexture)
        goLeftButton.size = buttonSize
        goLeftButton.zPosition = zPositionControl
        goLeftButton.alpha = alphaDefault
        addChild(goLeftButton)
        
        goRightButton = SKSpriteNode(texture: goRightButtonTexture)
        goRightButton.size = buttonSize
        goRightButton.zPosition = zPositionControl
        goRightButton.alpha = alphaDefault
        addChild(goRightButton)
        
        nightModeButton = SKSpriteNode(texture: nightModeButtonTexture)
        nightModeButton.size = CGSize(width: buttonSize.width * 0.6, height: buttonSize.height * 0.6)
        nightModeButton.zPosition = zPositionControl
        nightModeButton.alpha = alphaDefault
        addChild(nightModeButton)
    }
    
    
    
    /// Decides which button was touched.
    private func getButton(for point: CGPoint) {

        /// Point which is touch point converted to left button coordinate system.
        var pointLeft = goLeftButton.convert(point, from: parent!)
        // Adding button origin and half size to make point and button coordinate systems completely equal.
        pointLeft.x += goLeftButton.frame.origin.x + goLeftButton.size.width / 2
        pointLeft.y += goLeftButton.frame.origin.y + goLeftButton.size.height / 2
       
        /// Point which is touch point converted to left button coordinate system.
        var pointRight = goRightButton.convert(point, from: parent!)
        // Adding button origin and half size to make point and button coordinate systems completely equal.
        pointRight.x += goRightButton.frame.origin.x + goRightButton.size.width / 2
        pointRight.y += goRightButton.frame.origin.y + goRightButton.size.height / 2
        
        // Checks if either one button was touched.
        // Only one button can be touched at a time.
            if goLeftButton.frame.contains(pointLeft) {
            direction = .left
            goLeftButton.alpha = alphaPressed
            goRightButton.alpha = alphaDefault
        } else if goRightButton.frame.contains(pointRight) {
            direction = .right
            goRightButton.alpha = alphaPressed
            goLeftButton.alpha = alphaDefault
        } else {
            direction = .none
            goRightButton.alpha = alphaDefault
            goLeftButton.alpha = alphaDefault
        }
    }
    
   
  
    public func touchBegan(at point: CGPoint){
        getButton(for: point)
    }
    
    public func touchMoved(to point: CGPoint){
        getButton(for: point)
    }
    
    public func touchEnded(at point: CGPoint){
        direction = .none
        goRightButton.alpha = alphaDefault
        goLeftButton.alpha = alphaDefault
    }
    
    
    
    public func centerOnPoint(point: CGPoint, in size: CGSize){
        let marginX: CGFloat = size.width / 10.35
        let marginY: CGFloat = size.width / 10.35 / 7.7 

        goLeftButton.position = CGPoint(x: point.x - marginX - goLeftButton.size.width / 2, y: marginY + goLeftButton.size.height / 2)
        goRightButton.position = CGPoint(x: point.x + marginX + goRightButton.size.width / 2, y: marginY + goRightButton.size.height / 2)
    }
}


