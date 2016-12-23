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
    
    let fileDirectory : NSURL  = {
        return try! FileManager.default.url(for: .documentDirectory , in: .userDomainMask , appropriateFor: nil, create: true)
    }() as NSURL

    var selectedImage: UIImage!
    var selectedImagePath: String!
    
    override func viewDidLoad() {

    }

    override func viewWillAppear(_ animated: Bool) {
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
        return "\(articleType)-\(UUID().uuidString).jpg"
    }
    
    func saveImageToDocuments(image: UIImage, fileNameWithExtension: String) {
        let image = cropImageIntoSquare(image: image)
        let imagePath = fileDirectory.appendingPathComponent("\(fileNameWithExtension)")
        guard imagePath?.path != nil else { return }
        guard let imageData = UIImageJPEGRepresentation(image!, 0.6) else { return }
        
        do {
            try imageData.write(to: URL(fileURLWithPath: (imagePath?.path)!), options: .atomic)
        } catch let error {
            print(error)
        }
        
        selectedImagePath = (imagePath?.path)! as String
        selectedImage = image! as UIImage
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
            let articleCreateViewController = segue.destination as! ArticleCreateViewController
            articleCreateViewController.articleImage = selectedImage
            articleCreateViewController.articleImagePath = selectedImagePath
            articleCreateViewController.articleType = self.articleType
        }
    }
}
