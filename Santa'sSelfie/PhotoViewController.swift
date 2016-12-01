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
    
//    var scrollView: UIScrollView!
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
//        setupdetailImageView()
//        setupSlider()
        detailImageView.image = photoFromCamera
        setupNavigationBar()
        setupCollectionView()
//        setupImageOverlay()
//        setupScrollView()
//        configurePageControl()
        imageOverlay.image = santaImage
        
//        print(photoFromCamera)
//        setupDataSource()
//        addBorderToImage()
        
        
        
//        let image3DD = UIImage.init(named: "3DD")
//        let image3D = UIImage.init(named: "3D")
//        let image3 = UIImage.init(named: "3")
//        let image3B = UIImage.init(named: "3B")
//        let image3BB = UIImage.init(named: "3BB")
//
//        
//        let image4 = UIImage.init(named: "4")
//        let image4DD = UIImage.init(named: "4DD")
//        let image4D = UIImage.init(named: "4D")
//        let image4B = UIImage.init(named: "4B")
//        let image4BB = UIImage.init(named: "4BB")

        
        santasArray0 = [#imageLiteral(resourceName: "1DD.png"), #imageLiteral(resourceName: "1D.png"), #imageLiteral(resourceName: "1"), #imageLiteral(resourceName: "1B.png"), #imageLiteral(resourceName: "1BB.png")]
        santasArray1 = [#imageLiteral(resourceName: "2DD.png"), #imageLiteral(resourceName: "2D.png"), #imageLiteral(resourceName: "2.png"), #imageLiteral(resourceName: "2B.png"), #imageLiteral(resourceName: "2BB.png")]
        santasArray2 = [#imageLiteral(resourceName: "3DD"), #imageLiteral(resourceName: "3D"), #imageLiteral(resourceName: "3"), #imageLiteral(resourceName: "3B"), #imageLiteral(resourceName: "3BB")]
        santasArray3 = [#imageLiteral(resourceName: "4DD"), #imageLiteral(resourceName: "4D"), #imageLiteral(resourceName: "4"), #imageLiteral(resourceName: "4B"), #imageLiteral(resourceName: "4BB")]
//        santasArray2 = [image3DD!, image3D!, image3!, image3B!, image3BB!]
//        santasArray3 = [image4!, image4DD!, image4D!, image4B!, image4BB!]
//
//        switch GlobalVariable.selectedIndexPath {
//        case 0:
//            for i in 0..<santasArray0.count  {
//                let imageView = UIImageView()
//                imageView.image = santasArray0[i]
//                let xPosition = self.view.frame.width * CGFloat(i)
//                imageView.frame = CGRect(x: xPosition, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
//
//                imageView.contentMode = .scaleAspectFill
//                scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
//                scrollView.addSubview(imageView)
//            }
//        case 1:
//            for i in 0..<santasArray1.count  {
//                let imageView = UIImageView()
//                imageView.image = santasArray1[i]
//                let xPosition = self.view.frame.width * CGFloat(i)
//                imageView.frame = CGRect(x: xPosition, y: 30, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
//                
//                imageView.contentMode = .scaleAspectFill
//                scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
//                scrollView.addSubview(imageView)
//            }
//
//        case 2:
//            for i in 0..<santasArray2.count  {
//                let imageView = UIImageView()
//                imageView.image = santasArray2[i]
//                let xPosition = self.view.frame.width * CGFloat(i)
//                imageView.frame = CGRect(x: xPosition, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
//                
//                imageView.contentMode = .scaleAspectFill
//                scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
//                scrollView.addSubview(imageView)
//            }
//
//        case 3:
//            for i in 0..<santasArray3.count  {
//                let imageView = UIImageView()
//                imageView.image = santasArray3[i]
//                let xPosition = self.view.frame.width * CGFloat(i)
//                imageView.frame = CGRect(x: xPosition, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
//                
//                imageView.contentMode = .scaleAspectFill
//                scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
//                scrollView.addSubview(imageView)
//            }
//
//        default:
//            break
//        }
        
        print(self.collectionView.numberOfSections)
        print(self.collectionView.numberOfItems(inSection: 0))
        let index2 = NSIndexPath(item: 2, section: 0)
        collectionView.scrollToItem(at: index2 as IndexPath, at: .centeredHorizontally, animated: false)


    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        let index2 = NSIndexPath(item: 2, section: 0)
//        collectionView.scrollToItem(at: index2 as IndexPath, at: .centeredHorizontally, animated: false)
//    }
    
    func setupDataSource() {
//        let collectionView = chooseVC.selectedRow
//        print(collectionView)
    }
    
    func setupNavigationBar() {
        
//        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(PhotoViewController.userTappedShared(sender:)))
//        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(PhotoViewController.saveButtonPressed))
//        navigationItem.rightBarButtonItems = [saveButton, shareButton]
        navigationItem.title = "Edit"
    }

    func setupCollectionView() {
        let frame = CGRect(x: 0.0, y: view.bounds.height / 2, width: view.bounds.width, height: view.bounds.height / 2)
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .blue
        collectionView.isPagingEnabled = true
//        collectionView.isScrollEnabled = true
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

    
    // MARK : Configure page control!
//    func configurePageControl() {
//        
//        let greenPageControlColor = UIColor(red: 4/255, green: 179/255, blue: 120/255, alpha: 1.0)
//        
//        pageControl = UIPageControl(frame: CGRect(x: view.center.x - 100, y: view.frame.size.height - 50, width: 200, height: 50))
//        pageControl.numberOfPages = 5
//        pageControl.currentPage = 0
//        pageControl.pageIndicatorTintColor = greenPageControlColor
//        pageControl.currentPageIndicatorTintColor = UIColor.white
//        pageControl.addTarget(self, action: Selector(("changePage:")), for: .valueChanged)
//        pageControl.isHidden = false
//        view.addSubview(pageControl)
//    }
    
//    func changePage(sender: AnyObject) -> () {
//        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
//        scrollView.setContentOffset(CGPoint(x: x,y :0), animated: true)
//    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        
//        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
//        pageControl.currentPage = Int(pageNumber)
//    }
    
//    func setupImageOverlay() {
//        imageOverlay = UIImageView(frame: CGRect(x: 0.0, y: view.bounds.height / 2, width: view.bounds.width, height: view.bounds.height / 2))
//        imageOverlay.image = santaImage
//        imageOverlay.contentMode = .scaleAspectFill
//        view.addSubview(imageOverlay)
//    }

//    func saveButtonPressed(sender: Any) {
//        
//        // take screenshot
//        let photoTaken = santaImage
//        let finalImage = santaScreenShot(image: photoTaken)
//        savePhotoToLibrary(finalImage)
//    }
    
    // Share Photo
//    func userTappedShared(sender: Any) {
//        let photoTaken = santaImage
//        let finalImage = santaScreenShot(image: photoTaken)
//        self.displayActionShareSheet(shareContent: finalImage)
//    }
    
//    func displayActionShareSheet(shareContent: UIImage) {
//        let activityViewController = UIActivityViewController(activityItems: [shareContent as UIImage], applicationActivities: nil)
//        present(activityViewController, animated: true, completion: nil)
//    }
    
//    func santaScreenShot(image: UIImage) -> UIImage {
//        
//        // hide the page controller
//        pageControl.isHidden = true
//        
//        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, true, 0)
//        self.view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
//        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        
//        return image
//        
//    }
    
//    func showSaveViewAlert() {
//        //only apply the blur if the user hasn't disabled transparency effects
//        if !UIAccessibilityIsReduceTransparencyEnabled() {
//            self.view.backgroundColor = UIColor.clear
//            
//            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
//            let blurEffectView = UIVisualEffectView(effect: blurEffect)
//            //always fill the view
//            blurEffectView.frame = self.view.bounds
//            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            
//            let saveLabel = UILabel(frame: CGRect(x: view.center.x - 50, y: view.center.y - 50, width: 100, height: 50))
//            saveLabel.text = "Saved!"
//            saveLabel.textColor = .white
//            saveLabel.textAlignment = .center
//            saveLabel.font = UIFont.boldSystemFont(ofSize: 18)
//            
//            self.view.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
//            self.view.addSubview(saveLabel)
//            
//            blurEffectView.fadeIn()
//            saveLabel.fadeIn()
//            
//            blurEffectView.fadeOut()
//            saveLabel.fadeOut()
//        } else {
//            self.view.backgroundColor = UIColor.black
//        }
//    }

    func savePhotoToLibrary(_ image: UIImage) {
        let photoLibrary = PHPhotoLibrary.shared()
        photoLibrary.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }, completionHandler: { success, error in
            if !success { NSLog("error creating asset: \(error)") }
            else {
                DispatchQueue.main.async {
//                   self.showSaveViewAlert()
                    // hide the page controller
                    self.pageControl.isHidden = false
                }
            }
        })
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
        if indexPath.item == 2 { cell.backgroundColor = .white } else { cell.backgroundColor = .red }
        
        let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: cell.frame.width, height: cell.frame.height))
        imageView.contentMode = .scaleAspectFill
        let image = UIImage()
        imageView.image = image
        cell.contentView.addSubview(imageView)
        
        imageView.image = santasArray0[indexPath.row]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height/2)
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




