//
//  SingleBookVC.swift
//  LibraryX
//
//  Created by Sean Saoirse on 25/01/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class SingleBookVC: UIViewController {
   
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
 
    @IBOutlet weak var toScanVCbtn: UIButton!
    @IBOutlet weak var authorLabel: UILabel!
    var imgTitleinMs: Double = 0
    var bookTitle = ""
    var authorName = ""
    var year = ""
    var startDate: Double = 0
    var currentlyBorrowing = false
    
    @IBOutlet weak var bookImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        DataService.instance.getABookStatus(imgTitleInMS: imgTitleinMs) { (returnedArr) in
            if returnedArr[1] == "avail"{ // 1 is status, 0 is aisle place.
                self.currentlyBorrowing = false
                #if Client
                    self.toScanVCbtn.isHidden = true
                #else
                    self.toScanVCbtn.isHidden = false
                #endif
                self.toScanVCbtn.backgroundColor = #colorLiteral(red: 0, green: 0.5882352941, blue: 1, alpha: 1)
                self.toScanVCbtn.setTitle("Scan & Borrow!", for: UIControl.State.normal)
                self.statusLabel.textColor = #colorLiteral(red: 0, green: 0.5882352941, blue: 1, alpha: 1)
                self.statusLabel.text = "Available at aisle number: \(returnedArr[0])"
            }else{
                DataService.instance.amIBorrowing(uid: (Auth.auth().currentUser?.uid)!, imgTitleInMS: self.imgTitleinMs, statusBorrowing: { (returnedStatus) in
                    if returnedStatus == "borrow"{
                        DataService.instance.getLastBookDetailFromActivity(uid: (Auth.auth().currentUser?.uid)!, imgTitleInMS: self.imgTitleinMs, bookStart: { (returnedStartDate) in
                            self.startDate = returnedStartDate
                            self.currentlyBorrowing = true
                            self.toScanVCbtn.backgroundColor = #colorLiteral(red: 0.2057651579, green: 0.6540608406, blue: 0.4572110176, alpha: 1)
                            #if Client
                                self.toScanVCbtn.isHidden = true
                            #else
                                self.toScanVCbtn.isHidden = false
                            #endif
                            self.toScanVCbtn.setTitle("See Borrowing Details", for: UIControl.State.normal)
                            self.statusLabel.textColor = #colorLiteral(red: 0.2057651579, green: 0.6540608406, blue: 0.4572110176, alpha: 1)
                            self.statusLabel.text = "You are currently borrowing this book."
                        })
                       
                    }else{
                        self.toScanVCbtn.isHidden = true
                        self.statusLabel.textColor = #colorLiteral(red: 1, green: 0.148809104, blue: 0.2488994031, alpha: 1)
                        self.statusLabel.text = "This book is currently unavailable."
                    }
                })
                
            }
            DataService.instance.getGenresFromImgTitle(imgTitleInMS: self.imgTitleinMs) { (returnedGenresStr) in
                self.genreLabel.text = "Genres: \(returnedGenresStr)"
            }
        }
        
       
        
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = .byWordWrapping
        self.titleLabel.sizeToFit()
        
        self.statusLabel.numberOfLines = 0
        self.statusLabel.lineBreakMode = .byWordWrapping
        self.statusLabel.sizeToFit()
        
        self.authorLabel.numberOfLines = 0
        self.authorLabel.lineBreakMode = .byWordWrapping
        self.authorLabel.sizeToFit()
        if imgTitleinMs != 0{
            print(imgTitleinMs)
            let reference = STORAGE.child("bookPics/\(Int(imgTitleinMs))")
            
            let placeholderImage = UIImage(named: "placeholder-Copy-3")
            
            bookImgView.sd_setImage(with: reference, placeholderImage: placeholderImage)
            titleLabel.text = bookTitle
            authorLabel.text = "Author: \(authorName)"
            yearLabel.text = "Year Released: \(year)"
            
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionBtn(_ sender: Any) {
        if currentlyBorrowing == false{
            performSegue(withIdentifier: "toScanVC", sender: self)
        }else{
            performSegue(withIdentifier: "toMySingleBookVC", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMySingleBookVC"{
            if let myBookSingleVC = segue.destination as? MyBookSingleVC {
                myBookSingleVC.imgTitleInMS = imgTitleinMs
                myBookSingleVC.startBorrowDate = startDate
                
        }
    }
        
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if toMyAccVC == true || toScanVCReturn == true{
            dismiss(animated: true, completion: nil)
        }
    }
    



}
