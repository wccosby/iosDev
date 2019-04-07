//
//  MapViewController.swift
//  Stratus_proto
//
//  Created by William Cosby on 4/7/19.
//  Copyright © 2019 William Cosby. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    
    var promoTargets = [Promotion]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // map stuff
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        
        // see if we have permission and ask if we don't
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        print(userLocation as Any)
        setupPromoLocations()
    }
    
    
    
    
    func setupPromoLocations() {
        let firstPromo = Promotion(promoDescription: "Buy a car!", storeName: "This Store!", location: CLLocation(latitude: -37.814738, longitude: 144.968624), promoSceneName: "art.scnassets/Car.dae", promoContentRootNodeName: "Car")
        
        promoTargets.append(firstPromo)
        
        
        for promo in promoTargets {
            let annotation = MapAnnotation(location: promo.location.coordinate, content: promo)
            self.mapView.addAnnotation(annotation)
        }
        
    }
}


/////////////////////
// Extension to handle interaction
/////////////////////
//extension MapViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        self.userLocation = userLocation.location
//    }
//}

