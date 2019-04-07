//
//  MainTabBarController.swift
//  Stratusv2
//
//  Created by William Cosby on 4/7/19.
//  Copyright © 2019 William Cosby. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    var username: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let viewControllers = viewControllers else {
            return
        }
        
        for viewController in viewControllers {
            if let profileNavigationController = viewController as? ProfileNavigationController {
                if let profileViewController = profileNavigationController.viewControllers.first as? ProfileViewController {
                    profileViewController.username = username
                    profileViewController.password = password
                }
            }
        }
    }
}
