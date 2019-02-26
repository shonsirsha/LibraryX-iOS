//
//  EbookCell.swift
//  libraryX
//
//  Created by Sean Saoirse on 26/02/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class EbookCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var myImgView: UIImageView!
    
    func configCell(bookTitle: String, authorName: String, genre: String, year: String, imgTitleInMS: Double){
        let reference = STORAGE.child("bookPics/\(Int(imgTitleInMS))")
        let placeholderImage = UIImage(named: "placeholder-Copy-3")
        myImgView.sd_setImage(with: reference, placeholderImage: placeholderImage)
        titleLabel.text = bookTitle
        authorLabel.text = authorName
        genresLabel.text = genre
        yearLabel.text = year
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = .byWordWrapping
        self.titleLabel.sizeToFit()
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
