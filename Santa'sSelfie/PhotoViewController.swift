//
//  PhtoViewController.swift
//  Santa'sSelfie
//
//  Created by Roman Salazar on 11/7/16.
//  Copyright © 2016 Roman Salazar. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    
    var detailImageView: UIImageView!
    var photoFromCamera: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupdetailImageView()
        detailImageView.image = photoFromCamera
        print(photoFromCamera)
        
    }
    
    func setupdetailImageView() {
        detailImageView = UIImageView(frame: CGRect(x: 0.0, y: 64, width: view.bounds.width, height: view.bounds.height - 180))
        detailImageView.contentMode = .scaleAspectFit
        view.addSubview(detailImageView)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
