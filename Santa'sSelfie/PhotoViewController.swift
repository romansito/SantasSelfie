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

    
    @IBOutlet weak var detailImageView: UIImageView!
//    var detailImageView: UIImageView!
    var photoFromCamera: UIImage!

    
    
//    func userSlider(sender: UISlider) {
//        print(sender.value)
//        
//        guard let image = detailImageView?.image, let cgimg = image.cgImage else {
//            print("imageView doesn't have an image!")
//            return
//        }
//        
//        let openGLContext = EAGLContext(api: .openGLES2)
//        let context = CIContext(eaglContext: openGLContext!)
//        
//        let coreImage = CIImage(cgImage: cgimg)
//        
//        let filter = CIFilter(name: "CIExposureAdjust")
//        filter?.setValue(coreImage, forKey: kCIInputImageKey)
//        filter?.setValue(sender.value, forKey: "inputEV")
//        
//        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
//            let cgimgresult = context.createCGImage(output, from: output.extent)
//            let result = UIImage(cgImage: cgimgresult!)
//            detailImageView?.image = result
//        }
//        
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupdetailImageView()
//        setupSlider()
        
        detailImageView.image = photoFromCamera
        print(photoFromCamera)
        addBorderToImage()
        
    }
    
    func addBorderToImage() {
//        detailImageView = UIImageView()
        detailImageView.layer.borderColor = UIColor.white.cgColor
        detailImageView.layer.borderWidth = 3.0
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
