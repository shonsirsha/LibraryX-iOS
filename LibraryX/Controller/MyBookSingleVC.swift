//
//  MyBookSingleVC.swift
//  LibraryX
//
//  Created by Sean Saoirse on 29/01/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI


class MyBookSingleVC: UIViewController {
    var imgTitleInMS: Double = 0

    var startBorrowDate: Double = 0
    var borrowUntilDate: Double = 0
    var actualReturnedDate: Double = 0
    var status = ""
    @IBOutlet weak var bookImgView: UIImageView!
    @IBOutlet weak var dateBorrowLabel: UILabel!
    @IBOutlet weak var dateReturnLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var returnInLabel: UILabel!
    @IBOutlet weak var totalDaysLabel: UILabel!
    @IBOutlet weak var availAtLabel: UILabel!
    @IBOutlet weak var reportBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionBtn.isHidden = true
        reportBtn.isHidden = true

        availAtLabel.isHidden = true
        let reference = STORAGE.child("bookPics/\(Int(imgTitleInMS))")
        
        let placeholderImage = UIImage(named: "placeholder-Copy-3")
        
        bookImgView.sd_setImage(with: reference, placeholderImage: placeholderImage)
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "EE, dd MMM yy"
        
        DataService.instance.myBookDetail(uid: (Auth.auth().currentUser?.uid)!, startDate: startBorrowDate, status: { (returnedStatus) in
            self.status = returnedStatus
            if self.status == "borrowing"{
                #if Client
                    self.actionBtn.isHidden = true
                #else
                    self.actionBtn.isHidden = false
                #endif
                self.actionBtn.setTitle("Scan & Return Now", for: UIControl.State.normal)
                self.actionBtn.backgroundColor = #colorLiteral(red: 0, green: 0.5882352941, blue: 1, alpha: 1)
                self.reportBtn.isHidden = false
            }else if self.status == "returned"{
                self.reportBtn.isHidden = true
                DataService.instance.getABookStatus(imgTitleInMS: self.imgTitleInMS, handler: { (returnedArr) in
                    if returnedArr[1] == "avail"{ // 1 is status, 0 is avail at aisle X
                        #if Client
                            self.actionBtn.isHidden = true
                        #else
                            self.actionBtn.isHidden = false
                        #endif
                        self.actionBtn.setTitle("Scan & Borrow again", for: UIControl.State.normal)
                        self.actionBtn.backgroundColor = #colorLiteral(red: 0.2057651579, green: 0.6540608406, blue: 0.4572110176, alpha: 1)
                        self.availAtLabel.isHidden = false
                        self.availAtLabel.text = "Available at aisle: \(returnedArr[0])"
                    }else{
                        self.actionBtn.isHidden = true
                    }
                })
            }
        }, start: { (returnedStartDate) in
            let date1 = NSDate(timeIntervalSince1970: returnedStartDate)
            let startDate = dayTimePeriodFormatter.string(from: date1 as Date)
            self.dateBorrowLabel.text = startDate
        }, until: { (returnedUntilDate) in
            self.borrowUntilDate = returnedUntilDate
            let date2 = NSDate(timeIntervalSince1970: returnedUntilDate)
            let untilDate = dayTimePeriodFormatter.string(from: date2 as Date)
            self.dateReturnLabel.text = untilDate
            self.totalDaysLabel.text = "\(Int((self.borrowUntilDate - self.startBorrowDate)/86400)) DAYS" // to get total days from EPOCH

        }, title: { (returnedBookTitle) in
            self.titleLabel.text = returnedBookTitle
        }) { (returnedActualReturnedDate) in
            if self.status == "borrowing"{
                if self.borrowUntilDate != 0{
                    let calendar = Calendar.current
                    let date = Date(timeIntervalSince1970: self.borrowUntilDate)
                    let startOfNow = calendar.startOfDay(for: Date())
                    let startOfTimeStamp = calendar.startOfDay(for: date)
                    let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
                    let day = components.day!
                    
                    if abs(day) < 2 {
                        let formatter = DateFormatter()
                        formatter.dateStyle = .short
                        formatter.timeStyle = .none
                        formatter.doesRelativeDateFormatting = true
                        if formatter.string(from: date) == "Tomorrow"{
                            self.returnInLabel.text = "Return this book before or by tomorrow."
                            self.returnInLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                        }else if formatter.string(from: date) == "Today"{
                            self.returnInLabel.text = "Return this book by today."
                            self.returnInLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                            
                        }else if formatter.string(from: date) == "Yesterday"{
                            self.returnInLabel.text = "You're LATE to return this book (yesterday)! RETURN IT SOON!"
                            self.returnInLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                        }
                    } else if day > 1 {
                        self.returnInLabel.text = "You may return this book before or on the returning date (in \(day) days)."
                        self.returnInLabel.textColor = #colorLiteral(red: 0, green: 0.5882352941, blue: 1, alpha: 1)
                    } else {
                        let newDay = day * -1
                       
                        
                        self.returnInLabel.text = "You're LATE to return this book (\(newDay) days ago)! RETURN IT SOON!"
                        self.returnInLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                    }
                }
                
            }else if self.status == "returned"{
                let calendar = Calendar.current
                let date = Date(timeIntervalSince1970: returnedActualReturnedDate)
                let startOfNow = calendar.startOfDay(for: Date())
                let startOfTimeStamp = calendar.startOfDay(for: date)
                let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
                let day = components.day!
                
                if abs(day) < 2 {
                    let formatter = DateFormatter()
                    formatter.dateStyle = .short
                    formatter.timeStyle = .none
                    formatter.doesRelativeDateFormatting = true
                    if formatter.string(from: date) == "Tomorrow"{
                        //
                    }else if formatter.string(from: date) == "Today"{
                        self.returnInLabel.text  = "You have returned this book today."
                        self.returnInLabel.textColor = #colorLiteral(red: 0.2057651579, green: 0.6540608406, blue: 0.4572110176, alpha: 1)
                        
                    }else if formatter.string(from: date) == "Yesterday"{
                        self.returnInLabel.text  = "You have returned this book yesterday."
                        self.returnInLabel.textColor = #colorLiteral(red: 0.2057651579, green: 0.6540608406, blue: 0.4572110176, alpha: 1)
                    }
                } else if day > 1 {
                    //
                } else {
                    let newDay = day * -1
                    let dateActualReturned = NSDate(timeIntervalSince1970: returnedActualReturnedDate)
                    
                    let dateActualReturnedString = dayTimePeriodFormatter.string(from: dateActualReturned as Date)
                    
                    self.returnInLabel.text  = "You have returned this book \(newDay) days ago (\(dateActualReturnedString))."
                    
                    self.returnInLabel.textColor = #colorLiteral(red: 0.2057651579, green: 0.6540608406, blue: 0.4572110176, alpha: 1)
                }
            }
        }
      
        
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = .byWordWrapping
        self.titleLabel.sizeToFit()
        
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func returnBtn(_ sender: Any) {
        toScanVCReturn = true
        dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReportBookVC"{
            if let reportBookVC = segue.destination as? ReportBookVC {
                reportBookVC.imgTitleInMS = imgTitleInMS
            }
        }
    }
    @IBAction func reportBtn(_ sender: Any) {
        performSegue(withIdentifier: "toReportBookVC", sender: self)
    }
    
    
}
