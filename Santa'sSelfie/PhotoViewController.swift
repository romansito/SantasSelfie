//
//  PhtoViewController.swift
//  Santa'sSelfie
//
//  Created by Roman Salazar on 11/7/16.
//  Copyright © 2016 Roman Salazar. All rights reserved.
//

import UIKit

let esposureFilter = "CIExposureAdjust"

class PhotoViewController: UIViewController {

    
    var detailImageView: UIImageView!
    var photoFromCamera: UIImage!
    var exposureSlider: UISlider!
    
    
    func userSlider(sender: UISlider) {
        print(sender.value)
        guard let image = self.detailImageView.image?.cgImage else { return }
        
        let openGLContext = EAGLContext(api: .openGLES3)
        let context = CIContext(eaglContext: openGLContext!)
//        let ciImage = CIImage(cgImage: image)
        
        let filter = CIFilter(name: "\(esposureFilter)") // CISepiaTone
//        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(sender.value, forKey: kCIInputImageKey)
        
        //filter?.setValue(1, forKey: kCIInputIntensityKey) // for CISepiaTone
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            self.detailImageView?.image = UIImage(cgImage: context.createCGImage(output, from: output.extent)!)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupdetailImageView()
        setupSlider()
        detailImageView.image = photoFromCamera
        print(photoFromCamera)
        
    }
    
    func setupdetailImageView() {
        detailImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: view.bounds.height))
        detailImageView.contentMode = .scaleAspectFill
        view.addSubview(detailImageView)
    }
    
    func setupSlider() {
        self.exposureSlider = UISlider(frame: CGRect(x: 40, y: self.view.bounds.height - 100, width: 300, height: 40))
        exposureSlider.tintColor = .red
        exposureSlider.backgroundColor = .white
        exposureSlider.addTarget(self, action: #selector(PhotoViewController.userSlider(sender:)), for: .valueChanged)
        self.view.addSubview(exposureSlider)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
