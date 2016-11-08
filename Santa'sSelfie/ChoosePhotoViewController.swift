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
        
    var santasSelfies = [String]()
//        {
//        didSet {
//            self.collectionView.reloadData()
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSetup()
        
//        setupDataSource()
         }

//    func setupDataSource() {
//        for i in 0...3 {
//            guard let image = UIImage(named: "\(i)") else { return }
//            self.santasSelfies.append(image)
//        }
//    }

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
        
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SantaCollectionViewCell.identifier(), for: indexPath) as? SantaCollectionViewCell
//        cell?.santaImage = UIImage(named: "0")
        cell?.backgroundColor = .white
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
}

extension ChoosePhotoViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueToCameraVC", sender: nil)
    }
    
}
