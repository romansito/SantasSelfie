//
//  CameraHelperMethods.swift
//  Santa'sSelfie
//
//  Created by Roman Salazar on 11/15/16.
//  Copyright © 2016 Roman Salazar. All rights reserved.
//

import UIKit
import AVFoundation

// MARK : Helper Functions
func currentVideoOrientation() -> AVCaptureVideoOrientation {
    var orientation : AVCaptureVideoOrientation
    
    switch UIDevice.current.orientation {
        
    case .portrait:
        orientation = AVCaptureVideoOrientation.portrait
    case .landscapeRight:
        orientation = AVCaptureVideoOrientation.portrait
    case .portraitUpsideDown:
        orientation = AVCaptureVideoOrientation.portraitUpsideDown
    default:
        orientation = AVCaptureVideoOrientation.landscapeRight
    }
    return orientation
}

func showMarkerAtPoint(point: CGPoint, marker: UIImageView) {
    marker.center = point
    marker.isHidden = false
    
    UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseInOut, animations: { () -> Void in
        marker.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0)}) { (Bool) -> Void in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                marker.isHidden = true
                marker.transform = CGAffineTransform.identity
            })
    }
}


func imageViewWithImage(name: String) -> UIImageView {
    let view = UIImageView()
    let image = UIImage(named: name)
    view.image = image
    view.sizeToFit()
    view.isHidden = true
    
    return view
}



