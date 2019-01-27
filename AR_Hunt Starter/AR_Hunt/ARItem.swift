//
//  ARItem.swift
//  AR_Hunt
//
//  Created by William Cosby on 1/25/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation
import CoreLocation
import SceneKit

struct ARItem {
  let itemDescription: String
  let location: CLLocation
  
  var itemNode: SCNNode? // this will hold the virtual content. needs to be conditional because we might not immediately know what content to display even if we know where and what it is (relies on the direction of the device as to where we display it -- this is where ARWorldMap objects would come in for persistence
  
  // define more things like
  // let storeID: String
  // let promotionID: String
  // etc...
}
