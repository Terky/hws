//
//  ViewController.swift
//  Hangman
//
//  Created by Артём Бурмистров on 3/22/20.
//  Copyright © 2020 Артём Бурмистров. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map { String($0) }
    
    var letterButtons = [UIButton]()
    var wordLabel: UILabel!
    
    var words = [String]()
    var answer = 0
    
    var wrongAnswersCount = 0 {
        didSet {
            if wrongAnswersCount == 5 {
                promptMessage(title: "You lost!",
                              message: "The word was \(words[answer])")
            }
        }
    }
    
    var guessedLetters = Set<String>() {
        didSet {
            var result = ""
            for letter in words[answer] {
                let letter = String(letter)
                result += guessedLetters.contains(letter) ? letter : " _ "
            }
            wordLabel.text = result.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if !result.contains("_") {
                promptMessage(title: "You won!",
                    message: "The word was \(words[answer])")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Hangman game"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "New game", style: .plain, target: self,
            action: #selector(startNewGame))
        
        wordLabel = UILabel()
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(wordLabel)
        
        let lettersArea = UIView()
        lettersArea.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lettersArea)
        
        let lettersAreaWidth = view.frame.width - 20
        let lettersAreaHeight = view.frame.height * 0.2
        
        NSLayoutConstraint.activate([
            wordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wordLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor,
                                               constant: -100),
            
            lettersArea.bottomAnchor.constraint(
                equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            lettersArea.widthAnchor.constraint(
                equalToConstant: lettersAreaWidth),
            lettersArea.heightAnchor.constraint(
                equalToConstant: lettersAreaHeight),
            lettersArea.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let width = lettersAreaWidth / 13
        let height = lettersAreaHeight / 2
        
        var letterIndex = 0
        for row in 0..<2 {
            for column in 0..<13 {
                let letterButton = UIButton(type: .system)
                letterButton.setTitle(alphabet[letterIndex],
                                      for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped),
                                       for: .touchUpInside)
                letterIndex += 1
                
                let frame = CGRect(x: CGFloat(column) * width,
                                   y: CGFloat(row) * height,
                                   width: width, height: height)
                letterButton.frame = frame
                letterButton.bounds = frame.applying(CGAffineTransform(scaleX: 0.9, y: 0.9))
                
                letterButton.layer.cornerRadius = 5
                letterButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
                letterButton.layer.borderWidth = 0.5
                letterButton.layer.borderColor = UIColor.gray.cgColor
                
                lettersArea.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            if let path = Bundle.main.path(forResource: "start", ofType: "txt"),
               let contents = try? String(contentsOfFile: path) {
                let words = contents.components(separatedBy: "\n")
                DispatchQueue.main.async { [weak self] in
                    self?.words = words
                    self?.startNewGame()
                }
            }
        }
    }
    
    func promptMessage(title: String, message: String) {
        let ac = UIAlertController(title: title,
                                   message: message + "\nStart new game?",
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "OK", style: .default) { action in
            self.startNewGame()
        })
        present(ac, animated: true)
    }
    
    @objc func startNewGame() {
        answer = Int.random(in: 0..<words.count)
        let word = words[answer]
        wordLabel.text = String(repeating: "_ ", count: word.count)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        for button in letterButtons {
            button.isHidden = false
        }
        guessedLetters.removeAll()
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let letter = sender.titleLabel?.text?.lowercased() else {
            return
        }
        
        let word = words[answer]
        
        sender.isHidden = true
        if word.contains(letter) {
            guessedLetters.insert(letter)
        } else {
            wrongAnswersCount += 1
        }
    }
}

