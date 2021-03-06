//
//  ProfileVC.swift
//  LibraryX
//
//  Created by Sean Saoirse on 23/01/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import UIKit
import Firebase


var toScanVCReturn = false
class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

   
    var bookArr = [BookTitleForProfileCell]()

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var noActLabel: UILabel!
    @IBOutlet weak var topBlock: UIView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        noActLabel.isHidden = true
        myTableView.dataSource = self
        myTableView.delegate = self
        self.myTableView.tableFooterView = UIView()
        
        fullNameLabel.text = "Loading..."
        emailLabel.text = "Loading..."
       topBlock.layer.cornerRadius = topBlock.frame.height * 1/10
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if toMyAccVC == true{
            toMyAccVC = false
            print(toMyAccVC)
            let alert = UIAlertController(title: "Thank you! 😉📚", message: "Don't forget to sign out from your account!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction) in
                print("No")
            }))
            
            alert.addAction(UIAlertAction(title: "Sign me out now", style: .default, handler: { (action:UIAlertAction) in
                do{
                    try Auth.auth().signOut()
                    let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "ScanToLoginVC") as? ScanToLoginVC
                    self.present(loginVC!, animated: true, completion: nil)
                }catch{
                    print(error)
                }        }))
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
        
        if toScanVCReturn == true{
            toScanVCReturn = false
            performSegue(withIdentifier: "toScannerVC2", sender: self)
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
            DataService.instance.getFullName(uid: (Auth.auth().currentUser?.uid)!) { (returnedFullName) in
                self.fullNameLabel.text = returnedFullName
            }
            DataService.instance.getEmail(uid: (Auth.auth().currentUser?.uid)!) { (returnedEmail) in
                self.emailLabel.text = returnedEmail
            }
            
            
            DataService.instance.everBorrow(uid: (Auth.auth().currentUser?.uid)!) { (ever) in
                if ever == true{
                    self.myTableView.isHidden = false
                    self.noActLabel.isHidden = true
                    DataService.instance.get10RecentActivities(uid: (Auth.auth().currentUser?.uid)!) { (returnedBookTitle) in
                        self.bookArr = returnedBookTitle
                        self.myTableView.reloadData()
                    }
                }else{
                    self.myTableView.isHidden = true
                    self.noActLabel.isHidden = false
                    print("never borrowed anyth")
                }
            }
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = myTableView.dequeueReusableCell(withIdentifier: "myCell") as? ProfileBookCell else {return UITableViewCell()}
        let eachBookTitle = bookArr[indexPath.row].bookTitle
        let opened = bookArr[indexPath.row].opened
        let startDate = bookArr[indexPath.row].start
        let untilDate = bookArr[indexPath.row].until
        let status = bookArr[indexPath.row].status
        let actualReturned = bookArr[indexPath.row].actualReturned
        cell.configCell(bookTitle: eachBookTitle, opened: opened, start: startDate, until: untilDate, status: status, actualReturned: actualReturned)
        
        
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
            if segue.identifier == "toMyBookSingleVC"{
                if let myBookSingleVC = segue.destination as? MyBookSingleVC {
                    myBookSingleVC.imgTitleInMS = bookArr[ixPath.row].imgTitleInMS
                    myBookSingleVC.startBorrowDate = bookArr[ixPath.row].start
                    
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toMyBookSingleVC", sender: self)
    }

    
    @IBAction func logOutBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action:UIAlertAction) in
            print("No")
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action:UIAlertAction) in
            do{
                try Auth.auth().signOut()
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "ScanToLoginVC") as? ScanToLoginVC
                self.present(loginVC!, animated: true, completion: nil)
            }catch{
                print(error)
            }        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
