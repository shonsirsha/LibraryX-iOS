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
    var start: Double = 0
    var until: Double = 0
    let epochConst: Double = 86400
    var bookTitle = ""
    

    @IBOutlet weak var bookImgView: UIImageView!
    @IBOutlet weak var dateBorrowLabel: UILabel!
    @IBOutlet weak var dateReturnLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var returnInLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let reference = STORAGE.child("bookPics/\(Int(imgTitleInMS))")
        
        let placeholderImage = UIImage(named: "placeholder-Copy-3")
        
        bookImgView.sd_setImage(with: reference, placeholderImage: placeholderImage)
        
        let date1 = NSDate(timeIntervalSince1970: start)
        let date2 = NSDate(timeIntervalSince1970: until)

        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "EE, dd MMM yy"
        
        let startDate = dayTimePeriodFormatter.string(from: date1 as Date)
        
        let untilDate = dayTimePeriodFormatter.string(from: date2 as Date)
        
        dateBorrowLabel.text = startDate
        dateReturnLabel.text = untilDate
        
        titleLabel.text = bookTitle
      
        let calendar = Calendar.current
        let date = Date(timeIntervalSince1970: until)
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
                returnInLabel.text = "Return this book by Tomorrow"
                returnInLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            }else if formatter.string(from: date) == "Today"{
                returnInLabel.text = "Return this book by Today"
                returnInLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                
            }else if formatter.string(from: date) == "Today"{
                returnInLabel.text = "You're late to return this book!"
                returnInLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            }
        } else if day > 1 {
            returnInLabel.text = "Return this book in \(day) days"
            returnInLabel.textColor = #colorLiteral(red: 0, green: 0.5882352941, blue: 1, alpha: 1)
        } else {
            returnInLabel.text = "You're late to return this book!"
            returnInLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
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
    
    
    
}
