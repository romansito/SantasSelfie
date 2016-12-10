//
//  MenuTableViewController.swift
//  Santa'sSelfie
//
//  Created by Roman Salazar on 12/2/16.
//  Copyright © 2016 Roman Salazar. All rights reserved.
//

import UIKit


class MenuTableViewController: UITableViewController {
    var menuItems = ["Home", "Contact", "Review App"]
//    var currentItem = "Home"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = .white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            UIApplication.shared.openURL(NSURL(string : "https://itunes.apple.com/us/app/santas-selfie/id1180781708?mt=8")! as URL)
        } else if indexPath.row == 1 {
            UIApplication.shared.openURL(NSURL(string : "https://www.romansalazar.com/#/santas-selfie/")! as URL)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MenuTableViewCell
        cell.backgroundColor = .white
        cell.titleLabel.text = menuItems[indexPath.row]
        cell.titleLabel.textColor = .black

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Menu"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let menuTableViewController = segue.source as! MenuTableViewController
        if let selectedRow = menuTableViewController.tableView.indexPathForSelectedRow?.row {
//            currentItem = menuItems[selectedRow]
        }
    }
    
    
    
}
