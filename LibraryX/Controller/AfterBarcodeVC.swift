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
            self.maxDays = returnedMaxDays
            self.maxDaysLabel.text = "Maximum: \(returnedMaxDays) days"
            self.days = self.maxDays
            self.daysLabel.text = "\(self.days)"
            self.minusBtn.isHidden = false
            self.addBtn.isHidden = false
        }
        
        print(imgTitleInMS)
        
        
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = .byWordWrapping
        self.titleLabel.sizeToFit()
        
        self.borrowingPeriodPlaceholder.numberOfLines = 0
        self.borrowingPeriodPlaceholder.lineBreakMode = .byWordWrapping
        self.borrowingPeriodPlaceholder.sizeToFit()
        
        daysLabel.text = "\(days)"
    }
    

   
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
