//
//  ReportEbookVC.swift
//  libraryX
//
//  Created by Sean Saoirse on 28/02/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import UIKit
import Firebase
class ReportEbookVC: UIViewController {
    var imgTitleInMS: Double = 0
    var fullName = ""
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if imgTitleInMS != 0{
            DataService.instance.getFullName(uid: (Auth.auth().currentUser?.uid)!) { (returnedFullname) in
                self.fullName = returnedFullname
                
                
            }
            
            
        }

    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendReportBtn(_ sender: Any) {
        if textView.text.count < 1{
            let alert = UIAlertController(title: "Error", message: "You need to type in your report message", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction) in
                
            }))
            
            
            self.present(alert, animated: true, completion: nil)
        }else{
            
        textView.resignFirstResponder()
        if fullName != ""{
            print("wtf0")
            let alert = UIAlertController(title: "Report", message: "Are you sure you want to send this report?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action:UIAlertAction) in
                print("No")
            }))
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action:UIAlertAction) in
                DataService.instance.sendEbookReport(uid: (Auth.auth().currentUser?.uid)!, reportTime: NSDate().timeIntervalSince1970, report: self.textView.text!, fullName: self.fullName, imgTitleInMS: self.imgTitleInMS)
                
                let alert2 = UIAlertController(title: "Report", message: "Your report has been sent.", preferredStyle: .alert)
                
                alert2.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                }))
                
                self.present(alert2, animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }else{
            print("WTF")
            let alert = UIAlertController(title: "Error", message: "Connection error. Please try again.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction) in
                print("OK")
            }))
            self.present(alert, animated: true, completion: nil)
        }
            
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
    }
}
