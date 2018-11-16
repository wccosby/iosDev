//
//  ViewController.swift
//  AR Drawing
//
//  Created by William Cosby on 10/31/18.
//  Copyright © 2018 William Cosby. All rights reserved.
//

import UIKit
import ARKit

// inheriting from ARSCNViewDelegate will give us access to the rendering function
class ViewController: UIViewController, ARSCNViewDelegate {
    
    let arConfig = ARWorldTrackingConfiguration() // define world tracking config
    @IBOutlet weak var sceneView: ARSCNView! // define and connect the sceneView
    @IBOutlet weak var draw: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.showsStatistics = true // this will show things like FPS and other stats
        self.sceneView.session.run(arConfig)
        self.sceneView.delegate = self // needed for the renderer function
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointOfView = sceneView.pointOfView else {return} // get the camera orientation at every frame
        let transform = pointOfView.transform // returns a matrix of various values...matrix shapped as below:
        // col1 col2 orientation  location
        //  m11  m21    m31         m41
        //  m12  m22    m32         m42
        let orientation = SCNVector3(-transform.m31,-transform.m32,-transform.m33) // orientation is actually reversed so we make it negative
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let frontOfCamera = orientation + location
        // check if draw button is being pressed, if so, then draw!
        if draw.isHighlighted {
            let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
            sphereNode.position = frontOfCamera
            self.sceneView.scene.rootNode.addChildNode(sphereNode)
            sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        } else { // button not being pressed, so show a cursor
            let pointer = SCNNode(geometry: SCNSphere(radius: 0.01))
            pointer.position = frontOfCamera
            
            //need to delete all other pointers and just keep the new one
            self.sceneView.scene.rootNode.enumerateChildNodes({(node, _) in
                node.removeFromParentNode()
            })
            
            self.sceneView.scene.rootNode.addChildNode(pointer)
            pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.green
        }
        
        }
}

// modify the "+" operator so it can work on SCNVector3s
func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}
