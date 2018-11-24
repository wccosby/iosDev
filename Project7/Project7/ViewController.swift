//
//  ViewController.swift
//  Project7
//
//  Created by William Cosby on 11/24/18.
//  Copyright © 2018 William Cosby. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        
        if let url = URL(string: urlString) { // check if URL is valid
            if let data = try? Data(contentsOf: url) { // returns content of URL, might throw an error (like if it couldn't connect to the url or data isn't there)
                // we're OK to parse!
                parse(json: data)
            }
        }
        
    }
    
    // define the number of rows to give the tableViewController
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    // define what is in the cell in a certain row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row] // get a reference to the petition in location indexPath.row
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    // Parse the incoming JSON data
    func parse(json: Data)  {
        let decoder = JSONDecoder() // dedicated to converting json to codable objects
        
        // Petitions.self is swift's way of referring to the Petitions type itself, not an instance of it
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData() // reload the whole table (could make this fancy by checking what's new and then reloading just the first N elements
        }
    }


}

