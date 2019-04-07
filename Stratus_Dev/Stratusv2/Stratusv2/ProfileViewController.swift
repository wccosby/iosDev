//
//  ProfileViewController.swift
//  Stratusv2
//
//  Created by William Cosby on 4/7/19.
//  Copyright © 2019 William Cosby. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    var username: String?
    var password: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = username
        passwordLabel.text = password
    }
    
    
    @IBAction func logout(_ sender: Any) {
        dismiss(animated: true, completion: nil) // dismiss every view and take us back to the initial view
        
    }
    
    
}
