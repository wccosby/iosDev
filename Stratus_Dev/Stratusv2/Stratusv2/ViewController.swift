//
//  ViewController.swift
//  Stratusv2
//
//  Created by William Cosby on 4/7/19.
//  Copyright © 2019 William Cosby. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginTapped(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mainTabBarController = segue.destination as? MainTabBarController {
            mainTabBarController.username = usernameTextField.text
            mainTabBarController.password = passwordTextField.text
        }
    }
    
}

