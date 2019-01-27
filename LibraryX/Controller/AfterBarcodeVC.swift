//
//  AfterBarcodeVC.swift
//  LibraryX
//
//  Created by Sean Saoirse on 27/01/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class AfterBarcodeVC: UIViewController {
    var imgTitleInMS: Double = 0
    var days: Int = 1
    var maxDays: Int = 0
    let oneDayInEpoch: Int = 86400
    @IBOutlet weak var maxDaysLabel: UILabel!
    @IBOutlet weak var borrowingPeriodPlaceholder: UILabel!
    var prevVC: ScannerVC!
    
    @IBOutlet weak var borrowBtn: UIButton!
    @IBOutlet weak var daysLabel: UILabel!
    
    
    @IBOutlet weak var bookImgView: UIImageView!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
      // prevVC.dismiss(animated: true, completion: nil)

        DataService.instance.scannedBookFromImgTitle(imgTitleinMS: imgTitleInMS, myBookTitle: { (returnedBookTitle) in
            let reference = STORAGE.child("bookPics/\(Int(self.imgTitleInMS))")
            let placeholderImage = UIImage(named: "placeholder-Copy-3")
            self.bookImgView.sd_setImage(with: reference, placeholderImage: placeholderImage)
        self.titleLabel.text = returnedBookTitle
        }) { (returnedMaxDays) in
            DataService.instance.getABookStatus(imgTitleInMS: self.imgTitleInMS, handler: { (returnedStatus) in
                if returnedStatus == "avail"{ // available for borrowment
                    self.maxDays = returnedMaxDays
                    self.maxDaysLabel.text = "Maximum: \(returnedMaxDays) days"
                    self.days = self.maxDays
                    self.daysLabel.text = "\(self.days)"
                    self.minusBtn.isHidden = false
                    self.addBtn.isHidden = false
                    self.borrowingPeriodPlaceholder.text = "Borrowing period (days):"
                    self.borrowBtn.isHidden = false

                }else{
                    self.minusBtn.isHidden = true
                    self.addBtn.isHidden = true
                    self.borrowBtn.isHidden = true
                    
                    self.borrowingPeriodPlaceholder.text = "CURRENTLY UNAVAILABLE."
                    self.maxDaysLabel.text = ""
                    self.daysLabel.text = ""

                }
            })
            
        }

        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = .byWordWrapping
        self.titleLabel.sizeToFit()
        
        self.borrowingPeriodPlaceholder.numberOfLines = 0
        self.borrowingPeriodPlaceholder.lineBreakMode = .byWordWrapping
        self.borrowingPeriodPlaceholder.sizeToFit()
        
        daysLabel.text = "\(days)"
    }
    
    @IBAction func minusBtn(_ sender: Any) {
        if days > 1{
            days -= 1
            daysLabel.text = "\(days)"
        }
    }
    
    @IBAction func addBtn(_ sender: Any) {
        if days < maxDays{
            days += 1
            daysLabel.text = "\(days)"
        }
    }
    
    @IBAction func borrowBtn(_ sender: Any) {
        let start = NSDate().timeIntervalSince1970
        let until = start + Double((days * oneDayInEpoch))
        DataService.instance.borrowBook(imgTitleInMS: imgTitleInMS, uid: (Auth.auth().currentUser?.uid)!, start: start, until: until)
    }
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
