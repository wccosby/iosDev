//
//  ViewController.swift
//  Project2Rebuild
//
//  Created by William Cosby on 10/28/18.
//  Copyright © 2018 William Cosby. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {
    
    var countries = [String]()
    var score: Int = 0
    var correctAnswer: Int = 0

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // populate our list of answers:
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        // style the buttons
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        // call the method to start the game
        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: countries) as! [String]
        
        button1.setImage(UIImage(named: countries[0]), for: .normal) // need to specify the state of the button as well
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = GKRandomSource.sharedRandom().nextInt(upperBound: 3)
        title = countries[correctAnswer].uppercased()
        
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            score -= 1
        }
        
        // call a prompt to tell users how they did
        let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

