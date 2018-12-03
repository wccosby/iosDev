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
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        } else if navigationController?.tabBarItem.tag == 1 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=10"
        }
        
        // making this async with 2nd highest tier of QoS (userInitiated)
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            if let url = URL(string: urlString) { // check if URL is valid
                if let data = try? Data(contentsOf: url) { // returns contents of URL, might throw error if website down or missing data
                    // we're ok to parse now
                    self.parse(json: data) // have to prefix with self because we are in an enclosure now
                    return
                }
            }
        }
        // error in parsing, the return statement will not be triggered, this will be reached
        showError()
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
    
    // open the DetailViewController
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row] // can set this value since it is a parameter of the DetailViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // error to show if loading data went wrong
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please sheck your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

}

