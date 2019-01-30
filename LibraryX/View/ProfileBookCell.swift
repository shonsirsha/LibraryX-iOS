//
//  ProfileBookCell.swift
//  LibraryX
//
//  Created by Sean Saoirse on 29/01/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import UIKit

class ProfileBookCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var returningInLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var notifBulletView: RoundView!
    @IBOutlet weak var daysAgoPillView: RoundView!
    @IBOutlet weak var borrowingPillView: RoundView!
    
    func configCell(bookTitle: String, opened: Int, start: Double, until: Double, status: String, actualReturned: Double){
        
       
        
        
        
        if status == "borrowing"{
            statusLabel.text = "BORROWING"
            borrowingPillView.backgroundColor = #colorLiteral(red: 0, green: 0.5882352941, blue: 1, alpha: 1)
            daysAgoPillView.backgroundColor = #colorLiteral(red: 0, green: 0.5882352941, blue: 1, alpha: 1)
            notifBulletView.backgroundColor = #colorLiteral(red: 0, green: 0.5882352941, blue: 1, alpha: 1)
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
                    returningInLabel.text = "Return this book by Tomorrow"
                    returningInLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                }else if formatter.string(from: date) == "Today"{
                    returningInLabel.text = "Return this book by Today"
                    returningInLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                    
                }else if formatter.string(from: date) == "Yesterday"{
                    returningInLabel.text = "You're late to return this book! (Yesterday)"
                    returningInLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                }
            } else if day > 1 {
                returningInLabel.text = "Return this book in \(day) days"
                returningInLabel.textColor = #colorLiteral(red: 0, green: 0.5882352941, blue: 1, alpha: 1)
            } else {
                returningInLabel.text = "You're late to return this book! ( \(day) days ago)."
                returningInLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
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
                    startLabel.text = "TODAY"
                    
                }else if formatter2.string(from: date2) == "Yesterday"{
                    startLabel.text = "YESTERDAY"
                }
            } else if day2 > 1 {
                //impossible
            } else {
                startLabel.text = "\(day2) DAYS AGO"
            }
        }else if status == "returned"{
            statusLabel.text = "RETURNED"
            borrowingPillView.backgroundColor = #colorLiteral(red: 0.2057651579, green: 0.6540608406, blue: 0.4572110176, alpha: 1)
            daysAgoPillView.backgroundColor = #colorLiteral(red: 0.2057651579, green: 0.6540608406, blue: 0.4572110176, alpha: 1)
            notifBulletView.backgroundColor = #colorLiteral(red: 0.2057651579, green: 0.6540608406, blue: 0.4572110176, alpha: 1)
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
                    returningInLabel.text = "You returned this book Today"
                    returningInLabel.textColor = #colorLiteral(red: 0.2057651579, green: 0.6540608406, blue: 0.4572110176, alpha: 1)
                    
                }else if formatter.string(from: date) == "Yesterday"{
                    returningInLabel.text = "You returned this book Yesterday"
                    returningInLabel.textColor = #colorLiteral(red: 0.2057651579, green: 0.6540608406, blue: 0.4572110176, alpha: 1)
                }
            } else if day > 1 {
                //
            } else {
                returningInLabel.text = "You returned this book \(day) days ago"
                returningInLabel.textColor = #colorLiteral(red: 0.2057651579, green: 0.6540608406, blue: 0.4572110176, alpha: 1)
            }
            
            let calendar2 = Calendar.current
            let date2 = Date(timeIntervalSince1970: actualReturned)
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
                    startLabel.text = "TODAY"
                    
                }else if formatter2.string(from: date2) == "Yesterday"{
                    startLabel.text = "YESTERDAY"
                }
            } else if day2 > 1 {
                //impossible
            } else {
                startLabel.text = "\(day2) DAYS AGO"
            }
        }
        
        if opened == 0 {
            notifBulletView.isHidden = false
        }else{
            notifBulletView.isHidden = true
        }
        titleLabel.text = bookTitle
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
