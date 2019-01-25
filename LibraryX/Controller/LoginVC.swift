//
//  LoginVC.swift
//  LibraryX
//
//  Created by Sean Saoirse on 22/01/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import UIKit
import Firebase


class LoginVC: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loginBtn.layer.cornerRadius = 0
        loginBtn.layer.borderColor = #colorLiteral(red: 0, green: 0.5899932384, blue: 0.9993053079, alpha: 1)
        loginBtn.layer.borderWidth = 1
        loginBtn.backgroundColor = UIColor.clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil{
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        statusLabel.text = "Signing in..."
        AuthService.instance.loginUser(email: emailField.text!, password: passwordField.text!) { (success, loginErr) in
            if success{
                self.dismiss(animated: true, completion: nil)
            }else{
                
                self.statusLabel.text = "Invalid sign in credentials. Please try again."
            }
        }
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
}
