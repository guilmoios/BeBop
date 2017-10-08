//
//  MainViewController.swift
//  BeBop
//
//  Created by Guilherme Mogames on 10/5/17.
//  Copyright © 2017 Mogames. All rights reserved.
//

import UIKit

@objc
class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        
        self.navigationController?.navigationBar.barTintColor = Colors.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
