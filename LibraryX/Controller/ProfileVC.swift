//
//  ProfileVC.swift
//  LibraryX
//
//  Created by Sean Saoirse on 23/01/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

   
    var bookArr = [BookTitleForProfileCell]()

    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var topBlock: UIView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var editProfileBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self
        self.myTableView.tableFooterView = UIView()
        
        
        
        editProfileBtn.layer.cornerRadius = 8
        fullNameLabel.text = "Loading..."
        emailLabel.text = "Loading..."
       topBlock.layer.cornerRadius = topBlock.frame.height * 1/10
    
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = myTableView.dequeueReusableCell(withIdentifier: "myCell") as? ProfileBookCell else {return UITableViewCell()}
        let eachBookTitle = bookArr[indexPath.row]
       cell.configCell(bookTitle: eachBookTitle.bookTitle)
        
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
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        toMyAccVC = false
        DataService.instance.getFullName(uid: (Auth.auth().currentUser?.uid)!) { (returnedFullName) in
            self.fullNameLabel.text = returnedFullName
        }
        DataService.instance.getEmail(uid: (Auth.auth().currentUser?.uid)!) { (returnedEmail) in
            self.emailLabel.text = returnedEmail
        }
       
        
        DataService.instance.everBorrow(uid: (Auth.auth().currentUser?.uid)!) { (ever) in
            if ever == true{
                DataService.instance.getTop10BorrowedBooks(uid: (Auth.auth().currentUser?.uid)!) { (returnedBookTitle) in
                    self.bookArr = returnedBookTitle
                    self.myTableView.reloadData()
                }

            }else{
                print("never borrowed anyth")
            }
        }
     
        
       
    }

    @IBAction func logoutBtn(_ sender: Any) {
        
       let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action:UIAlertAction) in
            print("No")
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action:UIAlertAction) in
            do{
                try Auth.auth().signOut()
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
                self.present(loginVC!, animated: true, completion: nil)
            }catch{
                print(error)
            }        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

