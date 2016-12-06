//
//  StoreViewController.swift
//  Santa'sSelfie
//
//  Created by Roman Salazar on 12/6/16.
//  Copyright © 2016 Roman Salazar. All rights reserved.
//

import UIKit
import StoreKit

class StoreViewController: UIViewController {

    let products = [SKProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let profuct = SantaProducts.ExtendedSantaSelfiesPack
        print("number of prooducts\(profuct)")

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buyButtonPressed(_ sender: Any) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
