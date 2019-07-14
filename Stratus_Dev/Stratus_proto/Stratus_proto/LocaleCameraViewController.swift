//
//  LocaleCameraViewController.swift
//  Stratus_proto
//
//  Created by William Cosby on 6/4/19.
//  Copyright © 2019 William Cosby. All rights reserved.
//

import Foundation
import UIKit
import ARKit
import SceneKit
import CoreLocation

class LocaleCameraViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    // TODO bring these in from some kind of DB
    var promoTargets = [Promotion]()
    
    let locationManager = CLLocationManager()
    var userLocation: CLLocation!
    
    // not going to mess with headings, this is going to be a more localized display
    
    // ToDo this needs to check with geolocation to find the correct promo and then load the relevant node
    var modelNode: SCNNode!
    let rootNodeName = "Car"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // just need to get their initial position
//        startReceivingLocationChanges()
        
        sceneView.delegate = self
        
        // create new scene
        let scene = SCNScene()
        
        // set the scene to the view
        sceneView.scene = scene
        
        // create the AR session config
        let configuration = ARWorldTrackingConfiguration()
        // set y-axis of device to direction of gravity as detected by the device, set x- and z- axes to the longitude and latitude as measured by location services
        configuration.worldAlignment = .gravityAndHeading
        
        // run the view's session
        sceneView.session.run(configuration)
        
        // TODO check the location
        
        // TODO render the relevant promotion
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
}

