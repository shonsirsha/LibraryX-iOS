//
//  SingleEbookVC.swift
//  LibraryX
//
//  Created by Sean Saoirse on 26/02/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import UIKit
import Firebase

class SingleEbookVC: UIViewController {
    var bookTitle = ""
    var yearReleased = ""
    var authorName = ""
    var imgTitleInMS: Double = 0
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var myImgView: UIImageView!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var readBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    
        if imgTitleInMS != 0{
            DataService.instance.getEbookStatus(imgTitleInMS: imgTitleInMS) { (returnedStatus) in
                if returnedStatus == "avail"{
                    self.saveBtn.isHidden = false
                    self.readBtn.isHidden = false

                }else{
                    self.saveBtn.isHidden = true
                    self.readBtn.isHidden = true

                }
            }
            DataService.instance.getEbookGenres(imgTitleInMS: imgTitleInMS) { (returnedGenres) in
                self.genresLabel.text = "Genres: \(returnedGenres)"
            }
            DataService.instance.checkIfBookSaved(uid: (Auth.auth().currentUser?.uid)!, imgTitleInMS: imgTitleInMS) { (returnedStatus) in
                if returnedStatus == "saved"{
                    print("ASASAASASAAS")
                    self.saveBtn.setImage(UIImage(named: "icons8-bookmark-filled-100"),for: .normal)
                }else{
                    self.saveBtn.setImage(UIImage(named: "icons8-bookmark-100"),for: .normal)
                }
            }
            

            
            let reference = STORAGE.child("bookPics/\(Int(imgTitleInMS))")
            
            let placeholderImage = UIImage(named: "placeholder-Copy-3")
            
            myImgView.sd_setImage(with: reference, placeholderImage: placeholderImage)
            titleLabel.text = bookTitle
            authorLabel.text = "Author: \(authorName)"
            yearLabel.text = "Year Released: \(yearReleased)"
            
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEbookReaderVC"{
            
            if let ebookReaderVC = segue.destination as? EbookReaderVC {
              ebookReaderVC.bookTitle = bookTitle
                ebookReaderVC.imgTitleInMS = imgTitleInMS
            }
        }
    }
    
    @IBAction func saveBook(_ sender: Any) {
        DataService.instance.saveEbook(uid: (Auth.auth().currentUser?.uid)!, imgTitleInMS: imgTitleInMS, time: NSDate().timeIntervalSince1970, authorName: authorName, bookTitle: bookTitle, year: yearReleased ) { (returnedStatus) in
            if returnedStatus == "removed"{
                self.saveBtn.setImage(UIImage(named: "icons8-bookmark-100"),for: .normal)
                print("unsaved")
            }else if returnedStatus == "added"{
                self.saveBtn.setImage(UIImage(named: "icons8-bookmark-filled-100"),for: .normal)
                print("saved")
            }
            
        }
    }
    
    @IBAction func readBtn(_ sender: Any) {
        performSegue(withIdentifier: "toEbookReaderVC", sender: self)
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
