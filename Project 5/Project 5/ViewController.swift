//
//  ViewController.swift
//  Project 5
//
//  Created by Артём Бурмистров on 2/15/20.
//  Copyright © 2020 Артём Бурмистров. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self,
            action: #selector(promptForAnswer)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Restart game", style: .plain, target: self,
            action: #selector(startGame)
        )
        
        if let startWordsUrl = Bundle.main.url(forResource: "start",
                                               withExtension: "txt") {
            if let words = try? String(contentsOf: startWordsUrl) {
                allWords = words.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
    }

    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        
        cell.textLabel?.text = usedWords[indexPath.row]
        
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil,
                                   preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        guard isPossible(word: lowerAnswer) else {
            promtError(message: "Word not possible!")
            return
        }
        
        guard isOriginal(word: lowerAnswer) else {
            promtError(message: "Already have it. Try to be more original.")
            return
        }
        
        guard isReal(word: lowerAnswer) else {
            promtError(message: "That is not a real word!")
            return
        }
        
        usedWords.insert(lowerAnswer, at: 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func isPossible(word: String) -> Bool {
        guard var currentWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let letterIndex = currentWord.firstIndex(of: letter) {
                currentWord.remove(at: letterIndex)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word) && word != title
    }
    
    func isReal(word: String) -> Bool {
        guard word.count >= 3 else { return false }
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word,
                range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func promtError(message: String) {
        let ac = UIAlertController(title: "Can't add this word",
                                   message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            self.promptForAnswer()
        }
        ac.addAction(action)
        present(ac, animated: true)
    }
}

