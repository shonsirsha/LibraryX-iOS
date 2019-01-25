//
//  MainCell.swift
//  CanteenX
//
//  Created by Sean Saoirse on 22/01/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import UIKit

class MainCell: UITableViewCell {

   
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var bookTitleLabel: UILabel!
    
    func configCell(bookTitle: String, authorName: String, genre: String, year: String){
        bookTitleLabel.text = bookTitle
        authorNameLabel.text = authorName
        genreLabel.text = genre
        yearLabel.text = year
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
