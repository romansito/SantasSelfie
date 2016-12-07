//
//  ChoosePhotoViewController.swift
//  Santa'sSelfie
//
//  Created by Roman Salazar on 11/4/16.
//  Copyright © 2016 Roman Salazar. All rights reserved.
//

import UIKit
import GoogleMobileAds

struct GlobalVariable {
    static var selectedIndexPath = 0
}

class ChoosePhotoViewController: UIViewController {
    
    var photoVC = PhotoViewController()
    var menuTransitionManager = MenuTransitionManager()
    
    

    @IBOutlet weak var collectionView: UICollectionView!
    var cell: SantaCollectionViewCell!
    
    var santasSelfies = [UIImage]()
        {
        didSet {
            self.collectionView.reloadData()
        }
    }

    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var cellLabels: UILabel!
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        let sourceController = segue.source as! MenuTableViewController
//        self.title = sourceController.currentItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewSetup()
        setupBasicImageArray()
//        setupExtendedImageArray()
        setupNavigationBar()

        bannerView.adUnitID = "ca-app-pub-3020802165335227/3355375994"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        NotificationCenter.default.addObserver(self, selector: "addExtraImagePack", name: NSNotification.Name(rawValue: notificationsConstantName), object: nil)
    }
    
    func addExtraImagePack() {
        for i in 5...8 {
            guard let image = UIImage(named: "\(i)") else { return }
            self.santasSelfies.append(image)
        }
    }

    func setupNavigationBar() {
        let myGreenColor = UIColor(red: 10/255, green: 122/255, blue: 60/255, alpha: 1.0)
        view.backgroundColor = .red
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = myGreenColor
        
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "menuIcon"), for: UIControlState.normal)
    }
    
    func setupBasicImageArray() {
        for i in 1...4 {
            guard let image = UIImage(named: "\(i)") else { return }
            self.santasSelfies.append(image)
        } 
    }
    
//    func setupExtendedImageArray() {
//      
//        for i in 5...8 {
//            guard let image = UIImage(named: "\(i)") else { return }
//            self.santasSelfies.append(image)
//        }
//    }
    

    func collectionViewSetup() {
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = CustomCollectionViewFlowLayout()
    }

}


extension ChoosePhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: SantaCollectionViewCell.identifier(), for: indexPath) as! SantaCollectionViewCell
        cell.santaImage = santasSelfies[indexPath.row]
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 2

        if indexPath.row == 3 {
            cell.santaCellLabels.text = "Landscape"
        } else {
            cell.santaCellLabels.text = "Portrait"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueToCameraVC", sender: nil)
        let indexPathRow = indexPath.row
        GlobalVariable.selectedIndexPath = indexPathRow
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return santasSelfies.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        if segue.identifier == "segueToCameraVC" {
//            let indexPaths = self.collectionView.indexPathsForSelectedItems!
//            let indexPath = indexPaths[0] as NSIndexPath
//            
//            let nextVC = segue.destination as! CameraViewController
//            nextVC.santaImage = self.santasSelfies[indexPath.row]
//        } else {
//            let menuTableViewController = segue.destination as! MenuTableViewController
//            //        menuTableViewController.currentItem = self.title!
//            menuTableViewController.transitioningDelegate = self.menuTransitionManager
//            self.menuTransitionManager.delegate = self
//        }
    }
    
}

extension ChoosePhotoViewController: MenuTransitionManagerDelegate {
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }

}

