//
//  ViewController.swift
//  AR Measuring
//
//  Created by William Cosby on 7/14/19.
//  Copyright © 2019 William Cosby. All rights reserved.
//

import UIKit
import ARKit

// inheriting from ARSCNViewDelegate lets us access functions like renderer update at time
class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var zlabel: UILabel!
    @IBOutlet weak var ylabel: UILabel!
    @IBOutlet weak var xlabel: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    @IBOutlet weak var sceneView: ARSCNView!
    var startingPosition: SCNNode?
    
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.session.run(configuration)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        self.sceneView.delegate = self // need this to get the renderer function to be triggered
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        guard let sceneView = sender.view as? ARSCNView else {return}
        // get the current frame --> the frame that was just rendered, can get the camera property from here
        guard let currentFrame = sceneView.session.currentFrame else {return}
        // if I tap and there is already a starting positon then remove it and restart
        if self.startingPosition != nil {
            self.startingPosition?.removeFromParentNode()
            self.startingPosition = nil
            return
        }
        
        // camera property gives us all of the info about orientation, location, heading etc...
        let camera = currentFrame.camera
        let transform = camera.transform
        print(transform)
        let sphere = SCNNode(geometry: SCNSphere(radius: 0.005))
        sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
        // set the sphere transform to exactly where the camera is --> experiment with changing to positon relative to the current frame
        var translationMatrix = matrix_identity_float4x4 // linearly indpendent (all 1)
        translationMatrix.columns.3.z = -0.1
        let modifiedMatrix = simd_mul(transform, translationMatrix) // everything will get multiplied by 1 except for the value of the 3rd column (location) z axis --> will get added
        sphere.simdTransform = modifiedMatrix
        self.sceneView.scene.rootNode.addChildNode(sphere)
        self.startingPosition = sphere
        
    }
    
    // called with every frame, if running at 60 fps, this gets triggered 60x per second
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let startingPosition = self.startingPosition else {return}
        // get point of view of scene view
        guard let pointOfView = self.sceneView.pointOfView else {return}
        let transform = pointOfView.transform
        // location information is in the 4th column, row 1 = x, row 2 = y, row 3 = z
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let xDistance = location.x - startingPosition.position.x
        let yDistance = location.y - startingPosition.position.y
        let zDistance = location.z - startingPosition.position.z
        DispatchQueue.main.async {
            self.xlabel.text = String(format: "%.2f", xDistance) + "m"
            self.ylabel.text = String(format: "%.2f", yDistance) + "m"
            self.zlabel.text = String(format: "%.2f", zDistance) + "m"
            self.distance.text = String(format: "%.2f", self.distanceTravelled(x: xDistance, y: yDistance, z: zDistance)) + "m"
        }
    }
    
    // calculate total diagnoal distance moved
    func distanceTravelled(x: Float, y: Float, z: Float) -> Float {
        return (sqrtf(x*x + y*y + z*z))
    }
    
}

