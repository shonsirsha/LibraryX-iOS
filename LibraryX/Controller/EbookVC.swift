//
//  EbookVC.swift
//  libraryX
//
//  Created by Sean Saoirse on 26/02/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import UIKit

class EbookVC: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    var eBookArr = [EbookDetailCell]()
    var currentBookArr = [EbookDetailCell]()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var allEbooksLabel: UILabel!
    var allEbookCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        self.tableView.tableFooterView = UIView()
        self.searchBar.backgroundImage = UIImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DataService.instance.getAllEbooks { (returnedEbooks) in
            self.eBookArr = returnedEbooks
            self.currentBookArr = self.eBookArr
            self.allEbooksLabel.text = "All eBooks (\(self.eBookArr.count))"
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentBookArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ebookcell") as? EbookCell else {return UITableViewCell()}
        let eachBookObj = currentBookArr[indexPath.row]
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ixPath = tableView.indexPathForSelectedRow{
            if segue.identifier == "toSingleEbookVC"{
                if let singleEbookVC = segue.destination as? SingleEbookVC {
                    singleEbookVC.authorName = currentBookArr[ixPath.row].authorName
                    singleEbookVC.bookTitle = currentBookArr[ixPath.row].bookTitle
                    singleEbookVC.yearReleased = currentBookArr[ixPath.row].year
                    singleEbookVC.imgTitleInMS = currentBookArr[ixPath.row].imgTitle
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toSingleEbookVC", sender: self)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentBookArr = eBookArr
            tableView.reloadData()
            allEbooksLabel.text = "All books (\(currentBookArr.count))"
            return
        }
        
        currentBookArr = eBookArr.filter({ (returnedBook) -> Bool in
            guard let text = searchBar.text else {return false}
            return returnedBook.bookTitle.lowercased().contains(text.lowercased())
        })
        tableView.reloadData()
        allEbooksLabel.text = "All books (\(currentBookArr.count))"
    }
    

}
