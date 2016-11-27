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
//        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupdetailImageView()
//        setupSlider()
        detailImageView.image = photoFromCamera
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
        pageControl.tintColor = UIColor.red
        pageControl.pageIndicatorTintColor = UIColor.green
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.addTarget(self, action: Selector(("changePage:")), for: .valueChanged)
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
    
    
    @IBAction func savePressed(_ sender: Any) {
        
        let photoTaken = santaImage
        let finalImage = santaScreenShot(image: photoTaken)
        UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)
        
    }
    
    func santaScreenShot(image: UIImage) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, true, 0)
        self.view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
        
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





