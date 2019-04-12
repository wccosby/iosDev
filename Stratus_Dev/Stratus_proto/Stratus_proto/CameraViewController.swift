//
//  CameraViewController.swift
//  Stratus_proto
//
//  Created by William Cosby on 4/7/19.
//  Copyright © 2019 William Cosby. All rights reserved.
//

import Foundation
import UIKit
import ARKit
import SceneKit
import CoreLocation


class CameraViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    var promoTargets = [Promotion]()
    
    let locationManager = CLLocationManager()
    var userLocation: CLLocation!
    
    var heading: Double! = 0.0
    var distance : Float! = 0.0
    
    var modelNode: SCNNode!
    let rootNodeName = "Car"
    
    var originalTransform: SCNMatrix4! // may not really need this for my goal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Running View Did Load function...")
        
        startReceivingLocationChanges()
        // TODO don't really get this
        sceneView.delegate = self
        
        // create new scene
        let scene = SCNScene()
        
        // set the scene to the view
        sceneView.scene = scene
        
        // create AR session configuration
        let configuration = ARWorldTrackingConfiguration()
        // set the y-axis of device to direction of gravity as detected by device, set x- and z-axes to the longitude and latitude as measured by location services
        configuration.worldAlignment = .gravityAndHeading
        
        // run the view's session
        sceneView.session.run(configuration)

//        print("location: ", userLocation)
        
        // establish locations initially (will replace this)
        setupPromoLocations()
    }
    
    func startReceivingLocationChanges() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
            // User has not authorized this information
            return
        }
        
        if !CLLocationManager.locationServicesEnabled() {
            // location services not available
            return
        }
        
        // configure and start the service
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10.0 // in meters
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        print("Location!!!")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Implementing this method is required
        print(error.localizedDescription)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // pause the view's session
        sceneView.session.pause()
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        for promo in promoTargets {
            let promoScene = SCNScene(named: promo.promoSceneName)!
            self.modelNode = promoScene.rootNode.childNode(withName: promo.promoContentRootNodeName, recursively: true)!
            // move model's pivot to its center in the Y axis
            
            self.distance = Float(promo.location.distance(from: self.userLocation))
            print("USER LOCATION: ", userLocation as Any)
            print("DISTANCE!!! ", self.distance as Any)
            
            let (minBox, maxBox) = self.modelNode.boundingBox
            self.modelNode.pivot = SCNMatrix4MakeTranslation(0, (maxBox.y - minBox.y), 0)
            self.originalTransform = self.modelNode.transform
            
            positionModel(promo.location)
            
            sceneView.scene.rootNode.addChildNode(self.modelNode)
            print(self.modelNode as Any)
        }
    }
    
    ///////////////////////////
    // Control what happens when the locationManager updates the location
    ///////////////////////////
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation = location
            for promo in promoTargets {
                let promoScene = SCNScene(named: promo.promoSceneName)!
                self.modelNode = promoScene.rootNode.childNode(withName: promo.promoContentRootNodeName, recursively: true)!
                // move model's pivot to its center in the Y axis
                
                self.distance = Float(promo.location.distance(from: self.userLocation))
                print("USER LOCATION: ", userLocation as Any)
                print("DISTANCE!!! ", self.distance as Any)
                
                let (minBox, maxBox) = self.modelNode.boundingBox
                self.modelNode.pivot = SCNMatrix4MakeTranslation(0, (maxBox.y - minBox.y), 0)
                self.originalTransform = self.modelNode.transform
                
                positionModel(promo.location)
                
                sceneView.scene.rootNode.addChildNode(self.modelNode)
                print(self.modelNode as Any)
            }
        }
    }
    
    
    ///////////
    // this would be called if the object moves location
    // if I want to have the promotions moving somehow
    ///////////
