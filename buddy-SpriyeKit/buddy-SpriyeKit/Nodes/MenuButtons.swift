//
//  MenuButtons.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/21/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class MenuButtons: SKNode {
    
    ///Button to play at menu screen.
    private var menuPlayButton: SKSpriteNode!
    private let menuPlayButtonTexture = SKTexture(imageNamed: "buttonPlay")
    ///Defines if menu play button is pressed.
    private(set) var isMenuPlayButtonPressed = false
    ///Function for menu play button.
    public var menuPlayButtonAction: (() -> ())?
    
    
    public func setup(size: CGSize){
        let buttonSize = CGSize(width: size.width / 2.3885, height: size.height / 9.2)
        
        menuPlayButton = SKSpriteNode(texture: menuPlayButtonTexture)
        menuPlayButton.size = buttonSize
        menuPlayButton.zPosition = zPositionControl
        menuPlayButton.alpha = alphaDefault
        addChild(menuPlayButton)
    }
    
    
    private func getButton(for point: CGPoint) {
        ///Point which is touch point converted to menu button coordinate system.
        var pointMenu = menuPlayButton.convert(point, from: parent!)
        //Adding button origin and half size to make point and button coordinate systems completely equal.
        
        let pointMenuFrame = CGRect(x: menuPlayButton.frame.origin.x,
                                    y: menuPlayButton.frame.origin.y,
                                    width: menuPlayButton.size.width,
                                    height: menuPlayButton.size.height)
        
        pointMenu.x += pointMenuFrame.origin.x + pointMenuFrame.size.width / 2
        pointMenu.y += pointMenuFrame.origin.y + pointMenuFrame.size.height / 2
        
        //Checks if play button was touched.
        if pointMenuFrame.contains(pointMenu){
            menuPlayButton.alpha = alphaPressed
            isMenuPlayButtonPressed = true
        } else {
            menuPlayButton.alpha = alphaDefault
            isMenuPlayButtonPressed = false
        }
    }
    
    
    public func touchBegan(at point: CGPoint){
        getButton(for: point)
    }
    
    public func touchMoved(to point: CGPoint){
        getButton(for: point)
    }
    
    public func touchEnded(at point: CGPoint){
        menuPlayButton.alpha = alphaDefault
        
        if isMenuPlayButtonPressed && menuPlayButtonAction != nil {
            menuPlayButtonAction!()
        }
    }
}



