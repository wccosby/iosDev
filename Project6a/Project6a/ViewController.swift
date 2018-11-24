//
//  ViewController.swift
//  Project2
//
//  Created by William Cosby on 10/28/18.
//  Copyright © 2018 William Cosby. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    // creating holders for player score and all the countries in the game
    var countries = [String]()
    var correctAnswer = 0
    var score: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // loading the countries
        countries += ["estonia","france","germany","ireland","italy","monaco","nigeria","poland","russia","spain","uk","us"]
        
        // add a border to the buttons so we can see them well enough
        // this will make the border: 1 pixel on non-retina devices, 2 on retina, and 3 on retina HD
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor //cgColor transforms the UIColor into a format that CALayer has access to
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        // can create your own colors like this:
        // UIcolor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0).cgColor
        
        askQuestion()
    }

    func askQuestion(action: UIAlertAction! = nil) { // UIAlertAction is delcared because of the alert shown in buttonTapped function
        countries = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: countries) as! [String]
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = GKRandomSource.sharedRandom().nextInt(upperBound: 3)
        title = countries[correctAnswer].uppercased()
        
    }
    
    
    @IBAction func buttonTapped(_ sender:UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            score -= 1
        }
        
        let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
        // the handler: parameter is looking for a closure (block of code) to run when the button is clicked
        // in this situation we just want to play the game again so we call the askQuestion() function
        // note, use askQuestion instead of askQuestion() --> askQuestion says "run this now" whereas askQuestion() says "here is the
        // name of something to run
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion)) // adds button to the alert
        present(ac, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

