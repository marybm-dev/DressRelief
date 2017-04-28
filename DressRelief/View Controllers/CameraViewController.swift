//
//  CameraViewController.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/20/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate, UINavigationControllerDelegate {
    
    var articleType: String!
    
    @IBOutlet weak var cameraView: UIView!
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCapturePhotoOutput()
    var sessionOutputSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecJPEG])
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    var selectedImage: UIImage!
    var selectedImagePath: String!
    var selectedImageData: Data!
    
    override func viewDidLoad() {
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        print(status ==  AVAuthorizationStatus.authorized)
        print(status ==  AVAuthorizationStatus.denied)
        print(status ==  AVAuthorizationStatus.restricted)
        print(status.rawValue)
        
        if status !=  AVAuthorizationStatus.authorized {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { isAuthorized -> Void in
                if !isAuthorized {
                    // Camera not Authorized
                    DispatchQueue.main.async {
                        print("Camera not Authorized")
                        self.checkCamera()
                        return
                    }
                } else {
                    self.initCameraView()
                }
            })
        } else {
            self.initCameraView()
        }
    }

    @IBAction func didTapCancelButton(_ sender: Any) {
        captureSession.stopRunning()
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func didTapShutterButton(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 160,
                             kCVPixelBufferHeightKey as String: 160,
                             ]
        settings.previewPhotoFormat = previewFormat
        self.sessionOutput.capturePhoto(with: settings, delegate: self)
        print("Did tap shutter button")
    }
    
    func checkCamera() {
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch authStatus {
        case AVAuthorizationStatus.authorized:
            print("AVAuthorizationStatus.Authorized")
        case AVAuthorizationStatus.denied:
            print("AVAuthorizationStatus.Denied")
            self.abort()
        case AVAuthorizationStatus.notDetermined:
            print("AVAuthorizationStatus.NotDetermined")
            self.abort()
        case AVAuthorizationStatus.restricted:
            print("AVAuthorizationStatus.Restricted")
            self.abort()
        }
    }
    
    func abort() {
        let alertController = UIAlertController(title: "Uh oh. Something went wrong", message: "Camera use is not authorized. Toggle Camera Access in Settings App to use the Camera.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("OK")
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func initCameraView() {
        let defaultDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        if defaultDevice?.position == AVCaptureDevicePosition.back {
            do {
                let input = try AVCaptureDeviceInput(device: defaultDevice)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                    
                    if captureSession.canAddOutput(sessionOutput) {
                        captureSession.addOutput(sessionOutput)
                        captureSession.startRunning()
                        
                        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                        previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.portrait
                        cameraView.layer.addSublayer(previewLayer)
                        
                        previewLayer.position = CGPoint(x: self.cameraView.frame.width/2, y: self.cameraView.frame.height/2)
                        previewLayer.bounds = cameraView.frame
                    }
                }
            } catch {
                print("exception!");
            }
        }
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            print(error.localizedDescription)
        }
        
        if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            
            let image = UIImage(data: dataImage)
            guard image != nil else {
                print("error image is nil")
                return
            }

            // save to documentss
            saveImageToDocuments(image: image!, fileNameWithExtension: getUniqueFileName())
            print("Did save image in documents")
            
        } else {
            print("error with buffer")
        }
        
    }
    
    func getUniqueFileName() -> String {
        guard let articleType = articleType else {
            return ""
        }
        return "\(articleType)-\(UUID().uuidString).jpg"
    }
    
    func saveImageToDocuments(image: UIImage, fileNameWithExtension: String) {
        guard let image = cropImageIntoSquare(image: image),
            let imageData = UIImageJPEGRepresentation(image, 0.6) else {
            return
        }
        
        let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let finalDir = docsURL.appendingPathComponent(fileNameWithExtension)
        do {
            try imageData.write(to: finalDir, options: .atomic)
        } catch let error {
            print("camera view controller - save image to documents")
            print(error)
        }
        
        selectedImageData = imageData
        selectedImagePath = finalDir.absoluteString
        selectedImage = image
        performSegue(withIdentifier: ArticleSegue.FromImageToCreateArticle.rawValue, sender: nil)
    }
    
    func cropImageIntoSquare(image: UIImage) -> UIImage? {
        let imageSize: CGSize = image.size
        let width = imageSize.width
        let height = imageSize.height
        if width != height {
            let newDimension: CGFloat = min(width, height)
            let widthOffset: CGFloat = (width - newDimension)/2
            let heightOffset: CGFloat = (height - newDimension)/2
            UIGraphicsBeginImageContext(CGSize(width: newDimension, height: newDimension))
            image.draw(at: CGPoint(x: -widthOffset, y: -heightOffset))
            let imageResult: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return imageResult
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ArticleSegue.FromImageToCreateArticle.rawValue {
            let articleEditViewController = segue.destination as! ArticleEditViewController
            articleEditViewController.entryPoint = ArticleEntryPoint.create.rawValue
            articleEditViewController.articleImage = selectedImage
            articleEditViewController.articleImagePath = selectedImagePath
            articleEditViewController.articleType = self.articleType
            articleEditViewController.articleImageData = self.selectedImageData
        }
    }
}
