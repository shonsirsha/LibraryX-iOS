//
//  MoreVC.swift
//  LibraryX
//
//  Created by Sean Saoirse on 19/02/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import UIKit
import Firebase

class MoreVC: UIViewController {
    let capacity:Double = 40
    var level:Double = 0
    var myArr = [Int]()
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var numOfPeople: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        
       
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        levelLabel.stopBlink()
        levelLabel.startBlink()
        DataService.instance.getWifiUser { (returnedArr) in
            self.myArr = returnedArr

            
            print(self.level)
            
            self.numOfPeople.text = "\(self.myArr[0]) people"
            
            print(self.myArr[0])
            self.level = Double((Double(self.myArr[0]) / self.capacity)*100)
            if self.level <= 30{
                self.levelLabel.text = "not crowded"
                self.levelLabel.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            }else if self.level <= 40 && self.level > 30{
                self.levelLabel.text = "slightly crowded"
                self.levelLabel.textColor = #colorLiteral(red: 0.9579235406, green: 0.5509680707, blue: 0.1176804783, alpha: 1)
            }else if self.level <= 50 && self.level > 40{
                self.levelLabel.text = "moderately crowded"
                self.levelLabel.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            }else if self.level <= 80 && self.level > 50{
                self.levelLabel.text = "crowded"
                self.levelLabel.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            }else if self.level > 80{
                self.levelLabel.text = "very crowded"
                self.levelLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            }
            
            let calendar = Calendar.current
            let date = Date(timeIntervalSince1970: TimeInterval(self.myArr[1]))
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
                    let realDate = self.myArr[1]
                    let date = NSDate(timeIntervalSince1970: TimeInterval(realDate))
                    let dayTimePeriodFormatter = DateFormatter()
                    dayTimePeriodFormatter.dateFormat = "hh:mm:ss a"
                    let dateString = dayTimePeriodFormatter.string(from: date as Date)
                    
                    self.timeLabel.text = "Last updated: Today at \(dateString)"

                }else if formatter.string(from: date) == "Yesterday"{
                    
                    
                }

        }
        
        
            
        }

    }
    
   
    


}

extension UILabel {
    
    func startBlink() {
        UIView.animate(withDuration: 0.8,
                       delay:0.0,
                       options:[.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
                       animations: { self.alpha = 0 },
                       completion: nil)
    }
    
    func stopBlink() {
        layer.removeAllAnimations()
        alpha = 1
    }
}
