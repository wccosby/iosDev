//
//  Promotion.swift
//  Stratus_proto
//
//  Created by William Cosby on 4/7/19.
//  Copyright © 2019 William Cosby. All rights reserved.
//

import Foundation
import CoreLocation
import SceneKit

struct Promotion {
    let promoDescription: String
    let storeName: String
    let location: CLLocation
//    var arPromoNode: SCNNode? // holds virtual content...needs to be conditional because we might not immediately know what content is going to be displayed/where
    var promoSceneName: String
    var promoContentRootNodeName: String
    
}
