//
//  ViewController.swift
//  instagramFireBase
//
//  Created by William Cosby on 12/15/18.
//  Copyright © 2018 William Cosby. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let plusPhotoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubView(plusPhotoButton)
        plusPhotoButton.frame = CGRect(x: 0, y: 0, width: 140, height:140)
    }


}

