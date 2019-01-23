//
//  MainCell.swift
//  CanteenX
//
//  Created by Sean Saoirse on 22/01/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import UIKit

class MainCell: UITableViewCell {

   
    @IBOutlet weak var sellerNameLabel: UILabel!
    
    func configCell(name: String){
        sellerNameLabel.text = name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
