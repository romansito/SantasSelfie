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
        orientation = AVCaptureVideoOrientation.landscapeLeft
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



// MARK : Image overlay function 
//func penguinPhotoBomb(image: UIImage) -> UIImage {
//    UIGraphicsBeginImageContextWithOptions(image.size, true, 0.0)
//    image.drawAtPoint(CGPoint(x: 0, y: 0))
//    
//    // Composite Penguin
//    let penguinImage = UIImage(named: "Penguin_\(randomInt(4))")
//    
//    var xFactor: CGFloat
//    if randomFloat(from: 0.0, to: 1.0) >= 0.5 {
//        xFactor = randomFloat(from: 0.0, to: 0.25)
//    } else {
//        xFactor = randomFloat(from: 0.75, to: 1.0)
//    }
//    
//    var yFactor: CGFloat
//    if image.size.width < image.size.height {
//        yFactor = 0.0
//    } else {
//        yFactor = 0.35
//    }
//    
//    let penguinX = (image.size.width * xFactor) - (penguinImage!.size.width / 2)
//    let penguinY = (image.size.height * 0.5) - (penguinImage!.size.height * yFactor)
//    let penguinOrigin = CGPoint(x: penguinX, y: penguinY)
//    
//    penguinImage?.drawAtPoint(penguinOrigin)
//    
//    let finalImage = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//    return finalImage!
//}

//func santaPhotoBomb(image: UIImage) -> UIImage {
//    
////    return image
//    UIGraphicsBeginImageContextWithOptions(image.size, true, 0.0)
//    image.draw(at: CGPoint(x: 0, y: 0))
//    
//    let finalImage = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//    return finalImage!
//    
//}















