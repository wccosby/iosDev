//
//  MapAnnotation.swift
//  Stratus_proto
//
//  Created by William Cosby on 4/7/19.
//  Copyright © 2019 William Cosby. All rights reserved.
//

import Foundation
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    
    // later for storing the ARContent
    let arPromoContent: Promotion
    
    init(location: CLLocationCoordinate2D, content: Promotion) {
        self.coordinate = location
        self.arPromoContent = content
        self.title = content.storeName
        
        super.init()
    }
    
}
