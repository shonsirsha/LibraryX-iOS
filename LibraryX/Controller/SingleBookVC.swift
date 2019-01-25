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
    var genres = ""
    var year = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        titleLabel.text = bookTitle
        authorLabel.text = "Author: \(authorName)"
        yearLabel.text = "Year Released: \(year)"
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    



}
