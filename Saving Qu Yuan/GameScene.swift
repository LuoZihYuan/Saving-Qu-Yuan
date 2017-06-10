//
//  GameScene.swift
//  Saving Qu Yuan
//
//  Created by 羅子原 on 2017/5/29.
//  Copyright © 2017年 羅子原. All rights reserved.
//

import SpriteKit
import CoreMotion
import GameplayKit

fileprivate let QYGameSceneHookProductionKey = "QYGameSceneHookProductionKey"

class GameScene: SKScene {
    
    // MARK: - Variables
    /*!
        Storage
     */
    fileprivate let userDefaults = UserDefaults.standard
    private var mute: Bool {
        get { return userDefaults.value(forKey: "Mute") as! Bool }
    }
    private var controlType: QYGameControlType {
        get { return QYGameControlType(rawValue: userDefaults.value(forKey: "ControlType") as! Int)! }
    }
    
    /*!
        Main Character
     */
    fileprivate var mainCharacter: SKSpriteNode!
    
    fileprivate var characterSelected = false
    
    fileprivate var characterHooked: Bool = false {
        didSet {
            if characterHooked {
                isUserInteractionEnabled = false
                characterSelected = false
                motionManager.stopDeviceMotionUpdates()
                removeAction(forKey: QYGameSceneHookProductionKey)
            }
        }
    }
    
    private var characterHookedSpeed: CGFloat = 0.0
    
    
    /*!
        Score
     */
    fileprivate var maxScoreLabel: SKLabelNode!
    
    fileprivate var scoreLabel: SKLabelNode!
    
    fileprivate var highestScore: Int {
        get {
            return userDefaults.value(forKey: "HighestScore_" + String(describing: controlType)) as! Int
        }
        set {
            maxScoreLabel.text = "\(newValue)"
            userDefaults.set(newValue, forKey: "HighestScore_" + String(describing: controlType))
        }
    }
    
