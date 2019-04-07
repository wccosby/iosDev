//
//  CustomTabBarController.swift
//  Stratus_customNav
//
//  Created by William Cosby on 4/7/19.
//  Copyright © 2019 William Cosby. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    var mapViewController: MapViewController!
    var cameraViewController: CameraViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        mapViewController = MapViewController()
        cameraViewController = CameraViewController()
        
        viewControllers = [mapViewController, cameraViewController]
    }
    
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if viewController.isKind(of: <#T##AnyClass#>) {
//
//        }
//    }
}
