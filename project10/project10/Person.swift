//
//  Person.swift
//  project10
//
//  Created by William Cosby on 12/4/18.
//  Copyright © 2018 William Cosby. All rights reserved.
//

import UIKit

class Person: NSObject, NSCoding {
    var name: String
    var image: String
    
    ///////////////
    // Class initializer
    ///////////////
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    ////////////////
    // Code required for using NSCoding
    ////////////////
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        image = aDecoder.decodeObject(forKey: "image") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
    }
    
    
  
}
