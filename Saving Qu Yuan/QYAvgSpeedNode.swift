//
//  QYAvgSpeedNode.swift
//  Saving Qu Yuan
//
//  Created by 羅子原 on 2017/5/31.
//  Copyright © 2017年 羅子原. All rights reserved.
//

import SpriteKit

public struct Speed2D {
    
    public var x: CGFloat
    
    public var y: CGFloat
    
    public init() {
        self.x = 0
        self.y = 0
    }
    
    public init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
}

class QYAvgSpeedNode: SKSpriteNode {
    var avgSpeed = Speed2D()
}

