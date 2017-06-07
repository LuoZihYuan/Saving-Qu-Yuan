//
//  GameMenu.swift
//  Saving Qu Yuan
//
//  Created by 羅子原 on 2017/6/1.
//  Copyright © 2017年 羅子原. All rights reserved.
//

import UIKit
import SpriteKit

class GameMenu: SKScene {
    
    fileprivate var targetNode: SKNode?
    
    override func didMove(to view: SKView) {
        
    }
    
    func forwardToGameScene() {
        let gameScene = SKScene(fileNamed: "GameScene")!
        gameScene.scaleMode = .aspectFill
        view?.presentScene(gameScene, transition: SKTransition.crossFade(withDuration: TimeInterval(0.8)))
    }
    
    // MARK: Touch Related
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            targetNode = atPoint(t.location(in: self))
        }
        
        if let name = targetNode?.name {
            if name == "settings" || name == "scoreboard" {
                targetNode!.run(SKAction.scale(to: 0.9, duration: TimeInterval(0.05)))
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if targetNode == nil {
            return
        }
        var selectedNode: SKNode?
        for t in touches {
            selectedNode = atPoint(t.location(in: self))
        }
        if selectedNode?.name == targetNode?.name {
            return
        }
        if let name = targetNode?.name {
            if name == "settings" || name == "scoreboard" {
                targetNode!.run(SKAction.scale(to: 1.0, duration: TimeInterval(0.05)))
            }
        }
        targetNode = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if targetNode == nil {
            return
        }
        if let name = targetNode?.name {
            if name == "startLabel" {
                self.isUserInteractionEnabled = false
                forwardToGameScene()
                
            } else if name == "settings" {
                targetNode!.run(SKAction.scale(to: 1.0, duration: TimeInterval(0.05)))
                
            } else if name == "scoreboard" {
                targetNode!.run(SKAction.scale(to: 1.0, duration: TimeInterval(0.05)))
                
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if targetNode == nil {
            return
        }
        if let name = targetNode?.name {
            if name == "startLabel" {
                
                self.isUserInteractionEnabled = false
                forwardToGameScene()
                
            } else if name == "settings" {
                targetNode!.run(SKAction.scale(to: 1.0, duration: TimeInterval(0.05)))
                
            } else if name == "scoreboard" {
                targetNode!.run(SKAction.scale(to: 1.0, duration: TimeInterval(0.05)))
                
            }
        }
    }
}
