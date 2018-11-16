//
//  ViewController.swift
//  VRTest
//
//  Created by William Cosby on 10/30/18.
//  Copyright © 2018 William Cosby. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    
    @IBOutlet weak var sceneView: ARSCNView! // connecting the ARKit
    let arConfig = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // shows where the system is identifying the world origin and the feature points (how it recognizes the env)
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        sceneView.session.run(arConfig)
        sceneView.autoenablesDefaultLighting = true // puts an omni-directional light source in the scene (for reflections)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    // Add a node to the scene
    @IBAction func add(_ sender: Any) {
        
        let node_square1 = SCNNode() // node is just a position in space,positions measured in meters (0.3 = 0.3 meters)
        node_square1.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        node_square1.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        node_square1.position = SCNVector3(0.2,0,0) // add the node at the origin
        
        let node_square2 = SCNNode()
        node_square2.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        node_square2.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        node_square2.position = SCNVector3(0.3, 0.2, 0) // Add a square and then put a square 0.2 meters above it and 0.3 meters to the right
        
        self.sceneView.scene.rootNode.addChildNode(node_square1) // adding this node to the scene
        node_square1.addChildNode(node_square2) // just add as a child node, it will use node_square1 as its root
        node_square2.eulerAngles = SCNVector3(Float(45.degreesToRadians), 0, 0) // measured in radians, this will rotate the box 45deg around the X axis
        // scene  is what the camera is showing
        // root node is positioned exactly at the origin
    }
    
    // Remove a node from the scene
    @IBAction func reset(_ sender: Any) {
        // every time we reset we first have to pause the scene view
        restartSession()
    }
    
    // restart the sceneView session
    func restartSession() {
        self.sceneView.session.pause() // stops keeping track of position and orientation
        // remove the node
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        // now rerun the session
        self.sceneView.session.run(arConfig, options: [.resetTracking, .removeExistingAnchors])
        // anchors are information about the position and orientation of objects in the scene but we are
        // removing that and starting from scratch
    }
}
// extensions can be used to write more functionality into types
extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180 }
}
