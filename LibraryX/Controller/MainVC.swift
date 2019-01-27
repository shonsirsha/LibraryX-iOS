//
//  MainVC.swift
//  CanteenX
//
//  Created by Sean Saoirse on 22/01/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import UIKit
import Firebase
class MainVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
     var bookArr = [BookDetailForCell]()
  
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var floaty: Floaty!
    
    var bookTotal = 0
    
    @IBOutlet weak var allBookLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        myTableView.dataSource = self
        myTableView.delegate = self
        
        
        
        self.myTableView.tableFooterView = UIView()
        
      
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        floaty.addGestureRecognizer(tap)
     
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        DataService.instance.getAllBooks { (returnedEachBookObj) in
            self.bookArr = returnedEachBookObj
            self.myTableView.reloadData()
            self.bookTotal = self.bookArr.count
            self.allBookLabel.text = "All books (" + "\(self.bookTotal))"
        }
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        performSegue(withIdentifier: "toScannerVC", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = myTableView.dequeueReusableCell(withIdentifier: "mycell") as? MainCell else {return UITableViewCell()}
        let eachBookObj = bookArr[indexPath.row]
        var genresArr = [String]()
        
        genresArr.append(eachBookObj.genre1)
        genresArr.append(eachBookObj.genre2)
        genresArr.append(eachBookObj.genre3)
        
        for (ix, genre) in genresArr.enumerated() {
            if genre == ""{
                genresArr.remove(at: ix)
            }
        }

        let stringGenres = genresArr.joined(separator: ", ")
        cell.configCell(bookTitle: eachBookObj.bookTitle, authorName: "Author: \(eachBookObj.authorName)", genre: "Genres: \(stringGenres)", year: "Year released: \(eachBookObj.year)")
        
        if (cell.responds(to: #selector(setter: UITableViewCell.separatorInset))) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        
        if (cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins))) {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        if (cell.responds(to: #selector(setter: UIView.layoutMargins))) {
            cell.layoutMargins = UIEdgeInsets.zero
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ixPath = myTableView.indexPathForSelectedRow{
            if segue.identifier == "toSingleBookVC"{
                if let singleBookVC = segue.destination as? SingleBookVC {
                    singleBookVC.imgTitleinMs = bookArr[ixPath.row].imgTitle
                    singleBookVC.bookTitle = bookArr[ixPath.row].bookTitle
                    singleBookVC.year = bookArr[ixPath.row].year
                    singleBookVC.authorName = bookArr[ixPath.row].authorName
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toSingleBookVC", sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchField.resignFirstResponder()
    }
  
}
