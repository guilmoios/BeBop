//
//  MainTabBarController.swift
//  BeBop
//
//  Created by Guilherme Mogames on 10/4/17.
//  Copyright © 2017 Mogames. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupIcons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupIcons() {
        
        if tabBar.items != nil {
            for item in tabBar.items! {
                item.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
            }
        }
    }
    
}
