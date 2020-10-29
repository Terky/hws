//
//  ViewController.swift
//  Project 2
//
//  Created by Артём Бурмистров on 2/12/20.
//  Copyright © 2020 Артём Бурмистров. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var firstFlag: UIButton!
    @IBOutlet var secondFlag: UIButton!
    @IBOutlet var thirdFlag: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    
    var questionsCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureButton(button: firstFlag)
        configureButton(button: secondFlag)
        configureButton(button: thirdFlag)
        
        countries += [
            "estonia", "france", "germany", "ireland", "italy", "monaco",
            "nigeria", "poland", "russia", "spain", "uk", "us"
        ]
        
        askQuestion()
    }
    
    func configureButton(button: UIButton) {
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.lightGray.cgColor
    }

    @IBAction func flagPressed(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong! That's the flag of \(countries[sender.tag].uppercased())"
            score -= 1
        }
        
        if questionsCount == 10 {
            title = "Game finished"
        }
        
        let alert = UIAlertController(
            title: title,
            message: "Your score is \(score)",
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: "Continue",
                style: .default,
                handler: { _ in
                    if self.questionsCount == 10 {
                        self.questionsCount = 0
                        self.score = 0
                    }
                    self.askQuestion()
                }
            )
        )
        present(alert, animated: true)
    }
    
    func askQuestion() {
        questionsCount += 1
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        firstFlag.setImage(UIImage(named: countries[0]), for: .normal)
        secondFlag.setImage(UIImage(named: countries[1]), for: .normal)
        thirdFlag.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = "Choose \(countries[correctAnswer].uppercased()), Score: \(score)"
    }
}

