//
//  ViewController.swift
//  Project8
//
//  Created by Ora Martindale on 7/20/18.
//  Copyright © 2018 Ora Martindale. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {
    @IBOutlet weak var cluesLabel: UILabel!
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var currentAnswer: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    
    @IBAction func submitTapped(_ sender: UIButton) {
        guard let solutionPosition = solutions.index(of: currentAnswer.text!) else {
            return
        }
        activatedButtons.removeAll()
        
        revealCorrectAnswer(at: solutionPosition)
        
        currentAnswer.text = ""
        score += 1
        
        if isLevelCompleted() {
            presentLevelCompletedAlert()
        }
    }
    
    @IBAction func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""
        
        for btn in activatedButtons {
            UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: {
                btn.alpha = 1
            })
        }
        activatedButtons.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for subview in view.subviews where subview.tag == 1001 {
            let btn = subview as! UIButton
            letterButtons.append(btn)
            btn.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
        }
        
        loadLevel()
    }

    @objc func letterTapped(btn: UIButton) {
        currentAnswer.text = currentAnswer.text! + btn.titleLabel!.text!
        activatedButtons.append(btn)
        UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: {
            btn.alpha = 0
        })
    }

    func loadLevel() {
        guard let levelFilePath = Bundle.main.path(forResource: "level\(level)", ofType: "txt") else {
            return
        }
        guard let levelCounts = try? String(contentsOfFile: levelFilePath) else {
            return
        }
        var lines = levelCounts.components(separatedBy: "\n")
        lines = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: lines) as! [String]
        
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        for (index, line) in lines.enumerated() {
            let parts = line.components(separatedBy: ": ")
            let answer = parts[0]
            let clue = parts[1]
            
            clueString += "\(index + 1). \(clue)\n"
            
            let solutionWord = answer.replacingOccurrences(of: "|", with: "")
            solutionString += "\(solutionWord.count) letters\n"
            solutions.append(solutionWord)
            
            let bits = answer.components(separatedBy: "|")
            letterBits += bits
        }
        
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterBits = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: letterBits) as! [String]
        
        if letterBits.count == letterButtons.count {
            for i in 0 ..< letterBits.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }

    func revealCorrectAnswer(at: Int) {
        var splitAnswers = answersLabel.text!.components(separatedBy: "\n")
        splitAnswers[at] = currentAnswer.text!
        answersLabel.text = splitAnswers.joined(separator: "\n")
    }

    func isLevelCompleted() -> Bool {
        return score % 7 == 0
    }

    func presentLevelCompletedAlert() {
        let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
        present(ac, animated: true)
    }

    func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)

        loadLevel()

        for btn in letterButtons {
            btn.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

