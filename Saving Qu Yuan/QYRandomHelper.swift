//
//  QYRandomHelper.swift
//  Saving Qu Yuan
//
//  Created by 羅子原 on 2017/5/31.
//  Copyright © 2017年 羅子原. All rights reserved.
//

import UIKit
import Foundation

class QYRandomHelper: NSObject {
    class func randomInt(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    class func randomDouble(min: Double, max: Double) -> Double {
        return (Double(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
    
    class func randomFloat(min: Float, max: Float) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
    
    class func randomCGFloat(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat(self.randomFloat(min: Float(min), max: Float(max)))
    }
}
