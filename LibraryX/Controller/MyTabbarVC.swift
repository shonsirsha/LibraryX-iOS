//
//  MyTabbarVC.swift
//  LibraryX
//
//  Created by Sean Saoirse on 05/02/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import UIKit

class MyTabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 0
        
        #if Client
        
        #else
            viewControllers?.remove(at: 2)
        #endif
    }

    

}
