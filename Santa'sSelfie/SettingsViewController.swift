//
//  SettingsViewController.swift
//  Santa'sSelfie
//
//  Created by Roman Salazar on 11/22/16.
//  Copyright © 2016 Roman Salazar. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    let cellsArray = ["Contact Us"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        bannerView.adUnitID = "ca-app-pub-3020802165335227/6308842392"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())

    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cellsArray[indexPath.row]
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
