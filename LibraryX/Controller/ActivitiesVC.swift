//
//  ActivitiesVC.swift
//  LibraryX
//
//  Created by Sean Saoirse on 31/01/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
//myCell
class ActivitiesVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var bookArr = [BookTitleForProfileCell]()

  //
    
    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self
        self.myTableView.tableFooterView = UIView()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if toScanVCReturn == true{
            dismiss(animated: true, completion: nil)
        }
        DataService.instance.everBorrow(uid: (Auth.auth().currentUser?.uid)!) { (ever) in
            if ever == true{
                DataService.instance.getAllActivities(uid: (Auth.auth().currentUser?.uid)!, handler: { (returnedActivities) in
                    self.bookArr = returnedActivities
                    self.myTableView.reloadData()
                })
            }else{
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = myTableView.dequeueReusableCell(withIdentifier: "activitiesCell") as? ActivitiesCell else {return UITableViewCell()}
        
        let eachBookTitle = bookArr[indexPath.row].bookTitle
        let startDate = bookArr[indexPath.row].start
        let untilDate = bookArr[indexPath.row].until
        let status = bookArr[indexPath.row].status
        let actualReturned = bookArr[indexPath.row].actualReturned
        let imgTitleInMS = bookArr[indexPath.row].imgTitleInMS
        
        cell.configCell(bookTitle: eachBookTitle, start: startDate, until: untilDate, imgTitleInMS: imgTitleInMS, actualReturned: actualReturned, status: status)
        
        cell.contentView.layoutMargins.top = 40
        cell.contentView.layoutMargins.bottom = 40
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ixPath = myTableView.indexPathForSelectedRow{
            if segue.identifier == "toMyBookSingleVC2"{
                if let myBookSingleVC = segue.destination as? MyBookSingleVC {
                    myBookSingleVC.imgTitleInMS = bookArr[ixPath.row].imgTitleInMS
                    myBookSingleVC.startBorrowDate = bookArr[ixPath.row].start
                    
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toMyBookSingleVC2", sender: self)
    }
    
    
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    


}
