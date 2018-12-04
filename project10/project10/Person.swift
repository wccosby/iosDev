//
//  Person.swift
//  project10
//
//  Created by William Cosby on 12/4/18.
//  Copyright © 2018 William Cosby. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    ///////////////
    // Class initializer
    ///////////////
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
