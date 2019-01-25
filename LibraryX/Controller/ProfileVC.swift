//
//  ProfileVC.swift
//  LibraryX
//
//  Created by Sean Saoirse on 23/01/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import UIKit
import Firebase
class ProfileVC: UIViewController {

    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var editProfileBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        editProfileBtn.layer.cornerRadius = 8
        fullNameLabel.text = "Loading..."
        emailLabel.text = "Loading..."
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DataService.instance.getFullName(uid: (Auth.auth().currentUser?.uid)!) { (returnedFullName) in
            self.fullNameLabel.text = returnedFullName
        }
        DataService.instance.getEmail(uid: (Auth.auth().currentUser?.uid)!) { (returnedEmail) in
            self.emailLabel.text = returnedEmail
        }
        
       
    }

    @IBAction func logoutBtn(_ sender: Any) {
        
       let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action:UIAlertAction) in
            print("No")
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action:UIAlertAction) in
            do{
                try Auth.auth().signOut()
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
                self.present(loginVC!, animated: true, completion: nil)
            }catch{
                print(error)
            }        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

