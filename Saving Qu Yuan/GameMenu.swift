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
    
    // MARK: Variables
    fileprivate var userDefaults = UserDefaults.standard
    fileprivate var audioPlayer: AVAudioPlayer?
    fileprivate var speakerNode: SKSpriteNode!
    fileprivate var controlNode: SKSpriteNode!
    private var targetNode: SKNode?
    private var mute: Bool {
        get {
            return userDefaults.value(forKey: "Mute") as! Bool
        }
        set {
            userDefaults.set(newValue, forKey: "Mute")
            if newValue {
                speakerNode.texture = SKTexture(imageNamed: "speakerOff_icon")
                audioPlayer?.pause()
            } else {
                speakerNode.texture = SKTexture(imageNamed: "speakerOn_icon")
                audioPlayer?.play()
            }
        }
    }
    private var controlType: QYGameControlType {
        get {
            return QYGameControlType(rawValue: userDefaults.value(forKey: "ControlType") as! Int)!
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: "ControlType")
            switch newValue {
            case .Tilt:
                controlNode.texture = SKTexture(imageNamed: "tilt_icon")
            case .Touch:
                controlNode.texture = SKTexture(imageNamed: "touch_icon")
            }
        }
    }
    
    // MARK: - SKScene LifeCycle
    override func didMove(to view: SKView) {
        speakerNode = self.childNode(withName: "speaker") as! SKSpriteNode
        controlNode = self.childNode(withName: "control") as! SKSpriteNode
        
        setupControl()
        setupAudioPlayer()
        if audioPlayer != nil && !mute {
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        }
        
    }
    
    override func willMove(from view: SKView) {
        audioPlayer?.stop()
    }
    
    // MARK: setup
    private func setupAudioPlayer() {
        let backgroundMusicURL = URL(fileURLWithPath: Bundle.main.path(forResource: "three inch heaven",
                                                                       ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: backgroundMusicURL)
            audioPlayer?.numberOfLoops = -1
        } catch let error as NSError {
            print("Error: \(error.description)")
        }
        if mute {
            speakerNode.texture = SKTexture(imageNamed: "speakerOff_icon")
        } else {
            speakerNode.texture = SKTexture(imageNamed: "speakerOn_icon")
        }
    }
    
    private func setupControl() {
        switch controlType {
        case .Tilt:
            controlNode.texture = SKTexture(imageNamed: "tilt_icon")
        case .Touch:
            controlNode.texture = SKTexture(imageNamed: "touch_icon")
        }
    }
    
    // MARK: other
    func forwardToGameScene() {
        if !mute {
            run(SKAction.playSoundFileNamed("drum.mp3", waitForCompletion: false))
        }
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
            if name == "speaker" || name == "control" {
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
            if name == "speaker" || name == "control" {
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
                
            } else if name == "speaker" {
                targetNode!.run(SKAction.scale(to: 1.0, duration: 0.05))
                mute = !mute
                
            } else if name == "control" {
                targetNode!.run(SKAction.scale(to: 1.0, duration: 0.05))
                switch controlType {
                case .Tilt:
                    controlType = .Touch
                case .Touch:
                    controlType = .Tilt
                }
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
                
            } else if name == "speaker" {
                targetNode!.run(SKAction.scale(to: 1.0, duration: 0.05))
                mute = !mute
                
            } else if name == "control" {
                targetNode!.run(SKAction.scale(to: 1.0, duration: 0.05))
                switch controlType {
                case .Tilt:
                    controlType = .Touch
                case .Touch:
                    controlType = .Tilt
                }
            }
        }
    }
}
