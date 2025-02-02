//
//  SantaCollectionViewCell.swift
//  Santa'sSelfie
//
//  Created by Roman Salazar on 11/4/16.
//  Copyright © 2016 Roman Salazar. All rights reserved.
//

import UIKit

class SantaCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var santaImageView: UIImageView!
    @IBOutlet weak var santaCellLabels: UILabel!
    
    var santaImage: UIImage! {
        didSet{
            self.santaImageView.image = self.santaImage
        }
    }
    
}
