//
//  ViewController.swift
//  Project13
//
//  Created by William Cosby on 12/12/18.
//  Copyright © 2018 William Cosby. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var intensity: UISlider!
    var currentImage: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // getting ready to let the user add an image:
        title = "InstaFilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
    }
    
    
    @objc func importPicture() {
    
    }

    @IBAction func changeFilter(_ sender: Any) {
        
    }
    
    @IBAction func save(_ sender: Any) {
        
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
        
    }
    
}

