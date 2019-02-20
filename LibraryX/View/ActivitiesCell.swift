//
//  ActivitiesCell.swift
//  LibraryX
//
//  Created by Sean Saoirse on 31/01/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
class ActivitiesCell: UITableViewCell {

    
    
    @IBOutlet weak var daysAgoPill: RoundView!
    @IBOutlet weak var statusPill: RoundView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var returnInXLabel: UILabel!
    @IBOutlet weak var myImgView: UIImageView!
    @IBOutlet weak var daysAgoLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    func configCell(bookTitle: String, start: Double, until: Double, imgTitleInMS: Double, actualReturned: Double, status: String){
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "EE, dd MMM yy"
        
        let reference = STORAGE.child("bookPics/\(Int(imgTitleInMS))")
        let placeholderImage = UIImage(named: "placeholder-Copy-3")
        myImgView.sd_setImage(with: reference, placeholderImage: placeholderImage)
        
        if status == "borrowing"{
            statusLabel.text = "BORROWED"
            let date1 = NSDate(timeIntervalSince1970: actualReturned) // this is equal to start date
            let startDate = dayTimePeriodFormatter.string(from: date1 as Date)
            dateLabel.text = "Borrowed: \(startDate)"
            statusPill.backgroundColor = #colorLiteral(red: 0, green: 0.5882352941, blue: 1, alpha: 1)
            daysAgoPill.backgroundColor = #colorLiteral(red: 0, green: 0.5882352941, blue: 1, alpha: 1)
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
                    returnInXLabel.text = "Return this book by tomorrow"
                    returnInXLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                    statusPill.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                    daysAgoPill.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                    
                }else if formatter.string(from: date) == "Today"{
                    DataService.instance.updateLateStatus(start: start)
                    returnInXLabel.text = "Return this book by today"
                    returnInXLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                    statusPill.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                    daysAgoPill.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                    
                }else if formatter.string(from: date) == "Yesterday"{
                    DataService.instance.updateLateStatus(start: start)
                    returnInXLabel.text = "NEEDS ATTENTION: You're LATE to return this book! (yesterday)"
                    statusPill.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                    daysAgoPill.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                    returnInXLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                }
            } else if day > 1 {
                returnInXLabel.text = "Return this book in \(day) days"
                if day <= 3{
                    returnInXLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                    statusPill.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                    daysAgoPill.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                }else{
                    returnInXLabel.textColor = #colorLiteral(red: 0, green: 0.5882352941, blue: 1, alpha: 1)
                }
                
            } else {
                DataService.instance.updateLateStatus(start: start)
                let newDay = day * -1
                returnInXLabel.text = "NEEDS ATTENTION: You're LATE to return this book! ( \(newDay) days ago)"
                statusPill.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                daysAgoPill.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                returnInXLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                
            }
            
            let calendar2 = Calendar.current
            let date2 = Date(timeIntervalSince1970: start)
            let startOfNow2 = calendar2.startOfDay(for: Date())
            let startOfTimeStamp2 = calendar2.startOfDay(for: date2)
            let components2 = calendar2.dateComponents([.day], from: startOfNow2, to: startOfTimeStamp2)
            let day2 = components2.day!
            
            if abs(day2) < 2 {
                let formatter2 = DateFormatter()
                formatter2.dateStyle = .short
                formatter2.timeStyle = .none
                formatter2.doesRelativeDateFormatting = true
                if formatter2.string(from: date2) == "Tomorrow"{
                    //impossible
                }else if formatter2.string(from: date2) == "Today"{
                    daysAgoLabel.text = "TODAY"
                    
                }else if formatter2.string(from: date2) == "Yesterday"{
                    daysAgoLabel.text = "YESTERDAY"
                }
            } else if day2 > 1 {
                //impossible
            } else {
                let newDay = day2 * -1
                daysAgoLabel.text = "\(newDay) DAYS AGO"
            }
        }else if status == "returned"{
            statusLabel.text = "RETURNED"
            let date1 = NSDate(timeIntervalSince1970: actualReturned) // this is actual returned date
            let returnedDate = dayTimePeriodFormatter.string(from: date1 as Date)
            let date2 = NSDate(timeIntervalSince1970: start) // this is start date
            let startDate = dayTimePeriodFormatter.string(from: date2 as Date)
            dateLabel.text = "Returned: \(returnedDate) (borrowed: \(startDate))"
            statusPill.backgroundColor = #colorLiteral(red: 0.2057651579, green: 0.6540608406, blue: 0.4572110176, alpha: 1)
            daysAgoPill.backgroundColor = #colorLiteral(red: 0.2057651579, green: 0.6540608406, blue: 0.4572110176, alpha: 1)
            let calendar = Calendar.current
            let date = Date(timeIntervalSince1970: actualReturned)
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
                    returnInXLabel.text = "You have returned this book today"
                    returnInXLabel.textColor = #colorLiteral(red: 0.2057651579, green: 0.6540608406, blue: 0.4572110176, alpha: 1)
                    daysAgoLabel.text = "TODAY"
                    
                    
                }else if formatter.string(from: date) == "Yesterday"{
                    returnInXLabel.text = "You have returned this book yesterday"
                    returnInXLabel.textColor = #colorLiteral(red: 0.2057651579, green: 0.6540608406, blue: 0.4572110176, alpha: 1)
                    daysAgoLabel.text = "YESTERDAY"
                    
                }
            } else if day > 1 {
                //
            } else {
                let newDay = day * -1
                returnInXLabel.text = "You have returned this book \(newDay) days ago"
                returnInXLabel.textColor = #colorLiteral(red: 0.2057651579, green: 0.6540608406, blue: 0.4572110176, alpha: 1)
                daysAgoLabel.text = "\(newDay) DAYS AGO"
            }
            
        }
        
    
        
        titleLabel.text = bookTitle
        
        
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = .byWordWrapping
        self.titleLabel.sizeToFit()
        
        self.dateLabel.numberOfLines = 0
        self.dateLabel.lineBreakMode = .byWordWrapping
        self.dateLabel.sizeToFit()
        
        self.returnInXLabel.numberOfLines = 0
        self.returnInXLabel.lineBreakMode = .byWordWrapping
        self.returnInXLabel.sizeToFit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
