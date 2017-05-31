//
//  QYScoreBoard.swift
//  Saving Qu Yuan
//
//  Created by 羅子原 on 2017/5/31.
//  Copyright © 2017年 羅子原. All rights reserved.
//

import Foundation

class QYScoreBoard: NSObject {
    
    fileprivate var score = 0
    
    public var current:Int {
        get {
            return score
        }
    }
    
    public convenience init(score: Int) {
        self.init()
        self.score = score
    }
    
    public func add() {
        self.score += 1
    }
}
