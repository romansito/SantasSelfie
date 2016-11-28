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
    
//    @IBOutlet weak var cameraPreview: UIView!
//    @IBOutlet weak var imageOverlay: UIImageView!
    
    var cameraPreview: UIView!
    var shutterButton: UIButton!
    var imageOverlay = UIImageView()
    var santaImage = UIImage()
    var backButton = UIButton()
    
    var santasSelfie = UIImage()

    let captureSession = AVCaptureSession()
    let imageOutput = AVCaptureStillImageOutput()
    
    var previewLayer : AVCaptureVideoPreviewLayer!
    var activeInput : AVCaptureDeviceInput!
    
    var focusMarker : UIImageView!
    var exposureMarker : UIImageView!
    private var adjustingExposureContext: String = ""
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        shutterButton.isHidden = false
    }
    
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
        
        shutterButton = UIButton(frame: CGRect(x: view.center.x - 40, y: view.bounds.height - 120, width: 80, height: 80))
        shutterButton.setBackgroundImage(UIImage.init(named: "Capture_Butt"), for: .normal)
        shutterButton.addTarget(self, action: #selector(CameraViewController.shutterButtonPressed), for: .touchUpInside)
        
        backButton = UIButton(frame: CGRect(x: 24, y: 24, width: 25, height: 25))
        backButton.setBackgroundImage(UIImage.init(named: "backButton"), for: .normal)
        backButton.contentMode = UIViewContentMode.scaleAspectFit
        backButton.addTarget(self, action: #selector(CameraViewController.backButtonPressed), for: .touchUpInside)
        
        view.addSubview(cameraPreview)
        view.addSubview(backButton)
        view.addSubview(imageOverlay)
        view.addSubview(shutterButton)
    }
    
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
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
//        previewLayer.videoGravity = AVLayerVideoGravityResizeAspect
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
                    print("\(imageData)")
//                    let snapShot = self.view.snapshotView(afterScreenUpdates: true)
//                    let santaBomb = self.santaScreenShot(image: santaImage!)
//                    self.savePhotoToLibrary(santaBomb)
                    self.santasSelfie = santaImage!
            
                    self.performSegue(withIdentifier: "toPhotoDetailSegue", sender: nil)
                } else {
                    print("ERROR capturing photo: \(error?.localizedDescription)")
                }
            })
        }
    }
    
    
//     MARK : Image overlay function
    func santaScreenShot(image: UIImage) -> UIImage {
        // try one
//        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0.0)
//        UIGraphicsBeginImageContext(image.size)

//        UIGraphicsBeginImageContext(image.size)
//        image.draw(at: CGPoint(x: 0.0, y: 0.0))
//        view.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image!
        
        // test
//        UIGraphicsBeginImageContext(CGSize(width: view.frame.size.width, height: view.frame.size.height))
//            UIGraphicsBeginImageContext(image.size)
//
//        self.view?.drawHierarchy(in: view.frame, afterScreenUpdates: true)
//        let screenShot = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext();
//        return screenShot!
        
//        // test
        UIGraphicsBeginImageContextWithOptions(image.size, true, 0.0)
        UIGraphicsBeginImageContext(image.size)
        image.draw(at: CGPoint(x: 0.0, y: 0.0))

        // Composite Santas Selfie
        let santaSelfie = santaImage
        let origin = CGPoint(x: 0.0, y: self.view.frame.size.height)
        santaSelfie.draw(at: origin)
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage!
        
//        // test 
//        let layer = UIApplication.shared.keyWindow!.layer
//        let scale = UIScreen.main.scale
//        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
//                image.draw(at: CGPoint(x: 0.0, y: 0.0))
//        
//        layer.render(in: UIGraphicsGetCurrentContext()!)
//        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
////        UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
//        
//        return screenshot!
        
        // test 
//
//        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, self.view.isOpaque, UIScreen.main.scale)
////        self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
//        UIGraphicsBeginImageContext(image.size)
//        image.draw(at: CGPoint(x: 0.0, y: 0.0))
//
//
//        
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        return image!
        
        // this is the good working function
//        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, true, 0)
//        
//        self.view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
//        
//        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        
//        UIGraphicsEndImageContext()
//        
//        return image
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
                newVC.santaImage = santaImage
            }
        }
    }


}
