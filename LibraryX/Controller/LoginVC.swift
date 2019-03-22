//
//  LoginVC.swift
//  LibraryX
//
//  Created by Sean Saoirse on 22/01/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation


class LoginVC: UIViewController {

    @IBOutlet weak var emailValulu: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
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
        emailValulu.resignFirstResponder()
        passwordField.resignFirstResponder()
        statusLabel.text = "Signing in..."
        AuthService.instance.loginUser(email: emailValulu.text!, password: passwordField.text!) { (success, loginErr) in
            if success{
                //self.playSound(sound: "scansound")
                self.dismiss(animated: true, completion: nil)
            }else{
                //self.playSound(sound: "fail")
                self.statusLabel.text = "Invalid sign in credentials. Please try again."
            }
        }
    }
    

    @IBAction func signInWithDiffMethod(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func playSound(sound: String) {
        guard let url = Bundle.main.url(forResource: sound, withExtension: "wav") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailValulu.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
}
