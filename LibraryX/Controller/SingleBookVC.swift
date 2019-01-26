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
 
    @IBOutlet weak var authorLabel: UILabel!
    var imgTitleinMs: Double = 0
    var bookTitle = ""
    var authorName = ""
    var year = ""
    
    @IBOutlet weak var bookImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = .byWordWrapping
        self.titleLabel.sizeToFit()
        
        self.authorLabel.numberOfLines = 0
        self.authorLabel.lineBreakMode = .byWordWrapping
        self.authorLabel.sizeToFit()
        if imgTitleinMs != 0{
            print(imgTitleinMs)
            print("WOIII")
            let reference = STORAGE.child("bookPics/\(Int(imgTitleinMs))")
            
            let placeholderImage = UIImage(named: "placeholder-Copy-3")
            
            
            bookImgView.sd_setImage(with: reference, placeholderImage: placeholderImage)
            DataService.instance.getGenresFromImgTitle(imgTitleInMS: imgTitleinMs) { (returnedGenresStr) in
                self.genreLabel.text = "Genres: \(returnedGenresStr)"
            }
            titleLabel.text = bookTitle
            authorLabel.text = "Author: \(authorName)"
            yearLabel.text = "Year Released: \(year)"
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    



}
