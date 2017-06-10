//
//  GameMenu.swift
//  Saving Qu Yuan
//
//  Created by 羅子原 on 2017/6/1.
//  Copyright © 2017年 羅子原. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class GameMenu: SKScene {
    
    private var audioPlayer: AVAudioPlayer?
    fileprivate var targetNode: SKNode?
    
    // MARK: - SKScene LifeCycle
    override func didMove(to view: SKView) {
        setupAudioPlayer()
        guard audioPlayer != nil else { return }
        audioPlayer!.prepareToPlay()
        audioPlayer!.play()
    }
    
    override func willMove(from view: SKView) {
        if audioPlayer != nil {
            audioPlayer!.setVolume(0, fadeDuration: 1.0)
        }
    }
    
    // MARK: Setup
    func setupAudioPlayer() {
        let backgroundMusicURL = URL(fileURLWithPath: Bundle.main.path(forResource: "three inch heaven",
                                                                       ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: backgroundMusicURL)
        } catch let error as NSError {
            print("Error: \(error.description)")
        }
    }
    
    // MARK: Other
    func forwardToGameScene() {
        let gameScene = SKScene(fileNamed: "GameScene")!
        gameScene.scaleMode = .aspectFill
        view?.presentScene(gameScene, transition: SKTransition.crossFade(withDuration: 0.8))
    }
    
    // MARK: - SKScene Gesture
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            targetNode = atPoint(t.location(in: self))
        }
        
        if let name = targetNode?.name {
            if name == "settings" || name == "speaker" || name == "control" {
                targetNode!.run(SKAction.scale(to: 0.9, duration: 0.05))
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
            if name == "settings" || name == "speaker" || name == "control" {
                targetNode!.run(SKAction.scale(to: 1.0, duration: 0.05))
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
                targetNode!.run(SKAction.scale(to: 1.0, duration: 0.05))
                
            } else if name == "speaker" {
                targetNode!.run(SKAction.scale(to: 1.0, duration: 0.05))
                
            } else if name == "control" {
                targetNode!.run(SKAction.scale(to: 1.0, duration: 0.05))
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
                targetNode!.run(SKAction.scale(to: 1.0, duration: 0.05))
                
            } else if name == "speaker" {
                targetNode!.run(SKAction.scale(to: 1.0, duration: 0.05))
            } else if name == "control" {
                targetNode!.run(SKAction.scale(to: 1.0, duration: 0.05))
            }
        }
    }
}
