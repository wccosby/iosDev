//
//  ViewController.swift
//  Project8
//
//  Created by TwoStraws on 15/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import GameplayKit
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cluesLabel: UILabel!
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var currentAnswer: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    var level = 1
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    /////////////////
    // view loaded
    /////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // programmatically load and attach targets and actions to the letterButtons
        for subview in view.subviews where subview.tag == 1001 {
            let btn = subview as! UIButton
            letterButtons.append(btn)
            btn.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            // when letterTapped is called, the button will be sent as a parameter into the function
        }
        loadLevel()
    }
    
    /////////////////
    // Load the level
    /////////////////
    func loadLevel() {
        var clueString = "" // what the clue will say
        var solutionString = "" // hint of how many letters are in the solution --> 7 letters (if answer = haunted)
        var letterBits = [String]() // list of the individual bits of the letters --> HA|UNT|ED --> [HA, UNT, ED]
        
        if let levelFilePath = Bundle.main.path(forResource: "level\(level)", ofType: "txt") { // check to see if path exists (level defined globally initially)
            if let levelContents = try? String(contentsOfFile: levelFilePath) { // check to see if we can read the contents
                var lines = levelContents.components(separatedBy: "\n") // get a list of the lines in the file, separated by "\n"
                lines.shuffle()
                
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ") // specfics of how our data is stored
                    let answer = parts[0] // grab the answer from the input data
                    let clue = parts[1] // grab the clue from the input data
                    clueString += "\(index + 1). \(clue)\n" // construct the clue string
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "") // remove the | from the solution word
                    solutionString += "\(solutionWord.count) letters\n" // give the solution hint (# of letters)
                    solutions.append(solutionWord) // add the solution word to the list of solutions
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        
        // configure the buttons and labels
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        letterBits.shuffle()
        if letterBits.count == letterButtons.count {
            for i in 0 ..< letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }

    
    /////////////////
    // takes a button as an argument
    /////////////////
    @objc func letterTapped(btn: UIButton) {
        currentAnswer.text = currentAnswer.text! + btn.titleLabel!.text!
        activatedButtons.append(btn)
        btn.isHidden = true
    }
    
    /////////////////
    // triggered when submit button clicked
    /////////////////
    @IBAction func submitTapped(_ sender: Any) {
        // check if their solution is in the answers
        if let solutionPosition = solutions.index(of: currentAnswer.text!) {
            activatedButtons.removeAll()
            var splitAnswers = answersLabel.text!.components(separatedBy: "\n")
            splitAnswers[solutionPosition] = currentAnswer.text!
            answersLabel.text = splitAnswers.joined(separator: "\n")
            currentAnswer.text = ""
            score += 1
            if (score % 7 == 0) && (score >= 0) {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        } else {
            score -= 1
            let ac = UIAlertController(title: "Oh no!", message: "That isn't a correct answer! Your score is now \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "try again!", style: .default))
            present(ac, animated: true)
            
            // reset the buttons
            currentAnswer.text = ""
            for btn in activatedButtons {
                btn.isHidden = false
            }
            activatedButtons.removeAll()
        }
    }
    
    /////////////////
    // triggered when clear button clicked
    /////////////////
    @IBAction func clearTapped(_ sender: Any) {
        currentAnswer.text = ""
        for btn in activatedButtons {
            btn.isHidden = false
        }
        activatedButtons.removeAll()
    }
    
    /////////////////
    // Level up (skeleton code)
    /////////////////
    func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)
        loadLevel()
        for btn in letterButtons {
            btn.isHidden = false
        }
    }
    
    
    /////////////////
    // Memory warning
    /////////////////
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


    
}
