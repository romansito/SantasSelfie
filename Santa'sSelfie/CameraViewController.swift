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
    var shutterButton: UIButton!
    var imageOverlay = UIImageView()
    var santaImage = UIImage()
    var backButton = UIButton()
    var rotateCameraButton = UIButton()
    
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
        
        imageOverlay = UIImageView(frame: CGRect(x: 0.0, y: view.bounds.height / 2, width: view.bounds.width, height: view.bounds.height / 2 - 5))
        imageOverlay.image = santaImage
        imageOverlay.contentMode = .scaleAspectFill
        
        shutterButton = UIButton(frame: CGRect(x: view.center.x - 40, y: view.bounds.height - 120, width: 80, height: 80))
        shutterButton.setBackgroundImage(UIImage.init(named: "Capture_Butt"), for: .normal)
        shutterButton.addTarget(self, action: #selector(CameraViewController.shutterButtonPressed), for: .touchUpInside)
        
        rotateCameraButton = UIButton(frame: CGRect(x: self.view.frame.width - 74, y: 36, width: 40, height: 30))
        rotateCameraButton.setBackgroundImage(UIImage.init(named: "Camera_Icon"), for: .normal)
        rotateCameraButton.contentMode = .scaleAspectFit
        rotateCameraButton.addTarget(self, action: #selector(CameraViewController.rotateCameraPressed(_:)), for: .touchUpInside)
        
        backButton = UIButton(frame: CGRect(x: 24, y: 36, width: 30, height: 30))
        backButton.setBackgroundImage(UIImage.init(named: "backButton"), for: .normal)
        backButton.contentMode = UIViewContentMode.scaleAspectFit
        backButton.addTarget(self, action: #selector(CameraViewController.backButtonPressed), for: .touchUpInside)
        
        view.addSubview(cameraPreview)
        view.addSubview(rotateCameraButton)
        view.addSubview(backButton)
        view.addSubview(imageOverlay)
        view.addSubview(shutterButton)
    }
    
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    func rotateCameraPressed(_ sender: AnyObject) {
        // Make sure the device has more than 1 camera.
        if AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo).count > 1{
            //check what position the active camera is.
            var newPosition : AVCaptureDevicePosition!
            if activeInput.device.position == AVCaptureDevicePosition.back {
                newPosition = AVCaptureDevicePosition.front
            } else {
                newPosition = AVCaptureDevicePosition.back
            }
            // get camera at new position
            var newCamera : AVCaptureDevice!
            let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
            for device in devices! {
                if (device as AnyObject).position == newPosition {
                    newCamera = device as! AVCaptureDevice
                }
            }
            
            do {
                let input = try AVCaptureDeviceInput(device: newCamera)
                captureSession.beginConfiguration()
                // remove input for active camera.
                captureSession.removeInput(activeInput)
                // add input to new camera
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                    activeInput = input
                } else {
                    captureSession.addInput(activeInput)
                }
                captureSession.commitConfiguration()
            } catch {
                print("Error switching cameras: \(error)")
            }
        }
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
    
    var flippedImage: UIImage = UIImage() // Create a flipped image

    func takePhoto() {
        let connection = imageOutput.connection(withMediaType: AVMediaTypeVideo)
        if (connection?.isVideoOrientationSupported)! {
            connection?.videoOrientation = currentVideoOrientation()
            
            imageOutput.captureStillImageAsynchronously(from: connection, completionHandler: { (sampleBuffer, error) in
                if sampleBuffer != nil {
                    let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer!, previewPhotoSampleBuffer: nil)

                    var santaImage = UIImage(data: imageData!)
                    // flips the camera only when the orientation is set to front camera.
                    if self.activeInput.device.position == AVCaptureDevicePosition.front {
                        self.flippedImage = UIImage(cgImage: (santaImage?.cgImage!)!, scale: (santaImage?.scale)!, orientation: UIImageOrientation.leftMirrored) //flip orientation
                        santaImage = self.flippedImage
                        self.santasSelfie = self.flippedImage
                    } else {
                        print("\(imageData)")
                        self.santasSelfie = santaImage!
                    }
                    self.performSegue(withIdentifier: "toPhotoDetailSegue", sender: nil)
                } else {
                    print("ERROR capturing photo: \(error?.localizedDescription)")
                }
            })
        }
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
