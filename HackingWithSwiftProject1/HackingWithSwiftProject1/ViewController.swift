//
//  ViewController.swift
//  HackingWithSwiftProject1
//
//  Created by William Cosby on 10/26/18.
//  Copyright © 2018 William Cosby. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var pictures = [String]() // the parantheses tell swift to create this right now.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let fm = FileManager.default // data type that lets us work with the file system.
        let path = Bundle.main.resourcePath! // set to the resource path of the bundle --> directory containing the program and its assets
        let items = try! fm.contentsOfDirectory(atPath: path) // returns a list of the items in the contents of atPath's value
        title = "Storm Viewer"
        
        for item in items {
            if item.hasPrefix("nssl") {
                // this is a picture to load!
                pictures.append(item)
                print(pictures)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // dispose of any resources that can be recreated
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // Success! Set its selectedImage property
            vc.selectedImage = pictures[indexPath.row]
            
            // Now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

