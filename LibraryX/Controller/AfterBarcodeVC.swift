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
   var statusBook = ""
    
    @IBOutlet weak var borrowBtn: UIButton!
    @IBOutlet weak var daysLabel: UILabel!
    
    
    @IBOutlet weak var bookImgView: UIImageView!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
      //
        DataService.instance.scannedBookFromImgTitle(imgTitleinMS: imgTitleInMS, bookStatusAndTitleHandler: { (returnedBookStatusAndTitleArr) in
            let reference = STORAGE.child("bookPics/\(Int(self.imgTitleInMS))")
            let placeholderImage = UIImage(named: "placeholder-Copy-3")
            self.bookImgView.sd_setImage(with: reference, placeholderImage: placeholderImage)
        self.titleLabel.text = returnedBookStatusAndTitleArr[1]
        }) { (returnedMaxDays) in
           
            DataService.instance.getABookStatus(imgTitleInMS: self.imgTitleInMS, handler: { (returnedArr) in
                if returnedArr[1] == "avail"{ // 1 is status, 0 is aisle
                    self.statusBook = "gonnaBorrow"
                    self.maxDays = returnedMaxDays
                    self.maxDaysLabel.text = "Maximum: \(returnedMaxDays) days"
                    self.days = self.maxDays
                    self.daysLabel.text = "\(self.days)"
                    self.minusBtn.isHidden = false
                    self.addBtn.isHidden = false
                    self.borrowingPeriodPlaceholder.text = "Borrowing period (days):"
                    self.borrowBtn.isHidden = false
                    
                }else{
                    DataService.instance.amIBorrowing(uid: (Auth.auth().currentUser?.uid)!, imgTitleInMS: self.imgTitleInMS, statusBorrowing: { (status) in
                        if status == "borrow"{
                            self.statusBook = "gonnaReturn"
                            self.minusBtn.isHidden = true
                            self.addBtn.isHidden = true
                            self.borrowBtn.isHidden = false
                            self.borrowBtn.setTitle("Return", for: UIControl.State.normal)
                            self.borrowingPeriodPlaceholder.textColor = #colorLiteral(red: 0.2057651579, green: 0.6540608406, blue: 0.4572110176, alpha: 1)
                            self.borrowingPeriodPlaceholder.text = "You're currently borrowing this book. Return now?"
                            self.maxDaysLabel.text = ""
                            self.daysLabel.text = ""
                        }else if status == "notByMe" || status == "returned"{
                            self.minusBtn.isHidden = true
                            self.addBtn.isHidden = true
                            self.borrowBtn.isHidden = true
                            self.borrowingPeriodPlaceholder.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                            self.borrowingPeriodPlaceholder.text = "CURRENTLY UNAVAILABLE."
                            self.maxDaysLabel.text = ""
                            self.daysLabel.text = ""
                        }
                        
                    })
                    
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
        if statusBook == "gonnaBorrow"{
            let start = NSDate().timeIntervalSince1970
            let until = start + Double((days * oneDayInEpoch))
            DataService.instance.borrowBook(imgTitleInMS: imgTitleInMS, uid: (Auth.auth().currentUser?.uid)!, title: titleLabel.text!, start: start, until: until)
            
           
        }else if statusBook == "gonnaReturn"{
            let actualReturned = NSDate().timeIntervalSince1970
            DataService.instance.returnBook(imgTitleInMS: imgTitleInMS, uid: (Auth.auth().currentUser?.uid)!, title: titleLabel.text!, actualReturned: actualReturned)
        }
        toMyAccVC = true
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

