//
//  PhtoViewController.swift
//  Santa'sSelfie
//
//  Created by Roman Salazar on 11/7/16.
//  Copyright © 2016 Roman Salazar. All rights reserved.
//

import UIKit
import Photos
import GoogleMobileAds

class PhotoViewController: UIViewController, GADInterstitialDelegate  {

    var chooseVC : ChoosePhotoViewController!
    
    @IBOutlet weak var detailImageView: UIImageView!
    var photoFromCamera: UIImage!

    var collectionView : UICollectionView!
    var imageOverlay = UIImageView()
    var santaImage = UIImage()
    
    var pageControl: UIPageControl!
    
    var mainSantasArrays = [UIImage]()
    var santasArray0 = [UIImage]()
    var santasArray1 = [UIImage]()
    var santasArray2 = [UIImage]()
    var santasArray3 = [UIImage]()
    
//    var interstitial: GADInterstitial!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        interstitial = createAndLoadInterstitial()
        detailImageView.image = photoFromCamera
        setupNavigationBar()
        setupCollectionView()
        configurePageControl()
        
        santasArray0 = [#imageLiteral(resourceName: "1DD.png"), #imageLiteral(resourceName: "1D.png"), #imageLiteral(resourceName: "1"), #imageLiteral(resourceName: "1B.png"), #imageLiteral(resourceName: "1BB.png")]
        santasArray1 = [#imageLiteral(resourceName: "2DD.png"), #imageLiteral(resourceName: "2D.png"), #imageLiteral(resourceName: "2.png"), #imageLiteral(resourceName: "2B.png"), #imageLiteral(resourceName: "2BB.png")]
        santasArray2 = [#imageLiteral(resourceName: "3DD"), #imageLiteral(resourceName: "3D"), #imageLiteral(resourceName: "3"), #imageLiteral(resourceName: "3B"), #imageLiteral(resourceName: "3BB")]
        santasArray3 = [#imageLiteral(resourceName: "4DD"), #imageLiteral(resourceName: "4D"), #imageLiteral(resourceName: "4"), #imageLiteral(resourceName: "4B"), #imageLiteral(resourceName: "4BB")]

        switch GlobalVariable.selectedIndexPath {
        case 0:
            mainSantasArrays = santasArray0
        case 1:
            mainSantasArrays = santasArray1
        case 2:
            mainSantasArrays = santasArray2
        case 3:
            mainSantasArrays = santasArray3
        default:
            break
        }

        print(self.collectionView.numberOfSections)
        print(self.collectionView.numberOfItems(inSection: 0))
        let index2 = NSIndexPath(item: 2, section: 0)
        collectionView.scrollToItem(at: index2 as IndexPath, at: .centeredHorizontally, animated: false)

    }
    
    func setupDataSource() {
        //
    }
    
    func setupNavigationBar() {
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(PhotoViewController.userTappedShared(sender:)))
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(PhotoViewController.saveButtonPressed))
        navigationItem.rightBarButtonItems = [saveButton, shareButton]
        navigationItem.title = "Edit"
    }

    func setupCollectionView() {
        let frame = CGRect(x: 0.0, y: view.bounds.height / 2 - 75, width: view.bounds.width, height: view.bounds.height / 2 + 125)
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.delegate = self
        collectionView.dataSource = self
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        view.addSubview(collectionView)
    }
    
//    func setupScrollView() {
//        let frame = CGRect(x: 0.0, y: view.bounds.height / 2 - 100, width: view.bounds.width, height: view.bounds.height / 2 + 100)
//        scrollView = UIScrollView(frame: frame)
//        scrollView.backgroundColor = .clear
//        scrollView.delegate = self
//        scrollView.isPagingEnabled = true
//        scrollView.showsHorizontalScrollIndicator = false
//        
//        view.addSubview(scrollView)
//    }

    
//     MARK : Configure page control!
    func configurePageControl() {
        
        let greenPageControlColor = UIColor(red: 4/255, green: 179/255, blue: 120/255, alpha: 1.0)
        
        pageControl = UIPageControl(frame: CGRect(x: view.center.x - 100, y: 84, width: 200, height: 50))
        pageControl.numberOfPages = 5
        pageControl.currentPage = 2
        pageControl.pageIndicatorTintColor = greenPageControlColor
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.addTarget(self, action: Selector(("changePage:")), for: .valueChanged)
        pageControl.isHidden = false
        view.addSubview(pageControl)
    }
    
    func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * collectionView.frame.size.width
        collectionView.setContentOffset(CGPoint(x: x,y :0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(collectionView.contentOffset.x / collectionView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
//    func setupImageOverlay() {
//        imageOverlay = UIImageView(frame: CGRect(x: 0.0, y: view.bounds.height / 2, width: view.bounds.width, height: view.bounds.height / 2))
//        imageOverlay.image = santaImage
//        imageOverlay.contentMode = .scaleAspectFill
//        view.addSubview(imageOverlay)
//    }

    func saveButtonPressed(sender: Any) {
        
        // take screenshot
        let photoTaken = santaImage
        let finalImage = santaScreenShot(image: photoTaken)
        savePhotoToLibrary(finalImage)
    }
    
//     Share Photo
    func userTappedShared(sender: Any) {
        let photoTaken = santaImage
        let finalImage = santaScreenShot(image: photoTaken)
        self.displayActionShareSheet(shareContent: finalImage)
    }
    
    func displayActionShareSheet(shareContent: UIImage) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as UIImage], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    func santaScreenShot(image: UIImage) -> UIImage {
        
        // hide the page controller
        pageControl.isHidden = true
        
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, true, 0)
        self.view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
        
    }
    
    func showSaveViewAlert() {
        //only apply the blur if the user hasn't disabled transparency effects
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.view.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            let saveLabel = UILabel(frame: CGRect(x: view.center.x - 50, y: view.center.y - 50, width: 100, height: 50))
            saveLabel.text = "Saved!"
            saveLabel.textColor = .white
            saveLabel.textAlignment = .center
            saveLabel.font = UIFont.boldSystemFont(ofSize: 18)
            
            self.view.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
            self.view.addSubview(saveLabel)
            
            blurEffectView.fadeIn()
            saveLabel.fadeIn()
            
            blurEffectView.fadeOut()
            saveLabel.fadeOut()
        } else {
            self.view.backgroundColor = UIColor.black
        }
    }

    func savePhotoToLibrary(_ image: UIImage) {
        let photoLibrary = PHPhotoLibrary.shared()
        photoLibrary.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }, completionHandler: { success, error in
            if !success { NSLog("error creating asset: \(error)") }
            else {
                DispatchQueue.main.async {
                    self.showAlertController()
//                   self.showSaveViewAlert()
                    // hide the page controller
                    self.pageControl.isHidden = false
                }
            }
        })
    }
    
    func showAlertController() {
        let alertController = UIAlertController(title: "Saved!", message: "", preferredStyle: .actionSheet)
        
        let subview1 = alertController.view.subviews.first! as UIView
        let subview2 = subview1.subviews.first! as UIView
        let view = subview2.subviews.first! as UIView
        
        subview2.backgroundColor = .white
        view.backgroundColor = .white
        view.tintColor = .white
        alertController.view.tintColor = UIColor.lightText
        view.layer.cornerRadius = 10.0
        
        alertController.setValue(NSAttributedString(string: "Saved!", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 20, weight: 0),NSForegroundColorAttributeName : UIColor.black]), forKey: "attributedTitle")

        let takePhotoAction = UIAlertAction(title: "Take an other photo", style: .default, handler: nil)
        let goToLibraryAction = UIAlertAction(title: "Go to library", style: .default, handler: nil)
        
        alertController.addAction(takePhotoAction)
        alertController.addAction(goToLibraryAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
//    func createAndLoadInterstitial() {
//        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3020802165335227/6638416397")
//        let request = GADRequest()
//        interstitial.load(request)
//    }

    
// MARK: Create a interstitial
//    func createAndLoadInterstitial() -> GADInterstitial {
//        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3020802165335227/6638416397")
//        interstitial.delegate = self
//        interstitial.load(GADRequest())
//        return interstitial
//    }
    
//    func alertView(alertView: UIAlertView, willDismissWithButtonIndex buttonIndex: Int) {
//        if interstitial.isReady {
//            interstitial.present(fromRootViewController: self)
//        } else {
//            print("Ad wasn't ready")
//        }
//        // Give user the option to start the next game.
//    }

//    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
//        interstitial = createAndLoadInterstitial()
//    }
    
}

extension PhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        cell.backgroundColor = .clear
        
        let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: cell.frame.width, height: cell.frame.height))
        imageView.contentMode = .scaleAspectFill
        let image = UIImage()
        imageView.image = image
        cell.contentView.addSubview(imageView)
        
        imageView.image = mainSantasArrays[indexPath.row]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.bounds.width, height: self.collectionView.bounds.height)
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return CGSize(width: self.view.frame.width, height: self.view.frame.height/2)
//    }
    
}

extension UIView {
    func fadeIn(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    /**
     Fade out a view with a duration
     
     - parameter duration: custom animation duration
     */
    func fadeOut(withDuration duration: TimeInterval = 2.5) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
}




