//
//  PhtoViewController.swift
//  Santa'sSelfie
//
//  Created by Roman Salazar on 11/7/16.
//  Copyright © 2016 Roman Salazar. All rights reserved.
//

import UIKit
import Photos
let esposureFilter = "CIExposureAdjust"

class PhotoViewController: UIViewController, ChoosePhotoViewControllerIndexPathSelectedDelegate  {

    var chooseVC : ChoosePhotoViewController!
    
    @IBOutlet weak var detailImageView: UIImageView!
    var photoFromCamera: UIImage!

    var collectionView : UICollectionView!
    var imageOverlay = UIImageView()
    var santaImage = UIImage()
    
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    
    var numberOfCell = Int()
    var santasArray = [UIImage]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupdetailImageView()
//        setupSlider()
        detailImageView.image = photoFromCamera
        setupNavigationBar()
//        setupCollectionView()
//        setupImageOverlay()
        setupScrollView()
        configurePageControl()
        imageOverlay.image = santaImage
        
//        print(photoFromCamera)
//        setupDataSource()
//        addBorderToImage()
        
        chooseVC = ChoosePhotoViewController()
        numberOfCell = chooseVC.selectedRow
        print(numberOfCell)
        
        santasArray = [#imageLiteral(resourceName: "1DD.png"), #imageLiteral(resourceName: "1D.png"), #imageLiteral(resourceName: "1"), #imageLiteral(resourceName: "1B.png"), #imageLiteral(resourceName: "1BB.png")]
        
        for i in 0..<santasArray.count  {
            let imageView = UIImageView()
            imageView.image = santasArray[i]
            let xPosition = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
            
            imageView.contentMode = .scaleAspectFill
            scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
            scrollView.addSubview(imageView)
        }
    }
    
    func setupDataSource() {
        let collectionView = chooseVC.selectedRow
        print(collectionView)
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(PhotoViewController.saveButtonPressed))
        navigationItem.title = "Edit"        
    }
    
    func setupCollectionView() {
        let frame = CGRect(x: 0.0, y: view.bounds.height / 2, width: view.bounds.width, height: view.bounds.height / 2)
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .blue
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        layout.scrollDirection = .horizontal
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        view.addSubview(collectionView)
    }
    
    func setupScrollView() {
        let frame = CGRect(x: 0.0, y: view.bounds.height / 2 - 100, width: view.bounds.width, height: view.bounds.height / 2 + 100)
        scrollView = UIScrollView(frame: frame)
        scrollView.backgroundColor = .clear
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        view.addSubview(scrollView)
    }
    
    // MARK : Configure page control!
    func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: view.center.x - 100, y: view.frame.size.height - 50, width: 200, height: 50))
        pageControl.numberOfPages = 5
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.addTarget(self, action: Selector(("changePage:")), for: .valueChanged)
        pageControl.isHidden = false
        view.addSubview(pageControl)
    }
    
    func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x,y :0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    func setupImageOverlay() {
        imageOverlay = UIImageView(frame: CGRect(x: 0.0, y: view.bounds.height / 2, width: view.bounds.width, height: view.bounds.height / 2))
        imageOverlay.image = santaImage
        imageOverlay.contentMode = .scaleAspectFill
        view.addSubview(imageOverlay)
    }
    
    func numberOfIndexPathSelected(indexSelected: Int) {
        numberOfCell = indexSelected
        print("ChooseVC index selected")
        print(numberOfCell)
    }

    
    @IBAction func restartButtonPressed(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    func saveButtonPressed(sender: Any) {
        
        // take screenshot
        let photoTaken = santaImage
        let finalImage = santaScreenShot(image: photoTaken)
        savePhotoToLibrary(finalImage)
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
                   self.showSaveViewAlert()
                    // hide the page controller
                    self.pageControl.isHidden = false
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension PhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        
        return cell
    }
    
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
    func fadeOut(withDuration duration: TimeInterval = 3.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
}




