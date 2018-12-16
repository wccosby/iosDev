//
//  ViewController.swift
//  Project19
//
//  Created by William Cosby on 12/15/18.
//  Copyright © 2018 William Cosby. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var cities: [Capital]
        // load some cities
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics")
        let oslo = Capital(title: "Oslo", coordinate:
            CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75),
                           info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate:
            CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508),
                            info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate:
            CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info:
            "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate:
            CLLocationCoordinate2D(latitude: 38.895111, longitude:
                -77.036667), info: "Named after George himself.")
        
        cities = [london, oslo, paris, rome, washington]
        
        // add them to the map
        for city in cities {
            mapView.addAnnotation(city)
        }
        
    }
    
    ////////////////
    // adding extra information and interaction to the pins on the map
    ////////////////
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Capital" // defining a reuse identifier
        if annotation is Capital {
            // get one of the annotationViews if it exists
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            // if the view doesn't already exist then we need to build it
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                let btn = UIButton(type: .detailDisclosure)
                annotationView!.rightCalloutAccessoryView = btn
            } else {
                annotationView!.annotation = annotation
            }
            return annotationView
        }
        return nil // if the annotation is not our custom Capital then do the default action
    }
    
    ////////////////
    // defining how our extra information will be displayed
    ////////////////
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let capital = view.annotation as! Capital
        let placeName = capital.title
        let placeInfo = capital.info
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default)) // just dismissing the extra info
        present(ac, animated: true)
    }


}

