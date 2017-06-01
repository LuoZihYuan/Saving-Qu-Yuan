//
//  GameMenu.swift
//  Saving Qu Yuan
//
//  Created by 羅子原 on 2017/6/1.
//  Copyright © 2017年 羅子原. All rights reserved.
//

import SpriteKit

class GameMenu: SKScene {
    
    var startLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
        startLabel = self.childNode(withName: "startLabel") as! SKLabelNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if atPoint(touch.location(in: self)).isEqual(to: startLabel) {
                let gameScene = SKScene(fileNamed: "GameScene")!
                gameScene.scaleMode = .aspectFill
                view?.presentScene(gameScene, transition: SKTransition.doorsCloseHorizontal(withDuration: TimeInterval(2)))
            }
        }
    }
}
