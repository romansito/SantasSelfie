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

class PhotoViewController: UIViewController {

    var chooseVC = ChoosePhotoViewController()
    
    @IBOutlet weak var detailImageView: UIImageView!
    var photoFromCamera: UIImage!

    var collectionView : UICollectionView!
    var imageOverlay = UIImageView()
    var santaImage = UIImage()
    
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    
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
        
        print(photoFromCamera)
        setupDataSource()
//        addBorderToImage()
        
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
        let frame = CGRect(x: 0.0, y: view.bounds.height / 2, width: view.bounds.width, height: view.bounds.height / 2)
        scrollView = UIScrollView(frame: frame)
        scrollView.backgroundColor = .yellow
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        
        view.addSubview(scrollView)
    }
    
    func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: view.center.x - 100, y: view.frame.size.height - 50, width: 200, height: 50))
        pageControl.numberOfPages = 5
        pageControl.currentPage = 2
        pageControl.tintColor = UIColor.red
        pageControl.pageIndicatorTintColor = UIColor.black
        pageControl.currentPageIndicatorTintColor = UIColor.green
        view.addSubview(pageControl)
    }
    
    func addBorderToImage() {
//        detailImageView = UIImageView()
        detailImageView.layer.borderColor = UIColor.white.cgColor
        detailImageView.layer.borderWidth = 3.0
    }
    
    func setupImageOverlay() {
        imageOverlay = UIImageView(frame: CGRect(x: 0.0, y: view.bounds.height / 2, width: view.bounds.width, height: view.bounds.height / 2))
        imageOverlay.image = santaImage
        imageOverlay.contentMode = .scaleAspectFill
        view.addSubview(imageOverlay)
    }
    
//    func setupdetailImageView() {
//        detailImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: view.bounds.height))
//        detailImageView.contentMode = .scaleAspectFill
//        view.addSubview(detailImageView)
//    }
    
//    func setupSlider() {
//        self.exposureSlider = UISlider(frame: CGRect(x: 40, y: self.view.bounds.height - 100, width: 300, height: 40))
//        exposureSlider.addTarget(self, action: #selector(PhotoViewController.userSlider(sender:)), for: .valueChanged)
//        self.view.addSubview(exposureSlider)
//        
//    }
    
//    func setupButton() {
//        self.filterButton = UIButton(frame: CGRect(x: 12, y: 20, width: 50, height: 30))
//        filterButton.backgroundColor = .white
//        filterButton.setTitle("Filter", for: .selected)
//        filterButton.addTarget(self, action: #selector(PhotoViewController.userTapFilterButton(sender:)), for: .touchUpInside)
//        view.addSubview(filterButton)
//    }
    
//    func userTapFilterButton(sender: UIButton) {
//        guard let image = self.detailImageView.image?.cgImage else { return }
//        
//        let openGLContext = EAGLContext(api: .openGLES3)
//        let context = CIContext(eaglContext: openGLContext!)
//        let ciImage = CIImage(cgImage: image)
//        
//        let filter = CIFilter(name: "\(esposureFilter)") // CISepiaTone
//        //        filter?.setValue(ciImage, forKey: kCIInputImageKey)
////        filter?.setValue(sender.value, forKey: kCIInputImageKey)
//        
//        filter?.setValue(1, forKey: kCIInputIntensityKey) // for CISepiaTone
//        
//        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
//            self.detailImageView?.image = UIImage(cgImage: context.createCGImage(output, from: output.extent)!)
//        }
//
//    }
    
    @IBAction func restartButtonPressed(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        UIImageWriteToSavedPhotosAlbum(detailImageView.image!, nil, nil, nil)
        
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





