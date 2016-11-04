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
    
    var columns : Int
    let spacing: CGFloat = 1.0
    
    var screenWidth : CGFloat {
        return UIScreen.main.bounds.width
    }
    
    var itemWidth: CGFloat {
        let availableWidth = screenWidth - (CGFloat(self.columns) * spacing)
        return availableWidth / CGFloat(columns)
    }
    
    var itemHeight : CGFloat {
        return itemWidth * 2
    }

    init(columns: Int) {
        self.columns = columns
        
        super.init()
        
        self.minimumLineSpacing = spacing
        self.minimumInteritemSpacing = spacing
        
        self.itemSize - CGSize(width: itemWidth, height: itemHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
