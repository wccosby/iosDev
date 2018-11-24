//
//  ViewController.swift
//  Project5
//
//  Created by William Cosby on 11/16/18.
//  Copyright © 2018 William Cosby. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // setup the alert controller that will ask for an input
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        // read the contents of the word file into our list
        // note that Bundle.main.path(forResource) returns a type String? which means we have to unwrap it
        if let startWordsPath = Bundle.main.path(forResource: "start", ofType: "txt") {
            if let startWords = try? String(contentsOfFile: startWordsPath) {
                allWords = startWords.components(separatedBy: "\n")
            } else {
                allWords = ["silkworm"]
            }
        }
//        print("\(allWords)")
        
        startGame()
    }
    
    func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    // controlling the rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row] // get the word that is in the row number index
        return cell
    }
    

    @objc func promptForAnswer() {
        // get reference to the alert controller
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned self, ac] (action: UIAlertAction) in // everything after this is actually IN the closure
                let answer = ac.textFields![0]
                self.submit(answer: answer.text!) // have to use "self" here because submit() is written outside the closure, calling it means self must be captured by the closure
          }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    

    func submit(answer: String) {
        let lowerAnswer = answer.lowercased()
        
        let errorTitle: String
        let errorMessage: String
        
        // check if the word is correct:
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0) // push onto the stack (takes the first position in the list)
                    
                    // this is for animation, we could reloadData() but that would reload all of the data for the whole view
                    // which would be very wasteful...this will force load just the newest word without having to reload the whole list
                    let indexPath = IndexPath(row: 0, section: 0) // add the row to the tableView
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    return // exit the function
                } else {
                    errorTitle = "Word not recognised"
                    errorMessage = "You can't just make them up, you know!"
                }
            } else {
                errorTitle = "Word used already"
                errorMessage = "Be more original!"
            }
        } else {
            errorTitle = "Word not possible"
            errorMessage = "You can't spell that word from '\(title!.lowercased())'"
        }
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        
    }
    
    // Checks for Correctness --> need 3
    
    // is it possible to create that string with the characters in the target word?
    func isPossible(word: String) -> Bool {
        var tempWord = title!.lowercased()
        
        for letter in word { // letter here will be a Character type
            if let pos = tempWord.range(of: String(letter)) { // range(of:...) returns an optional position of where the item was found
                tempWord.remove(at: pos.lowerBound)
                print("Position of the word: \(pos)")
            } else {
                return false
            }
        }
        return true
    }
    
    // has the player used that word already?
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word) // return false if usedWords contains word
    }
    
    // is the word an actual word?
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSMakeRange(0, word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
}

