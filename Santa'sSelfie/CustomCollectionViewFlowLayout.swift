//
//  CustomCollectionViewFlowLayout.swift
//  Santa'sSelfie
//
//  Created by Roman Salazar on 11/4/16.
//  Copyright © 2016 Roman Salazar. All rights reserved.
//

import UIKit

class CustomCollectionViewFlowLayout:
UICollectionViewFlowLayout {
    override init() {
        super.init()
        minimumLineSpacing = 1
        minimumInteritemSpacing = 1
        scrollDirection = .vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var itemSize: CGSize {
        set {
            //
        } get {
            let numberOfCulumns: CGFloat = 2
            let itemWidth = ((self.collectionView?.frame)!.width - (numberOfCulumns - 1)) / numberOfCulumns
            return CGSize(width: itemWidth, height: itemWidth)
        }
    }

}
