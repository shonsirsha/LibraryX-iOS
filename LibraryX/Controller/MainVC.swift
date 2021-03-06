//
//  MainVC.swift
//  CanteenX
//
//  Created by Sean Saoirse on 22/01/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import UIKit
import Firebase
var currentFilter = ""
var toMyAccVC = false

class MainVC: UIViewController,UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate{
    
     var bookArr = [BookDetailForCell]()
    var currentBookArr = [BookDetailForCell]()
  
    @IBOutlet weak var sortedByLabel: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var toScannerVCBtn: UIButton!
    var bookTotal = 0
    
    @IBOutlet weak var allBookLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.placeholder = "Search.."
        if currentFilter == ""{
            currentFilter = "time"
        }
        
        #if Client
            toScannerVCBtn.isHidden = true
        #else
            toScannerVCBtn.isHidden = false
        #endif

        myTableView.dataSource = self
        myTableView.delegate = self
        searchBar.delegate = self

        self.myTableView.tableFooterView = UIView()
        self.searchBar.backgroundImage = UIImage()
      
    }
    
    @IBAction func filterBtn(_ sender: Any) {
        guard let viewRect = sender as? UIView else{
            return
        }
        let alert = UIAlertController(title: "Book Sort", message: "Sort books by", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Newest addition", style: .default) { _ in
            currentFilter = "time"
            self.sortedByLabel.text = "- Sorted by newest addition"
            DataService.instance.getAllBooks(sortedBy: currentFilter) { (returnedEachBookObj) in
                self.bookArr = returnedEachBookObj
                self.currentBookArr = self.bookArr
                self.bookTotal = self.bookArr.count
                self.myTableView.reloadData()
                self.allBookLabel.text = "All books (" + "\(self.bookTotal))"
            }
        })
        alert.addAction(UIAlertAction(title: "Title (A-Z)", style: .default) { _ in
            currentFilter = "title"
            self.sortedByLabel.text = "- Sorted by title"
            DataService.instance.getAllBooks(sortedBy: currentFilter) { (returnedEachBookObj) in
                self.bookArr = returnedEachBookObj
                self.currentBookArr = self.bookArr
                self.bookTotal = self.bookArr.count
                self.myTableView.reloadData()
                self.allBookLabel.text = "All books (" + "\(self.bookTotal))"
            }
                    })
        
        alert.addAction(UIAlertAction(title: "Author's name (A-Z)", style: .default) { _ in
            currentFilter = "author"
            self.sortedByLabel.text = "- Sorted by author's name"
            DataService.instance.getAllBooks(sortedBy: currentFilter) { (returnedEachBookObj) in
                self.bookArr = returnedEachBookObj
                self.currentBookArr = self.bookArr
                self.bookTotal = self.bookArr.count
                self.myTableView.reloadData()
                self.allBookLabel.text = "All books (" + "\(self.bookTotal))"
            }
        })
        
        alert.addAction(UIAlertAction(title: "Year released", style: .default) { _ in
            currentFilter = "year"
            self.sortedByLabel.text = "- Sorted by year released"
            DataService.instance.getAllBooks(sortedBy: currentFilter) { (returnedEachBookObj) in
                self.bookArr = returnedEachBookObj
                self.currentBookArr = self.bookArr
                self.bookTotal = self.bookArr.count
                self.myTableView.reloadData()
                self.allBookLabel.text = "All books (" + "\(self.bookTotal))"
            }
        })
        
        alert.addAction(UIAlertAction(title: "Genre(s) (A-Z)", style: .default) { _ in
            currentFilter = "genre"
            self.sortedByLabel.text = "- Sorted by genre(s)"
            DataService.instance.getAllBooks(sortedBy: currentFilter) { (returnedEachBookObj) in
                self.bookArr = returnedEachBookObj
                self.currentBookArr = self.bookArr
                self.bookTotal = self.bookArr.count
                self.myTableView.reloadData()
                self.allBookLabel.text = "All books (" + "\(self.bookTotal))"
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            
        })
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let presenter = alert.popoverPresentationController {
                presenter.sourceView = viewRect;
                presenter.sourceRect = viewRect.bounds;
            }
            
            
            present(alert, animated: true, completion: nil)
        }else{
            present(alert, animated: true)
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       
        if toMyAccVC == true || toScanVCReturn == true{
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc: UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
            vc.selectedIndex = 2
            self.present(vc, animated: false, completion: nil)
        }
        
        if Auth.auth().currentUser == nil{
            
        }else{
            DataService.instance.checkIfUserDeleted(uid: (Auth.auth().currentUser?.uid)!) { (returnedPw) in
                if returnedPw == "non"{
                    do{
                        try Auth.auth().signOut()
                        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "ScanToLoginVC") as? ScanToLoginVC
                        self.present(loginVC!, animated: true, completion: nil)
                    }catch{
                        print(error)
                    }
                }
            }
        }
        
        
        DataService.instance.getAllBooks(sortedBy: currentFilter) { (returnedEachBookObj) in
            self.bookArr = returnedEachBookObj
            self.currentBookArr = self.bookArr
            self.bookTotal = self.bookArr.count
            self.myTableView.reloadData()
            self.allBookLabel.text = "All books (" + "\(self.bookTotal))"
        }
        
    }
    
   

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentBookArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = myTableView.dequeueReusableCell(withIdentifier: "mycell") as? MainCell else {return UITableViewCell()}
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
    
  
    
    @IBAction func toScanVC(_ sender: Any) {
        performSegue(withIdentifier: "toScannerVC", sender: self)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentBookArr = bookArr
            myTableView.reloadData()
            allBookLabel.text = "All books (\(currentBookArr.count))"
            return
        }

            currentBookArr = bookArr.filter({ (returnedBook) -> Bool in
                guard let text = searchBar.text else {return false}
                var arr = ""
                
                arr += "\(returnedBook.bookTitle) \(returnedBook.authorName) \(returnedBook.year) \(returnedBook.genre1) \(returnedBook.genre2) \(returnedBook.genre3)"
                
                return arr.lowercased().contains(text.lowercased())
                
            })
            
            myTableView.reloadData()
            allBookLabel.text = "All books (\(currentBookArr.count))"

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ixPath = myTableView.indexPathForSelectedRow{
            if segue.identifier == "toSingleBookVC"{
                if let singleBookVC = segue.destination as? SingleBookVC {
                    singleBookVC.imgTitleinMs = currentBookArr[ixPath.row].imgTitle
                    singleBookVC.bookTitle = currentBookArr[ixPath.row].bookTitle
                    singleBookVC.year = currentBookArr[ixPath.row].year
                    singleBookVC.authorName = currentBookArr[ixPath.row].authorName
                }
            }
        }
    }
    

    

 
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toSingleBookVC", sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
  
}
