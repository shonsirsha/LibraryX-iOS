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
    
    func configCell(bookTitle: String){
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
