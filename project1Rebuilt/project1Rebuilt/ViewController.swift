//
//  ViewController.swift
//  project1Rebuilt
//
//  Created by William Cosby on 10/27/18.
//  Copyright © 2018 William Cosby. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]() // declare it now
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        title = "Storm Viewer"
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
                
            }
        }
        print(pictures)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
}

