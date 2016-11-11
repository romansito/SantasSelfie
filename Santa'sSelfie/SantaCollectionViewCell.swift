//
//  SantaCollectionViewCell.swift
//  Santa'sSelfie
//
//  Created by Roman Salazar on 11/4/16.
//  Copyright © 2016 Roman Salazar. All rights reserved.
//

import UIKit

class SantaCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    var santaImage: UIImage! {
        didSet{
            self.imageView.image = self.santaImage
        }
    }
    
}
