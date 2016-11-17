//
//  CameraViewController.swift
//  Santa'sSelfie
//
//  Created by Roman Salazar on 11/5/16.
//  Copyright © 2016 Roman Salazar. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController {
    
    var photoViewController = PhotoViewController()
    var chooseViewController = ChoosePhotoViewController()
    
    var cameraPreview: UIView!
    var shuttherButton: UIButton!
    var imageOverlay = UIImageView()
    var santaImage = UIImage()
    var santasSelfie = UIImage()
    
    let captureSession = AVCaptureSession()
    let imageOutput = AVCaptureStillImageOutput()
    
    var previewLayer : AVCaptureVideoPreviewLayer!
    var activeInput : AVCaptureDeviceInput!
    
    var focusMarker : UIImageView!
    var exposureMarker : UIImageView!
    private var adjustingExposureContext: String = ""

    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        
        
        setupCamPreview()
        setupSession()
        setupPreview()
        startSession()
        stopSession()
        
        print(imageOverlay.image!)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    func shutterButtonPressed() {
        takePhoto()
    }
    
    // MARK: - Setup session and preview
    func setupCamPreview() {
        cameraPreview = UIView(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: view.bounds.height))
        cameraPreview.contentMode = .scaleAspectFill
        
        imageOverlay = UIImageView(frame: CGRect(x: 0.0, y: view.bounds.height / 2, width: view.bounds.width, height: view.bounds.height / 2))
        imageOverlay.image = santaImage
        imageOverlay.contentMode = .scaleAspectFill
        
        shuttherButton = UIButton(frame: CGRect(x: view.center.x - 40, y: view.bounds.height - 120, width: 80, height: 80))
        shuttherButton.setBackgroundImage(UIImage.init(named: "Capture_Butt"), for: .normal)
        shuttherButton.addTarget(self, action: #selector(CameraViewController.shutterButtonPressed), for: .touchUpInside)
        
        view.addSubview(cameraPreview)
        view.addSubview(imageOverlay)
        view.addSubview(shuttherButton)
    }
    
    func setupSession() {
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        let camera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                activeInput = input
            }
        } catch {
            print("Error setting device input: \(error)")
        }
        
        imageOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
        if captureSession.canAddOutput(imageOutput) {
            captureSession.addOutput(imageOutput)
        }
    }
    
    func setupPreview() {
        
        // Configure previewLayer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = cameraPreview.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraPreview.layer.addSublayer(previewLayer)
        
        // Attach tap recognizer for focus & exposure
        let tapForFocus = UITapGestureRecognizer(target: self, action: #selector(CameraViewController.tapToFocus(recognizer:)))
        tapForFocus.numberOfTapsRequired = 1
        let tapForExposure = UITapGestureRecognizer(target: self, action: #selector(CameraViewController.tapToExpose(recognizer:)))
        tapForExposure.numberOfTapsRequired = 2
        
        cameraPreview.addGestureRecognizer(tapForFocus)
        cameraPreview.addGestureRecognizer(tapForExposure)
        tapForFocus.require(toFail: tapForExposure)
        
        // Create marker views
        
        focusMarker = imageViewWithImage(name: "Focus_Point")
        exposureMarker = imageViewWithImage(name: "Exposure_Point")
        
        cameraPreview.addSubview(focusMarker)
        cameraPreview.addSubview(exposureMarker)
  
    }
    
    func startSession() {
        if !captureSession.isRunning {
            DispatchQueue.global(qos: .background).async {
                self.captureSession.startRunning()
            }
        }
    }
    
    func stopSession() {
        if captureSession.isRunning {
            DispatchQueue.global(qos: .background).async {
                self.captureSession.stopRunning()
            }
        }
    }
    
    // MARK : Take photo
    func takePhoto() {
        let connection = imageOutput.connection(withMediaType: AVMediaTypeVideo)
        if (connection?.isVideoOrientationSupported)! {
            connection?.videoOrientation = currentVideoOrientation()
            
            imageOutput.captureStillImageAsynchronously(from: connection, completionHandler: { (sampleBuffer, error) in
                if sampleBuffer != nil {
                    let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer!, previewPhotoSampleBuffer: nil)
                    let santaImage = UIImage(data: imageData!)
                    
//                    let newSize = CGSize(width: 300, height: 300) // set this to what you need
//                    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
                    
                
                    
                
                    let santaBomb = self.santaPhotoBomb(image: santaImage!)
                    self.savePhotoToLibrary(santaBomb)
//                    self.santasSelfie = santaBomb
                    self.performSegue(withIdentifier: "toPhotoDetailSegue", sender: nil)
                } else {
                    print("ERROR capturing photo: \(error?.localizedDescription)")
                }
            })
        }
    }
    
//    func saveImage() {
//        let bottomImage = UIImage(named: "bottom")!
//        let topImage = UIImage(named: "top")!
//        
//        let newSize = CGSize(width: 300, height: 300) // set this to what you need
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
//        
//        bottomImage.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
//        topImage.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
//        
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//    }
    
//     MARK : Image overlay function
    func santaPhotoBomb(image: UIImage) -> UIImage {
        
//        let imagesize = self.view.frame.height
    
//        UIGraphicsBeginImageContextWithOptions(, true, 0.0)
        UIGraphicsBeginImageContextWithOptions(image.size, true, 0.0)
        image.draw(at: CGPoint(x: 0.0, y: 0.0))
    
        // Composite Penguin
        let penguinImage = santaImage
        
//        var xFactor : CGFloat
//        if let randomFloat(from: 0.0, to: 1.0) >= 0.5 {
//            xFactor = randomFloat(from: 0.0, to: 0.25)
//        }
    
//        var xFactor: CGFloat
//        if randomFloat(from: 0.0, to: 1.0) >= 0.5 {
//            xFactor = randomFloat(from: 0.0, to: 0.25)
//        } else {
//            xFactor = randomFloat(from: 0.75, to: 1.0)
//        }
    
//        var yFactor: CGFloat
//        if image.size.width < image.size.height {
//            yFactor = 0.0
//        } else {
//            yFactor = 0.35
//        }
        
//        let penguinX = (image.size.width * xFactor) - (penguinImage!.size.width / 2)
//        let penguinY = (image.size.height * 0.5) - (penguinImage!.size.height * yFactor)
//        let penguinOrigin = CGPoint(x: penguinX, y: penguinY)

//
//        let penguinX = penguinImage.size.width
//        let penguinY = penguinImage.size.height
        let penguinOrigin = CGPoint(x: 0.0, y: self.view.bounds.height)
//
        penguinImage.draw(at: penguinOrigin)
    
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage!
    }
    
    
    // MARK : Focus Methods
    func tapToFocus(recognizer: UITapGestureRecognizer) {
        if activeInput.device.isFocusPointOfInterestSupported {
            let point = recognizer.location(in: cameraPreview)
            let pointOfInterest = previewLayer.captureDevicePointOfInterest(for: point)
            showMarkerAtPoint(point: point, marker: focusMarker)
            focusAtPoint(point: pointOfInterest)
        }
    }
    
    func focusAtPoint(point: CGPoint) {
        let device = activeInput.device
        // Make sure the device supports focus on POI and Auto Focus.
        if (device?.isFocusPointOfInterestSupported)! && (device?.isFocusModeSupported(AVCaptureFocusMode.autoFocus))! {
            do {
                try device?.lockForConfiguration()
                device?.focusPointOfInterest = point
                device?.focusMode = AVCaptureFocusMode.autoFocus
                device?.unlockForConfiguration()
            } catch {
                print("Error focusing on POI: \(error)")
            }
        }
    }
    
    // MARK : Exposure Method
    
    func tapToExpose(recognizer: UIGestureRecognizer) {
        if activeInput.device.isExposurePointOfInterestSupported {
            let point = recognizer.location(in: cameraPreview)
            let pointOfInterest = previewLayer.captureDevicePointOfInterest(for: point)
            showMarkerAtPoint(point: point, marker: exposureMarker)
            exposeAtPoint(point: pointOfInterest)
        }
    }

    func exposeAtPoint(point: CGPoint) {
        let device = activeInput.device
        if (device?.isExposurePointOfInterestSupported)! && (device?.isExposureModeSupported(AVCaptureExposureMode.continuousAutoExposure))! {
            do {
                try device?.lockForConfiguration()
                device?.exposurePointOfInterest = point
                device?.exposureMode = AVCaptureExposureMode.continuousAutoExposure
                
                if (device?.isExposureModeSupported(AVCaptureExposureMode.locked))! {
                    device?.addObserver(self, forKeyPath: "adjustingExposure", options: NSKeyValueObservingOptions.new, context: &adjustingExposureContext)
                    
                    device?.unlockForConfiguration()
                }
            } catch {
                print("Error exposing on POI: \(error)")
            }
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &adjustingExposureContext {
            let device = object as! AVCaptureDevice
            if !device.isAdjustingExposure && device.isExposureModeSupported(AVCaptureExposureMode.locked) {
                
                (object as AnyObject).removeObserver(self,
                                      forKeyPath: "adjustingExposure",
                                      context: &adjustingExposureContext)
                DispatchQueue.main.async(execute: { 
                    do {
                        try device.lockForConfiguration()
                        device.exposureMode = AVCaptureExposureMode.locked
                        device.unlockForConfiguration()
                    } catch {
                        print("Error exposing on POI: \(error)")
                    }
                })
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    func savePhotoToLibrary(_ image: UIImage) {
        let photoLibrary = PHPhotoLibrary.shared()
        photoLibrary.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }, completionHandler: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoDetailSegue" {
            if let newVC = segue.destination as? PhotoViewController {
                newVC.photoFromCamera = santasSelfie
            }
        }
    }


}
