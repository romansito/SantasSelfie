//
//  ChoosePhotoViewController.swift
//  Santa'sSelfie
//
//  Created by Roman Salazar on 11/4/16.
//  Copyright © 2016 Roman Salazar. All rights reserved.
//

import UIKit

class ChoosePhotoViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionViewSetup()
    }


    func collectionViewSetup() {
        collectionView.backgroundColor = .red
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = CustomCollectionViewFlowLayout()
        collectionView.register(SantaCollectionViewCell.self, forCellWithReuseIdentifier: SantaCollectionViewCell.identifier())
    }

}


extension ChoosePhotoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SantaCollectionViewCell.identifier(), for: indexPath) as! SantaCollectionViewCell
        cell.backgroundColor = .white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    
}

extension ChoosePhotoViewController: UICollectionViewDelegate {
    
}
