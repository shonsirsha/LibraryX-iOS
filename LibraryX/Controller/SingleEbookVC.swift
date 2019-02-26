//
//  SingleEbookVC.swift
//  LibraryX
//
//  Created by Sean Saoirse on 26/02/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import UIKit

class SingleEbookVC: UIViewController {
    var bookTitle = ""
    var yearReleased = ""
    var authorName = ""
    var imgTitleInMS: Double = 0
    
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var myImgView: UIImageView!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var readBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if imgTitleInMS != 0{
            DataService.instance.getEbookGenres(imgTitleInMS: imgTitleInMS) { (returnedGenres) in
                self.genresLabel.text = "Genres: \(returnedGenres)"
            }
            
            let reference = STORAGE.child("bookPics/\(Int(imgTitleInMS))")
            
            let placeholderImage = UIImage(named: "placeholder-Copy-3")
            
            myImgView.sd_setImage(with: reference, placeholderImage: placeholderImage)
            titleLabel.text = bookTitle
            authorLabel.text = "Author: \(authorName)"
            yearLabel.text = "Year Released: \(yearReleased)"
            readBtn.isHidden = false
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEbookReaderVC"{
            
            if let ebookReaderVC = segue.destination as? EbookReaderVC {
              ebookReaderVC.bookTitle = bookTitle
                ebookReaderVC.imgTitleInMS = imgTitleInMS
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
