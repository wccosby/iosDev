//
//  MapAnnotation.swift
//  AR_Hunt
//
//  Created by William Cosby on 1/25/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
  
  // protocol requires a coordinate variable and an optional title
  let coordinate: CLLocationCoordinate2D
  let title: String?
  
  // store the ARItem that belongs to the annotation
  let item: ARItem
  
  // populate variables through the init method
  init(location: CLLocationCoordinate2D, item: ARItem) {
    self.coordinate = location
    self.item = item
    self.title = item.itemDescription
    
    super.init()
  }
}