    fileprivate var score: Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
            if score > highestScore {
                highestScore = score
            }
        }
    }
    
    /*!
        Motion
     */
    fileprivate let motionManager = CMMotionManager()
    
    
    // MARK: - SKScene Lifecycle
    override func didMove(to view: SKView) {
        
        mainCharacter = self.childNode(withName: "mainCharacter") as! SKSpriteNode
        maxScoreLabel = self.childNode(withName: "max_score") as! SKLabelNode
        maxScoreLabel.text = "\(highestScore)"
        scoreLabel = self.childNode(withName: "score") as! SKLabelNode
        
        switch controlType {
        case .Tilt:
            isUserInteractionEnabled = false
            setupMotionManager()
        case .Touch:
            isUserInteractionEnabled = true
        }
        if !mute {
            setupBackgroundSound()
        }
        setupDumplings()
        setupHooks()
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if characterHooked {
            mainCharacter.position.y += characterHookedSpeed
            if !self.frame.intersects(mainCharacter.frame) {
                let gameMenu = SKScene(fileNamed: "GameMenu")!
                gameMenu.scaleMode = .aspectFill
                view?.presentScene(gameMenu, transition: SKTransition.crossFade(withDuration: TimeInterval(0.5)))
            }
        }
        
        enumerateChildNodes(withName: "riceDumpling") { (dumpling, stop) in
            let target = dumpling as! QYAvgSpeedNode
            target.position.y += target.avgSpeed.y
            if !self.frame.intersects(target.frame) {
                target.removeFromParent()
            }
            guard !self.characterHooked else {
                return
            }
            
            if self.mainCharacter.frame.contains(target.position) {
                if !self.mute {
                    self.run(SKAction.playSoundFileNamed("crunch.m4a", waitForCompletion: false))
                }
                self.score += 1
                target.removeFromParent()
            }
        }
        
        enumerateChildNodes(withName: "fishHook") { (hook, stop) in
            let target = hook as! QYAvgSpeedNode
            target.position.y += target.avgSpeed.y
            
            if !self.frame.intersects(target.frame) {
                if target.avgSpeed.y < 0 {
                    target.avgSpeed.y = abs(target.avgSpeed.y)
                } else {
                    target.removeFromParent()
                }
            }
            guard !self.characterHooked else {
                return
            }
            if self.mainCharacter.frame.contains(target.frame) {
                self.characterHooked = true
                target.avgSpeed.y = abs(target.avgSpeed.y)
                self.characterHookedSpeed = target.avgSpeed.y
            }
        }
    }
    
    // MARK: - Setup
    private func setupMotionManager() {
        
        let constant = 180.0 / Double.pi
        
        motionManager.startDeviceMotionUpdates(to: OperationQueue()) { (motion, error) in
            // avoid conflict between screen touch and motion manager
            if self.characterSelected {
                return
            }
            
            if motion != nil {
                
                // degree of roll turns inaccurate when pitch gets greater than 80.0 or less than -80.0 degrees
                let pitchDeg = motion!.attitude.pitch * constant
                if abs(pitchDeg) > 80.0 {
                    return
                }
                let rollDeg = motion!.attitude.roll * constant
                // the closer the absolute value of degrees gets to 90.0 degrees, the steeper the phone is
                let distance = abs(90.0 - abs(rollDeg))
                // categorize distance into 8 speed levels
                let speed = 8 - (Int(distance) / 10)
                let maxSpeed = min(speed, 6)
                let velocity = (rollDeg >= 0) ? maxSpeed: -maxSpeed
                let nextPostion = CGPoint(x: self.mainCharacter.position.x + CGFloat(velocity * 6),
                                          y: self.mainCharacter.position.y)
                if self.frame.contains(nextPostion) {
                    self.mainCharacter.position = nextPostion
                }
            }
        }
    }
    
    private func setupDumplings() {
        let dumplingSpawnCD = SKAction.wait(forDuration: 0.2, withRange: 0.2)
        let spawnDumpling = SKAction.run {
            
            let newDumping = QYAvgSpeedNode(imageNamed: "riceDumpling")
            
            let randomX = QYRandomHelper.randomCGFloat(min: -335.0, max: 335.0)
            let randomSpeedY = QYRandomHelper.randomCGFloat(min: -5.0, max: -25.0)
            
            newDumping.name = "riceDumpling"
            newDumping.zPosition = 3.0
            newDumping.position.x = randomX;    newDumping.position.y = 617.0
            newDumping.size.width = 80.0;       newDumping.size.height = 80.0
            newDumping.avgSpeed.x = 0.0;        newDumping.avgSpeed.y = randomSpeedY
            
            self.addChild(newDumping)
        }
        let dumplingSequence = SKAction.sequence([dumplingSpawnCD, spawnDumpling])
        self.run(SKAction.repeatForever(dumplingSequence))
    }
    
    private func setupHooks() {
        let hoookSpawnCD = SKAction.wait(forDuration: 7, withRange: 5)
        let spawnHook = SKAction.run {
            
            var newHooks: Array<QYAvgSpeedNode> = []
            let hookAmount = QYRandomHelper.randomInt(min: 1, max: 4)
            for _ in 1...hookAmount {
                
                let newHook = QYAvgSpeedNode(imageNamed: "fishHook")
                let randomX = QYRandomHelper.randomCGFloat(min: -375.0, max: 375.0)
                let randomSpeedY = QYRandomHelper.randomCGFloat(min: -20.0, max: -30.0)
                
                newHook.name = "fishHook"
                newHook.zPosition = 2.0
                newHook.position.x = randomX;   newHook.position.y = 617.0
                newHook.size.width = 80.0;      newHook.size.height = 80.0
                newHook.avgSpeed.x = 0.0;       newHook.avgSpeed.y = randomSpeedY
                
                newHooks.append(newHook)
            }
            
            for hook in newHooks {
                self.addChild(hook)
            }
        }
        let hookSequence = SKAction.sequence([hoookSpawnCD, spawnHook])
        self.run(SKAction.repeatForever(hookSequence), withKey: QYGameSceneHookProductionKey)
    }
    
    private func setupBackgroundSound() {
        print("hihi")
        let soundSpawnCD = SKAction.wait(forDuration: 10, withRange: 3)
        let newSound = SKAction.playSoundFileNamed("bubble.m4a", waitForCompletion: false)
        let soundSequence = SKAction.sequence([newSound, soundSpawnCD])
        self.run(SKAction.repeatForever(soundSequence))
    }
    
    // MARK: - SKScene Gesture
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
            for t in touches {
                if self.frame.contains(t.location(in: self)){
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
