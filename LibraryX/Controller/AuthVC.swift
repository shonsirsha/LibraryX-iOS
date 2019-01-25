//
//  AuthVC.swift
//  LibraryX
//
//  Created by Sean Saoirse on 22/01/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import UIKit
import Firebase
class AuthVC: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.layer.cornerRadius = 25
        loginBtn.layer.borderWidth = 0
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil{
            dismiss(animated: true, completion: nil)
        }
    }

}
