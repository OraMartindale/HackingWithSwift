//
//  GameScene.swift
//  Project14
//
//  Created by Ora Martindale on 4/23/19.
//  Copyright © 2019 Ora Martindale. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var slots = [WhackSlot]()
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "Score \(score)"
        }
    }
    var popupTime = 0.85
    var numRounds = 0

    override func didMove(to view: SKView) {
        addBackground()
        addGameScore()
        addSlots()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.createEnemy()
        }
    }
    
    func addBackground() {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
    }
    
    func addGameScore() {
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
    }
    
    func addSlots() {
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410))}
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 185 + (i * 170), y: 320))}
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230))}
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 185 + (i * 170), y: 140))}
    }
    
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }

    func createEnemy() {
        popupTime *= 0.99

        numRounds += 1
        if numRounds >= 30 {
            for slot in slots {
                slot.hide()
            }

            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)

            return
        }

        slots.shuffle()
        slots[0].show(hideTime: popupTime)

        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 8 { slots[1].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 10 { slots[1].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 12 { slots[1].show(hideTime: popupTime) }

        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)

        for node in tappedNodes {
            if node.name == "charFriend" || node.name == "charEnemy" {
                guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
                if !whackSlot.isVisible { continue }
                if whackSlot.isHit { continue }

                let scoreChange: Int
                let soundFileName: String
                if node.name == "charFriend" {
                    scoreChange = 1
                    soundFileName = "whack.caf"
                } else {
                    scoreChange = -5
                    soundFileName = "whackBad.caf"
                }

                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85

                whackSlot.hit()
                score += scoreChange
                run(SKAction.playSoundFileNamed(soundFileName, waitForCompletion: false))
            }
        }
    }
}
