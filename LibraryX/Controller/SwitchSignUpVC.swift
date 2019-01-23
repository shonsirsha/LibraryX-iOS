//
//  SwitchSignUpVC.swift
//  CanteenX
//
//  Created by Sean Saoirse on 22/01/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import UIKit
var whoSigned = ""
class SwitchSignUpVC: UIViewController {

    @IBOutlet weak var studentBtn: UIButton!
    @IBOutlet weak var stallOwnerBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        studentBtn.layer.cornerRadius = 25
        studentBtn.layer.borderWidth = 0
        studentBtn.layer.borderColor = UIColor.black.cgColor
        
        stallOwnerBtn.layer.cornerRadius = 25
        stallOwnerBtn.layer.borderWidth = 0
        stallOwnerBtn.layer.borderColor = UIColor.black.cgColor
        // Do any additional setup after loading the view.
    }
  
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func stallBtn(_ sender: Any) {
        whoSigned = "stallOwner"
    }
    @IBAction func studentBtn(_ sender: Any) {
        whoSigned = "student"
    }
}
