//
//  ChoosePhotoViewController.swift
//  Santa'sSelfie
//
//  Created by Roman Salazar on 11/4/16.
//  Copyright © 2016 Roman Salazar. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ChoosePhotoViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var cell: SantaCollectionViewCell!
        
    var santasSelfies = [UIImage]()
        {
        didSet {
            self.collectionView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionViewSetup()
        setupDataSource()
        setupNavigationBar()
    }

    func setupNavigationBar() {
        let myGreenColor = UIColor(red: 24/255, green: 96/255, blue: 39/255, alpha: 1.0)

        view.backgroundColor = .red
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = myGreenColor
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    func setupDataSource() {
        for i in 0...5 {
            guard let image = UIImage(named: "\(i)") else { return }
            self.santasSelfies.append(image)
        } 
    }

    func collectionViewSetup() {
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = CustomCollectionViewFlowLayout()
    }
    
}


extension ChoosePhotoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: SantaCollectionViewCell.identifier(), for: indexPath) as! SantaCollectionViewCell
        cell.santaImage = santasSelfies[indexPath.row]
        cell.backgroundColor = .red
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return santasSelfies.count
    }
    
}

extension ChoosePhotoViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            performSegue(withIdentifier: "segueToCameraVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueToCameraVC" {
    
            let indexPaths = self.collectionView.indexPathsForSelectedItems!
            let indexPath = indexPaths[0] as NSIndexPath
            
            let nextVC = segue.destination as! CameraViewController
            print(self.santasSelfies[indexPath.row])
            nextVC.santaImage = self.santasSelfies[indexPath.row]

        }
    }
    
}
