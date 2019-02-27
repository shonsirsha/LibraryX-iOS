//
//  SavedEbookVC.swift
//  LibraryX
//
//  Created by Sean Saoirse on 27/02/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import UIKit
import Firebase


class SavedEbookVC: UIViewController,UITableViewDataSource, UITableViewDelegate{
 
    var eBookArr = [EbookDetailCell]()

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var myTableView: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.isHidden = true
        myTableView.isHidden = true
        myTableView.dataSource = self
        myTableView.delegate = self
        self.myTableView.tableFooterView = UIView()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        DataService.instance.checkIfHaveSavedEbooks(uid: (Auth.auth().currentUser?.uid)!) { (returnedStatus) in
            if returnedStatus == "yes"{
                self.statusLabel.isHidden = true
                self.myTableView.isHidden = false
                DataService.instance.getSavedEbooks(uid: (Auth.auth().currentUser?.uid)!, handler: { (returnedSavedEbookArr) in
                    self.eBookArr = returnedSavedEbookArr
                    self.myTableView.reloadData()
                })
            }else{
                self.statusLabel.isHidden = false
                self.myTableView.isHidden = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eBookArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ebookcell2") as? EbookCell else {return UITableViewCell()}
        let eachBookObj = eBookArr[indexPath.row]
        var genresArr = [String]()
        
        genresArr.append(eachBookObj.genre1)
        genresArr.append(eachBookObj.genre2)
        genresArr.append(eachBookObj.genre3)
        print(genresArr)
        genresArr = genresArr.filter{!$0.isEmpty}
        
        let stringGenres = genresArr.joined(separator: ", ")
        cell.configCell(bookTitle: eachBookObj.bookTitle, authorName: "Author: \(eachBookObj.authorName)", genre: "Genres: \(stringGenres)", year: "Year released: \(eachBookObj.year)",imgTitleInMS: eachBookObj.imgTitle)
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toEbookOverview2", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if let ixPath = myTableView.indexPathForSelectedRow{
        if segue.identifier == "toEbookOverview2"{
            if let singleEbookVC = segue.destination as? SingleEbookVC {
                singleEbookVC.authorName = eBookArr[ixPath.row].authorName
                singleEbookVC.bookTitle = eBookArr[ixPath.row].bookTitle
                singleEbookVC.yearReleased = eBookArr[ixPath.row].year
                singleEbookVC.imgTitleInMS = eBookArr[ixPath.row].imgTitle
            }
        }
    }
    }
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
