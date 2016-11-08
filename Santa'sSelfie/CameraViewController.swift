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
    
    var cameraPreview: UIView!
    

    let captureSession = AVCaptureSession()
    let imageOutput = AVCaptureStillImageOutput()
    
    var previewLayer : AVCaptureVideoPreviewLayer!
    var activeInput : AVCaptureInput!

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
                let image = UIImage(data: imageData!)
                self.savePhotoToLibrary(image!)
            } else {
                print("ERROR capturing photo: \(error?.localizedDescription)")
            }
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



}
