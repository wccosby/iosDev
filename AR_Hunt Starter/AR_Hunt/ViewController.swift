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
import SceneKit
import AVFoundation
import CoreLocation

class ViewController: UIViewController {
  
  @IBOutlet weak var sceneView: SCNView!
  @IBOutlet weak var leftIndicator: UILabel!
  @IBOutlet weak var rightIndicator: UILabel!
  
  
  // camera/AR related vars
  var cameraSession: AVCaptureSession?
  var cameraLayer: AVCaptureVideoPreviewLayer?
  
  // AR content
  var target: ARItem! // we know there will be an ARItem present
  
  // Camera direction variables:
  // You use a CLLocationManager to receive the heading the device is looking. Heading is measured in degrees from either true north or the magnetic north pole
  var locationManager = CLLocationManager()
  var heading: Double = 0
  var userLocation = CLLocation()
  // create an empty SCNScene and Node
  let scene = SCNScene()
  let cameraNode = SCNNode()
  let targetNode = SCNNode(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)) // creates a cube
  

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    loadCamera() // trigger all of the stuff
    self.cameraSession?.startRunning()
    
    // set the view controller as the delegate for CLLocationManager
    self.locationManager.delegate = self // allowed through extension at bottom of script
    
    // after this we'll have the heading of the phone, this is updated for changes > 1 degree
    self.locationManager.startUpdatingHeading()
    
    // set up for SCNScene -- creates an empty scene and adds a camera
    sceneView.scene = scene
    cameraNode.camera = SCNCamera()
    cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
    scene.rootNode.addChildNode(cameraNode)
    setupTarget() // give targetNode a name and assign it to the target
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func createCaptureSession() -> (session: AVCaptureSession?, error: NSError?) {
    // create some variables for the return value of the method
    var error: NSError?
    var captureSession: AVCaptureSession?
    
    // get the rear camera of the device
    let backVideoDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)
    
    // if the camera exists, get its input
    if backVideoDevice != nil {
      var videoInput: AVCaptureDeviceInput!
      do {
        videoInput = try AVCaptureDeviceInput(device: backVideoDevice)
      } catch let error1 as NSError {
        error = error1
        videoInput = nil
      }
      
      // create an instance of AVCaptureSession
      if error == nil {
        captureSession = AVCaptureSession()
        
        // add the video device as an input
        if captureSession!.canAddInput(videoInput) {
          captureSession!.addInput(videoInput)
        } else {
          error = NSError(domain: "", code: 0, userInfo: ["description":"Error adding video input."])
        }
      } else {
        error = NSError(domain: "", code: 1, userInfo: ["description": "Error creating capture device input."])
      }
    } else {
      error = NSError(domain: "", code: 2, userInfo: ["description": "Back video device not found."])
    }
    
    // return a tuple that contains either the captureSession or an error
    return (session: captureSession, error: error)
  }
  
  
  func loadCamera() {
    // call the method to get the capture session
    let captureSessionResult = createCaptureSession()
    
    // if there was an error or captureSession is nil, you return...no AR for you today
    guard captureSessionResult.error == nil, let session = captureSessionResult.session else {
      print("Error creating capture session.")
      return
    }
    
    // store capture session in cameraSession
    self.cameraSession = session
    
    // tries to create a video preview layer, if successful it sets videoGravity and sets the frame of the layer to the view bounds...this gives fullscreen preview
    if let cameraLayer = AVCaptureVideoPreviewLayer(session: self.cameraSession) {
      cameraLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
      cameraLayer.frame = self.view.bounds
      
      // add the layer as a sublayer and store it in cameraLayer
      self.view.layer.insertSublayer(cameraLayer, at: 0)
      self.cameraLayer = cameraLayer
    }
  }
  
  
  // Reposition the AR Target as the heading changes
  func repositionTarget() {
    // calculation the heading from the current location to the target
    // target is ARItem type
    let heading = getHeadingForDirectionFromCoordinate(from: userLocation, to: target.location)
    
    // calculate a delta value of the device’s current heading and the location’s heading. If the delta is less than -15, display the left indicator label. If it is greater than 15, display the right indicator label. If it’s between -15 and 15, hide both as the the enemy should be onscreen.
    let delta = heading - self.heading
    
    if delta < -15.0 {
      leftIndicatorOn()
    } else if delta > 15 {
      rightIndicatorOn()
    } else {
      bothIndicatorOff()
    }
    
    // get distance from device to the enemy
    let distance = userLocation.distance(from: target.location)
    
    // if the item has a node assigned (if it has content basically)
    if let node = target.itemNode  { // target is ARItem type
      // if node has no parent set the position using the distance and add to the scene, else clear all actions
      if node.parent == nil {
        node.position = SCNVector3(x: Float(delta), y: 0, z: Float(-distance))
        scene.rootNode.addChildNode(node)
      } else {
        node.removeAllActions()
        node.runAction(SCNAction.move(to: SCNVector3(x: Float(delta), y: 0, z: Float(-distance)), duration: 0.2)) // ??
      }
    }
  }
  
  func setupTarget() {
    targetNode.name = "enemy"
    self.target.itemNode = targetNode
  }
  
  ////////////////
  // Auxiliary functions
  ////////////////
  
  func leftIndicatorOn() {
    leftIndicator.isHidden = false
    rightIndicator.isHidden = true
  }
  
  func rightIndicatorOn() {
    leftIndicator.isHidden = true
    rightIndicator.isHidden = false
  }
  
  func bothIndicatorOff() {
    leftIndicator.isHidden = true
    rightIndicator.isHidden = true
  }
  
  func radiansToDegrees(_ radians: Double) -> Double {
    return (radians) * (180.0 / Double.pi)
  }
  
  func degreesToRadians(_ degrees: Double) -> Double {
    return (degrees) * (Double.pi / 180.0)
  }
  
  func getHeadingForDirectionFromCoordinate(from: CLLocation, to: CLLocation) -> Double {
    // convert all values for latitude and longitude into radians
    let fLat = degreesToRadians(from.coordinate.latitude)
    let fLng = degreesToRadians(from.coordinate.longitude)
    let tLat = degreesToRadians(to.coordinate.latitude)
    let tLng = degreesToRadians(to.coordinate.longitude)
    
    // calculate heading and convert it back to degrees
    let degree = radiansToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)))
    
    // if negative, normalize it by adding 360 degrees (-90 degrees == 270 degrees)
    if degree >= 0 {
      return degree
    } else {
      return degree + 360
    }
  }

}


// have viewController adopt the CLLocationManagerDelegate protocol
extension ViewController: CLLocationManagerDelegate {
  func locationManager(_manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)  {
    self.heading = fmod(newHeading.trueHeading, 360.0) // fmod is the modulo operator
    repositionTarget()
  }
}
