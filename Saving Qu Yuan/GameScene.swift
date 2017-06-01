//
//  GameScene.swift
//  Saving Qu Yuan
//
//  Created by 羅子原 on 2017/5/29.
//  Copyright © 2017年 羅子原. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var scoreBoard = QYScoreBoard()
    var mainCharacter = SKSpriteNode()
    
    fileprivate var characterHooked = false
    fileprivate var characterSelected = false
    fileprivate var mainCharWidth: CGFloat = 0.0
      
    override func didMove(to view: SKView) {
        mainCharacter = self.childNode(withName: "mainCharacter") as! SKSpriteNode
        mainCharWidth = mainCharacter.frame.size.width
        
        let dumplingSpawnCD = SKAction.wait(forDuration: 0.2, withRange: 0.2)
        let spawnDumpling = SKAction.run {
            
            let newDumping = QYAvgSpeedNode(imageNamed: "riceDumpling")
            
            let randomX = QYRandomHelper.randomCGFloat(min: -335.0, max: 335.0)
            let randomSpeedY = QYRandomHelper.randomCGFloat(min: -5.0, max: -25.0)
            
            newDumping.name = "riceDumpling"
            newDumping.zPosition = 2.0
            newDumping.position.x = randomX;    newDumping.position.y = 617.0
            newDumping.size.width = 80.0;       newDumping.size.height = 80.0
            newDumping.avgSpeed.x = 0.0;        newDumping.avgSpeed.y = randomSpeedY
            
            self.addChild(newDumping)
        }
        let dumplingSequence = SKAction.sequence([dumplingSpawnCD, spawnDumpling])
        self.run(SKAction.repeatForever(dumplingSequence))
        
        
        let hoookSpawnCD = SKAction.wait(forDuration: 12, withRange: 10)
        let spawnHook = SKAction.run {
            
            let newHook = QYAvgSpeedNode(imageNamed: "fishHook")
            let randomX = QYRandomHelper.randomCGFloat(min: -335.0, max: 335.0)
            let randomSpeedY = QYRandomHelper.randomCGFloat(min: -20.0, max: -30.0)
            
            newHook.name = "fishHook"
            newHook.zPosition = 1.0
            newHook.position.x = randomX;   newHook.position.y = 617.0
            newHook.size.width = 80.0;      newHook.size.height = 80.0
            newHook.avgSpeed.x = 0.0;       newHook.avgSpeed.y = randomSpeedY
            
            self.addChild(newHook)
        }
        let hookSequence = SKAction.sequence([hoookSpawnCD, spawnHook])
        self.run(SKAction.repeatForever(hookSequence))
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if characterHooked {
            if !self.frame.intersects(mainCharacter.frame) {
                mainCharacter.removeFromParent()
            }
        }
        
        enumerateChildNodes(withName: "riceDumpling") { (dumpling, stop) in
            
            let target = dumpling as! QYAvgSpeedNode
            target.position.y += target.avgSpeed.y
            
            if self.mainCharacter.frame.contains(target.frame) {
                self.scoreBoard.add()
                target.removeFromParent()
            } else if !self.frame.intersects(target.frame) {
                target.removeFromParent()
            }
        }
        
        enumerateChildNodes(withName: "fishHook") { (hook, stop) in
            
            let target = hook as! QYAvgSpeedNode
            target.position.y += target.avgSpeed.y
            
            if self.mainCharacter.frame.contains(target.frame) {
                
                self.characterHooked = true
                
                target.avgSpeed.y = abs(target.avgSpeed.y)
                self.characterSelected = false
                self.isUserInteractionEnabled = false
                self.mainCharacter.position = target.position
                
            } else if !self.frame.intersects(target.frame) {
                
                if target.avgSpeed.y < 0 {
                    target.avgSpeed.y = abs(target.avgSpeed.y)
                } else {
                    target.removeFromParent()
                }
            }
        }
    }
    
    // MARK: - Gesture
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            for node in self.nodes(at: t.location(in: self)) {
                characterSelected = node.isEqual(to: mainCharacter)
                if characterSelected {
                    break
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if characterSelected {
            let halfWidth = mainCharWidth / 2
            for t in touches {
                var leftPos = t.location(in: self)
                leftPos.x -= halfWidth
                var rightPos = t.location(in: self)
                rightPos.x += halfWidth
                if self.frame.contains(leftPos) && self.frame.contains(rightPos){
                    mainCharacter.position.x = t.location(in: self).x
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        characterSelected = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        characterSelected = false
    }
}
