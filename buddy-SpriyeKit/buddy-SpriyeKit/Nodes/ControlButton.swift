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
    
    
    private(set) var isPressed = false
    var buttonAction: (() -> ())?

    
    public func setup(size: CGSize, position: CGPoint){
        
        goLeftButton = SKSpriteNode(texture: goLeftButtonTexture)
        let margin: CGFloat = 15.0
        goLeftButton.position = CGPoint(x: margin + goLeftButton.size.width / 2, y: margin + goLeftButton.size.height / 2)
        goLeftButton.zPosition = 1000
        goLeftButton.alpha = alphaDefault
        addChild(goLeftButton)
        
        goRightButton = SKSpriteNode(texture: goRightButtonTexture)
        goRightButton.position = CGPoint(x: size.width - margin - goLeftButton.size.width / 2, y: margin + goLeftButton.size.height / 2)
        goRightButton.zPosition = 1000
        goRightButton.alpha = alphaDefault
        addChild(goRightButton)
    }
    
    let alphaPressed: CGFloat = 0.5
    let alphaDefault: CGFloat = 0.8
    
    
    
    private func setButton(for point: CGPoint) {

        ///Point which is touch point converted to button coordinate system.
        var point = goLeftButton.convert(point, from: parent!)
        //Adding button origin and half size to make point and button coordinate systems completely equal.
        point.x += goLeftButton.frame.origin.x + goLeftButton.size.width / 2
        point.y += goLeftButton.frame.origin.y + goLeftButton.size.height / 2
       
        //Checks if either one button was touched.
        //Only one button can be touched at a time.
        if goLeftButton.frame.contains(point) {
            button = goLeftButton
            goLeftButton.alpha = alphaPressed
            goRightButton.alpha = alphaDefault

        } else if goRightButton.frame.contains(point) {
            button = goRightButton
            goRightButton.alpha = alphaPressed
            goLeftButton.alpha = alphaDefault
        } else {
            button = nil
            goRightButton.alpha = alphaDefault
            goLeftButton.alpha = alphaDefault
            
        }
    }
    
    ///Node which describes selected button.
    var button: SKSpriteNode?
    
    
    public func touchBegan(at point: CGPoint){
        setButton(for: point)
        
        if button != nil {
//            if buttonIsPressed {
//                //Cancel the last click.
//                buttonIsPressed = false
//
//            } else {
                isPressed = true
                
                if buttonAction != nil {
                    buttonAction!()
                }
//            }
        }
    }
    
    public func touchMoved(to point: CGPoint){
        setButton(for: point)
        
        if button != nil {
            if isPressed {
                if buttonAction != nil {
                    buttonAction!()
                }
            }
        }
    }
    
    public func touchEnded(at point: CGPoint){
        
        isPressed = false
        goRightButton.alpha = alphaDefault
        goLeftButton.alpha = alphaDefault
        
    }
}


