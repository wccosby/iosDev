//
//  ViewController.swift
//  AR Portal
//
//  Created by William Cosby on 7/14/19.
//  Copyright © 2019 William Cosby. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    @IBOutlet weak var planeDetected: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration)
        
        self.sceneView.delegate = self // register the delegate so that the renderer functions can get called
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // if we discover a plane surface in real world then unhide the label
        guard anchor is ARPlaneAnchor else {return}
        // make this happen on the main thread because its going to be affecting the UI
        DispatchQueue.main.async {
            self.planeDetected.isHidden = false
        }
        // re-hide the text after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.planeDetected.isHidden = true
        }
    }
    
    // recognize when a user taps on a horizontal surface
    @objc func handleTap(sender: UITapGestureRecognizer) {
        guard let sceneView = sender.view as? ARSCNView else {return}
        let touchLocation = sender.location(in: sceneView)
        // now do a hit test to see if the user tapped on a horizontal surface
        let hitTestResult = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        if !hitTestResult.isEmpty {
            // we're going to add our room exactly where this tap was if there is a result for hitTest
            self.addPortal(hitTestResult: hitTestResult.first!) // this is a list
        } else {
            // just continue on...nothing should happen
        }
    }
    
    func addPortal(hitTestResult: ARHitTestResult) {
        // load the scene
        let portalScene = SCNScene(named: "Portal.scnassets/Portal.scn")
        // load the node
        let portalNode = portalScene!.rootNode.childNode(withName: "Portal", recursively: false)!
        
        // put it right where the user tapped
        let transform = hitTestResult.worldTransform // encodes the postion of our plane
        let planeXPosition = transform.columns.3.x
        let planeYPosition = transform.columns.3.y
        let planeZPosition = transform.columns.3.z
        
        portalNode.position = SCNVector3(planeXPosition, planeYPosition, planeZPosition)
        self.sceneView.scene.rootNode.addChildNode(portalNode)
        
        // add each part of the cubemap
        self.addPlane(nodeName: "roof", portalNode: portalNode, imageName: "top")
        self.addPlane(nodeName: "floor", portalNode: portalNode, imageName: "bottom")
        
        self.addWalls(nodeName: "backWall", portalNode: portalNode, imageName: "back")
        self.addWalls(nodeName: "sideWallA", portalNode: portalNode, imageName: "sideA")
        self.addWalls(nodeName: "sideWallB", portalNode: portalNode, imageName: "sideB")
        self.addWalls(nodeName: "sideDoorA", portalNode: portalNode, imageName: "sideDoorA")
        self.addWalls(nodeName: "sideDoorB", portalNode: portalNode, imageName: "sideDoorB")
        
    }
    
    func addPlane(nodeName: String, portalNode: SCNNode, imageName: String) {
        let child = portalNode.childNode(withName: nodeName, recursively: true) // we want to check the entire subtree of the portal node
        child?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Portal.scnassets/\(imageName)")
        child?.renderingOrder = 200
    }
    
    func addWalls(nodeName: String, portalNode: SCNNode, imageName: String) {
        let child = portalNode.childNode(withName: nodeName, recursively: true) // we want to check the entire subtree of the portal node
        child?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Portal.scnassets/\(imageName)")
        // make the walls translucent
        // make it so the mask renders first by making the rendering order of the walls much higher
        // if a translucent object is rendered first and in front of an opaque object, the colors are mixed, since the mask is extremely translucent the mix on the opaque walls will be extremely translucent as well.
        child?.renderingOrder = 200
        if let mask = child?.childNode(withName: "mask", recursively: true) {
            mask.geometry?.firstMaterial?.transparency = 0.00001
        }
    }

}

