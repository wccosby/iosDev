//
//  Promotion.swift
//  Stratus
//
//  Created by William Cosby on 1/27/19.
//  Copyright © 2019 William Cosby. All rights reserved.
//

import Foundation
import CoreLocation
import SceneKit



// TODO: consider changing this to a class to support inheritance
struct Promotion {
    let promoDescription: String
    let location: CLLocation
    var arPromoNode: SCNNode? // this will hold the virtual content. needs to be conditional because we might not immediately know what content to display even if we know where and what it is (relies on the direction of the device as to where we display it -- this is where ARWorldMap objects would come in for persistence
    
    // define more things like
    // let storeID: String
    // let promotionID: String
    // etc...
}
