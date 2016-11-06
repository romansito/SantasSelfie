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
//    var columns : Int
//    let spacing: CGFloat = 1.0
//    
//    var screenWidth : CGFloat {
//        return UIScreen.main.bounds.width
//    }
//    
//    var itemWidth: CGFloat {
//        let availableWidth = screenWidth - (CGFloat(self.columns) * spacing)
//        return availableWidth / CGFloat(columns)
//    }
//    
//    var itemHeight : CGFloat {
//        return itemWidth * 1.25
//    }
//
//    init(columns: Int) {
//        self.columns = columns
//        
//        super.init()
//        
//        self.minimumLineSpacing = spacing
//        self.minimumInteritemSpacing = spacing
//        
//        self.itemSize = CGSize(width: itemWidth, height: itemHeight)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

}
