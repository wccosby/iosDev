//
//  ViewController.swift
//  HackingWithSwiftProject1
//
//  Created by William Cosby on 10/26/18.
//  Copyright © 2018 William Cosby. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var pictures = [String]() // the parantheses tell swift to create this right now.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let fm = FileManager.default // data type that lets us work with the file system.
        let path = Bundle.main.resourcePath! // set to the resource path of the bundle --> directory containing the program and its assets
        let items = try! fm.contentsOfDirectory(atPath: path) // returns a list of the items in the contents of atPath's value
        
        for item in items {
            if item.hasPrefix("nssl") {
                // this is a picture to load!
                pictures.append(item)
                print(pictures)
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // dispose of any resources that can be recreated
    }
}

