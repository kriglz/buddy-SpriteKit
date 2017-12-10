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
let xScaleForSceneSize: CGFloat = 3.0

let yForGrass: CGFloat = 0.25
let yForGrassHorizon: CGFloat = 0.13
let yForMountains: CGFloat = 0.15
let yForSky: CGFloat = 1.0 - yForGrass - yForMountains //0.40 now
