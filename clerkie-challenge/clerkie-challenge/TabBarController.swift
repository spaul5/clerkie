//
//  TabBarController.swift
//  clerkie-challenge
//
//  Created by Shouvik Paul on 11/9/18.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        Utilities.shared.tabBarRef = self
    }
}
