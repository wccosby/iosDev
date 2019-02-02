//
//  ViewController.swift
//  Stratus
//
//  Created by William Cosby on 1/27/19.
//  Copyright © 2019 William Cosby. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    // set up framework for using user location:
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        
        // see if we have permission and ask if we don't
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

////////////////////////
// Extension to handle interaction
////////////////////////

extension MapViewController: MKMapViewDelegate {
    // update user location
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.userLocation = userLocation.location
    }
    
    // handle interaction on the map:
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // this is where we will launch an AR experience if they've clicked on a relevant deal
        // OR launch a view that will describe a promotion!
        
        let annotationCoordinate = view.annotation!.coordinate
        
        // open the promotion description (expose a button to go to VR mode based on proximity...how can we capture a QR code? or maybe just display a code word?
        
    }
}

