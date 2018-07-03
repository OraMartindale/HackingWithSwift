//
//  ViewController.swift
//  Project5
//
//  Created by Ora Martindale on 5/20/18.
//  Copyright © 2018 Ora Martindale. All rights reserved.
//

import GameplayKit
import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    var wordIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        loadDefaultWords()
        startGame()
    }
    
    func loadDefaultWords() {
        if let startWordsPath = Bundle.main.path(forResource: "start", ofType: "txt") {
            if let startWords = try? String(contentsOfFile: startWordsPath) {
                allWords = startWords.components(separatedBy: "\n")
            } else {
                allWords = ["silkworms"]
            }
        } else {
            allWords = ["silkworm"]
        }
        allWords = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allWords) as! [String]
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned self, ac] _ in
            let answer = ac.textFields![0]
            self.submit(answer: answer.text!)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }

    func submit(answer: String) {
        let lowerAnswer = answer.lowercased()
        
        if isWordSameAsTitle(word: lowerAnswer) {
            showErrorMessage(title: "Word not allowed", message: "You can't use the word itself as an answer.")
            return
        }
        if !isLongEnough(word: lowerAnswer) {
            showErrorMessage(title: "Word too short", message: "Must be at least 3 letters.")
            return
        }
        if !isAnagram(word: lowerAnswer) {
            showErrorMessage(title: "Word not possible", message: "You can't spell that word from '\(title!.lowercased())'!")
            return
        }
        if !isNotAlreadyUsed(word: lowerAnswer) {
            showErrorMessage(title: "Word used already", message: "Be more original!")
            return
        }
        if !isWord(word: lowerAnswer) {
            showErrorMessage(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }

        usedWords.insert(answer, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    func isWordSameAsTitle(word: String) -> Bool {
        return word == title
    }
    
    func isLongEnough(word: String) -> Bool {
        let range = NSMakeRange(0, word.utf16.count)
        return range.length >= 3
    }
    
    func isAnagram(word: String) -> Bool {
        var tempWord = title!.lowercased()
        
        for letter in word {
            if let pos = tempWord.range(of: String(letter)) {
                tempWord.remove(at: pos.lowerBound)
            } else {
                return false
            }
        }
        return true
    }
    
    func isNotAlreadyUsed(word: String) -> Bool {
        return !usedWords.contains(word)
    }

    func isWord(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSMakeRange(0, word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }

    func showErrorMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    func startGame() {
        title = allWords[wordIndex]
        wordIndex += 1
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
}

