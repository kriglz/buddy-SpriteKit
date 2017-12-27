//
//  Constants.swift
//  buddy-SpriyeKit
//
//  Created by Kristina Gelzinyte on 12/7/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import UIKit

let WorldCategory: UInt32 = 0x1 << 1
let BuddyCategory: UInt32 = 0x1 << 2
let FloorCategory: UInt32 = 0x1 << 3
let FishCategory: UInt32 = 0x1 << 4
let FishFoodCategory: UInt32 = 0x1 << 5

let xScaleForSceneSize: CGFloat = 3.0

//For buttons
let alphaPressed: CGFloat = 0.3
let alphaDefault: CGFloat = 0.6

let yForGrass: CGFloat = 0.4
let yForGrassHorizon: CGFloat = 0.08
let yForMountains: CGFloat = 0.12
let yForSky: CGFloat = 1.0 - yForGrass - yForMountains //0.40 now

let cameraMoveNotificationKey = "cameraMoved"

let fishMoveAroundActionKey = "fishMoveAroundActionKey"
let fishSeekFoodActionKey = "fishSeekFoodActionKey"
let fishMoveToNewDestinationActionKey = "fishMoveToNewDestinationActionKey"

let horizonSpeedConstant = CGFloat(3.5)

let zPositionSky: CGFloat = 1.0
let zPositionClouds: CGFloat = 2.0
let zPositionMountains: CGFloat = 6.0
let zPositionHorizon: CGFloat = 10.0
let zPositionPalm: CGFloat = 20.0
let zPositionWater: CGFloat = 50.0
let zPositionBuddy: CGFloat = 999.0
let zPositionFish : CGFloat = 1000.0
let zPositionControl: CGFloat = 2000.0

