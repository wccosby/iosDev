//
//  Petition.swift
//  Project7
//
//  Created by William Cosby on 11/24/18.
//  Copyright © 2018 William Cosby. All rights reserved.
//

import Foundation

// structs give us a memberwise initializer for free, makes it very easy to work with

// the Petition struct holds the actual data we are interested in
struct Petition: Codable { // inheriting from codable so that it will work for JSON
    var title: String
    var body: String
    var signatureCount: Int
}

// the Petitions struct is what we use to reference the "results" field of the JSON that holds the array of the data we are interested in
struct Petitions: Codable {
    var results: [Petition]
}

