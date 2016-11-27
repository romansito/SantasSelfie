//
//  ChoosePhotoViewController.swift
//  Santa'sSelfie
//
//  Created by Roman Salazar on 11/4/16.
//  Copyright © 2016 Roman Salazar. All rights reserved.
//

import UIKit
import GoogleMobileAds


protocol ChoosePhotoViewControllerIndexPathSelectedDelegate: class {
    func numberOfIndexPathSelected(indexSelected: Int)
}

class ChoosePhotoViewController: UIViewController {
    
    weak var delegate : ChoosePhotoViewControllerIndexPathSelectedDelegate?
    var photoVC = PhotoViewController()

    @IBOutlet weak var collectionView: UICollectionView!
    var cell: SantaCollectionViewCell!
    var selectedRow = 0
        
    var santasSelfies = [UIImage]()
        {
        didSet {
            self.collectionView.reloadData()
        }
    }

    @IBOutlet weak var bannerView: GADBannerView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        photoVC.delegate = self
        
        collectionViewSetup()
        setupDataSource()
        setupNavigationBar()

        bannerView.adUnitID = "ca-app-pub-3020802165335227/3355375994"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        print("NUMBER OF SELFIES")
        print(santasSelfies.count)
        
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
        
        for i in 1...4 {
            guard let image = UIImage(named: "\(i)") else { return }
            self.santasSelfies.append(image)
        } 
    }

    func collectionViewSetup() {
        //        collectionView.backgroundColor = .white
        collectionView.backgroundColor = UIColor.init(white: 1.0, alpha: 0.0)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = CustomCollectionViewFlowLayout()
    }
    
}


extension ChoosePhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: SantaCollectionViewCell.identifier(), for: indexPath) as! SantaCollectionViewCell
        cell.santaImage = santasSelfies[indexPath.row]
        cell.backgroundColor = .red
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let delegate = self.delegate else { return }
//        let selectedIndex = indexPath.row
//        delegate?.numberOfIndexPathSelected(indexSelected: selectedIndex)
        performSegue(withIdentifier: "segueToCameraVC", sender: nil)
        selectedRow = indexPath.row
//        delegate?.numberOfIndexPathSelected(indexSelected: selectedIndex)
        print(selectedRow)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return santasSelfies.count
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueToCameraVC" {
            
            let indexPaths = self.collectionView.indexPathsForSelectedItems!
            let indexPath = indexPaths[0] as NSIndexPath
            
            let nextVC = segue.destination as! CameraViewController
            nextVC.santaImage = self.santasSelfies[indexPath.row]
        }
    }
    
}

