//
//  MainCell.swift
//  CanteenX
//
//  Created by Sean Saoirse on 22/01/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
class MainCell: UITableViewCell {

   
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookImgview: UIImageView!
    
    func configCell(bookTitle: String, authorName: String, genre: String, year: String, imgTitleInMS: Double){
        
        let reference = STORAGE.child("bookPics/\(Int(imgTitleInMS))")
        
        let placeholderImage = UIImage(named: "placeholder-Copy-3")
        
        bookImgview.sd_setImage(with: reference, placeholderImage: placeholderImage)
        
        bookTitleLabel.text = bookTitle
        authorNameLabel.text = authorName
        genreLabel.text = genre
        yearLabel.text = year
        
        
        
        self.bookTitleLabel.numberOfLines = 0
        self.bookTitleLabel.lineBreakMode = .byWordWrapping
        self.bookTitleLabel.sizeToFit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
