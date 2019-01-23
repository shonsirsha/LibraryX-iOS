//
//  MainVC.swift
//  CanteenX
//
//  Created by Sean Saoirse on 22/01/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import UIKit

class MainVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
   var names = ["Mom's Cook", "Efata", "Test"]
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myTableView.dataSource = self
        myTableView.delegate = self
        self.myTableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = myTableView.dequeueReusableCell(withIdentifier: "mycell") as? MainCell else {return UITableViewCell()}
        let name = names[indexPath.row]
        cell.configCell(name: name)
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
}
