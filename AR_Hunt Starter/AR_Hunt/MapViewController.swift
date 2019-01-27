/*
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

  @IBOutlet weak var mapView: MKMapView!
  
  var targets = [ARItem]() // save the AR targets
  
  // load the manager that will give us permission to use location
  let locationManager = CLLocationManager()
  
  // track user location
  var userLocation: CLLocation?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
    
    setupLocations() // create and add the annotations
    
    // see if we have permission to use location and ask if we don't
    if CLLocationManager.authorizationStatus() == .notDetermined {
      locationManager.requestWhenInUseAuthorization()
    }
  }
  
  func setupLocations() {
    // hard code some initial examples
    // TODO: move this to server based database
    let firstTarget = ARItem(itemDescription: "wolf", location:CLLocation(latitude: -37.814738, longitude: 144.968624), itemNode: nil)
    targets.append(firstTarget)
    
    let secondTarget = ARItem(itemDescription: "dragon", location: CLLocation(latitude: -37.815882, longitude: 144.964150), itemNode: nil)
    targets.append(secondTarget)
    
    let thirdTarget = ARItem(itemDescription: "wolf", location: CLLocation(latitude: -37.811916, longitude: 144.967927), itemNode: nil)
    targets.append(thirdTarget)
    
    let fourthTarget = ARItem(itemDescription: "dragon", location: CLLocation(latitude: -37.814577, longitude: 144.967927), itemNode: nil)
    targets.append(fourthTarget)
    
    for item in targets {
      let annotation = MapAnnotation(location: item.location.coordinate, item: item)
      self.mapView.addAnnotation(annotation)
    }
    
  }
  
}


extension MapViewController: MKMapViewDelegate {
  
  // update user location
  func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
    self.userLocation = userLocation.location
  }
  
  // control what happens when a user clicks on the map
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    // get the coordinate of the selected annotation (could also get an id or some promotion indicator
    let coordinate = view.annotation!.coordinate
    
    // make sure the optional userLocation is populated
    if let userCoordinate = userLocation {
      
      // make sure the tapped item is within range of the user's location
      if userCoordinate.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) < 50 {
        
        // instantiate an instance of ARViewController (here it is called "Main") from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let viewController = storyboard.instantiateViewController(withIdentifier: "ARViewController") as? ViewController {
          
          // check if the tapped annotation is a MapAnnotation
          if let mapAnnotation = view.annotation as? MapAnnotation {
            
            viewController.target = mapAnnotation.item // passing the ARItem to the view controller logic
            
            // pass user's location to viewController
            viewController.userLocation = mapView.userLocation.location!
            
            // present the viewController for the ARViewController frame
            self.present(viewController, animated: true, completion: nil)
          }
        }
      }
    }
  }
}

