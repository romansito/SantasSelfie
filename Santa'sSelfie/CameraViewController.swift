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
    var cameraPreview: UIView!
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

        setupCamPreview()
        
        setupSession()
        setupPreview()
        startSession()
        stopSession()
    }
    
    
    @IBAction func shutterButtonPressed(_ sender: Any) {
        takePhoto()
    }
    
    
    // MARK: - Setup session and preview
    func setupCamPreview() {
        cameraPreview = UIView(frame: CGRect(x: 0.0, y: 64, width: view.bounds.width, height: view.bounds.height - 180))
        view.addSubview(cameraPreview)
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
//                    self.savePhotoToLibrary(santaImage!)
                    self.santasSelfie = santaImage!
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

    func imageViewWithImage(name: String) -> UIImageView {
        let view = UIImageView()
        let image = UIImage(named: name)
        view.image = image
        view.sizeToFit()
        view.isHidden = true
        
        return view
    }
    
    


}