//    func updateLocation(_ latitude : Double, _ longitude : Double) {
//        let location = CLLocation(latitude: latitude, longitude: longitude)
//        self.distance = Float(location.distance(from: self.userLocation))
//
//        for promo in promoTargets {
//            let promoScene = SCNScene(named: promo.promoSceneName)!
//            self.modelNode = promoScene.rootNode.childNode(withName: promo.promoContentRootNodeName, recursively: true)!
//            // move model's pivot to its center in the Y axis
//
//            self.distance = Float(promo.location.distance(from: self.userLocation))
//            print("USER LOCATION: ", userLocation as Any)
//            print("DISTANCE!!! ", self.distance as Any)
//
//            let (minBox, maxBox) = self.modelNode.boundingBox
//            self.modelNode.pivot = SCNMatrix4MakeTranslation(0, (maxBox.y - minBox.y), 0)
//            self.originalTransform = self.modelNode.transform
//
//            positionModel(promo.location)
//
//            sceneView.scene.rootNode.addChildNode(self.modelNode)
//            print(self.modelNode as Any)
//        }
//    }
//
    
    
    func positionModel(_ location: CLLocation) {
        // Rotate Node
        self.modelNode.transform = rotateNode(Float(-1 * (self.heading - 180).toRadians()), self.originalTransform)
        
        // Translate Node
        self.modelNode.position = translateNode(location)
        
        // Scale Node
        self.modelNode.scale = scaleNode(location)
    }
    
    func rotateNode(_ angleInRadians: Float, _ transform: SCNMatrix4) -> SCNMatrix4 {
        let rotation = SCNMatrix4MakeRotation(angleInRadians, 0, 1.5, 0)
        return SCNMatrix4Mult(transform, rotation)
    }
    
    func scaleNode(_ location: CLLocation) -> SCNVector3 {
        var scale = min( max( Float(1000/distance), 1.5), 3)
        if scale == 1.5 {
            scale = 10
        }
        return SCNVector3(x: scale, y: scale, z: scale)
    }
    
    func translateNode(_ location: CLLocation) -> SCNVector3 {
        let locationTransform = transformMatrix(matrix_identity_float4x4, userLocation, location)
        return positionFromTransform(locationTransform)
    }
    
    func positionFromTransform(_ transform: simd_float4x4) -> SCNVector3 {
        return SCNVector3Make(transform.columns.3.x, 20, transform.columns.3.z)
    }
    
    func transformMatrix(_ matrix: simd_float4x4, _ originLocation: CLLocation, _ driverLocation: CLLocation) -> simd_float4x4 {
        let bearing = bearingBetweenLocations(userLocation, driverLocation)
        let rotationMatrix = rotateAroundY(matrix_identity_float4x4, Float(bearing))
        
        let position = vector_float4(0.0, 0.0, -distance, 0.0)
        let translationMatrix = getTranslationMatrix(matrix_identity_float4x4, position)
        
        let transformMatrix = simd_mul(rotationMatrix, translationMatrix)
        
        return simd_mul(matrix, transformMatrix)
    }
    
    func getTranslationMatrix(_ matrix: simd_float4x4, _ translation : vector_float4) -> simd_float4x4 {
        var matrix = matrix
        matrix.columns.3 = translation
        return matrix
    }
    
    func rotateAroundY(_ matrix: simd_float4x4, _ degrees: Float) -> simd_float4x4 {
        var matrix = matrix
        
        matrix.columns.0.x = cos(degrees)
        matrix.columns.0.z = -sin(degrees)
        
        matrix.columns.2.x = sin(degrees)
        matrix.columns.2.z = cos(degrees)
        return matrix.inverse
    }
    
    func bearingBetweenLocations(_ originLocation: CLLocation, _ driverLocation: CLLocation) -> Double {
        let lat1 = originLocation.coordinate.latitude.toRadians()
        let lon1 = originLocation.coordinate.longitude.toRadians()
        
        let lat2 = driverLocation.coordinate.latitude.toRadians()
        let lon2 = driverLocation.coordinate.longitude.toRadians()
        
        let longitudeDiff = lon2 - lon1
        
        let y = sin(longitudeDiff) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(longitudeDiff);
        
        return atan2(y, x)
    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            userLocation = location
//        }
//        print(userLocation)
//    }
    
    func setupPromoLocations() {
        let firstPromo = Promotion(promoDescription: "Buy a car!", storeName: "This Store!", location: CLLocation(latitude: -37.810684, longitude: 144.969848), promoSceneName: "art.scnassets/Car.dae", promoContentRootNodeName: "Car")
        
        let secondPromo = Promotion(promoDescription: "Home!", storeName: "This is your home!", location: CLLocation(latitude: -37.816088, longitude: 144.989206), promoSceneName: "art.scnassets/Car.dae", promoContentRootNodeName: "Car")
        
        promoTargets.append(firstPromo)
        promoTargets.append(secondPromo)
    }
    
    
}


