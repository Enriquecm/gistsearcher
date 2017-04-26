//
//  GSQRCodeReaderViewController.swift
//  GistSearcher
//
//  Created by Enrique Melgarejo on 21/04/17.
//  Copyright © 2017 Choynowski. All rights reserved.
//

import UIKit
import AVFoundation

private enum GSSessionSetupResult {
    case success
    case notAuthorized
    case configurationFailed
}

class GSQRCodeReaderViewController: UIViewController {

    // MARK: Properties
    // AVFoundation
    fileprivate var session = AVCaptureSession()
    fileprivate var captureVideoPreviewLayer: AVCaptureVideoPreviewLayer?
    fileprivate var viewQRCodeBorder: UIView?
    fileprivate let sessionQueue = DispatchQueue(label: "Queue Session", attributes: [], target: nil)
    
    fileprivate let supportedCodeTypes = [AVMetadataObjectTypeUPCECode,
                                          AVMetadataObjectTypeCode39Code,
                                          AVMetadataObjectTypeCode39Mod43Code,
                                          AVMetadataObjectTypeCode93Code,
                                          AVMetadataObjectTypeCode128Code,
                                          AVMetadataObjectTypeEAN8Code,
                                          AVMetadataObjectTypeEAN13Code,
                                          AVMetadataObjectTypeAztecCode,
                                          AVMetadataObjectTypePDF417Code,
                                          AVMetadataObjectTypeQRCode]
    
    
    // Helpers
    fileprivate var setupResult: GSSessionSetupResult = .success
    fileprivate var canPerformSegue: Bool = true
    
    // MARK: Outlets
    @IBOutlet weak var viewCameraPreview: GSPreviewView!
    @IBOutlet weak var viewQRInfo: UIView!
    @IBOutlet weak var labelQRInfo: UILabel!
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSession()
        configureQRCodeBorder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sessionQueue.async {
            switch self.setupResult {
            case .success:
                self.startSession()
            case .notAuthorized:
                self.videoNotAuthorized()
            case .configurationFailed:
                self.configurationFailed()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sessionQueue.async {
            if self.setupResult == .success {
                self.stopSession()
            }
        }
        super.viewWillDisappear(animated)
    }
    
    fileprivate func setupSession() {
        
        viewCameraPreview.session = session
        
        switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) {
        case .authorized:
            // The user has previously granted access to the camera.
            break
        case .notDetermined:
            
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { [unowned self] granted in
                if !granted {
                    self.setupResult = .notAuthorized
                }
                self.sessionQueue.resume()
            })
            
        default:
            // The user has previously denied access.
            setupResult = .notAuthorized
        }
        
        sessionQueue.async { [unowned self] in
            self.configureSession()
        }
        
    }
    
    fileprivate func configureSession() {
        guard setupResult == .success else { return }
        
        session.beginConfiguration()
        session.sessionPreset = AVCaptureSessionPresetHigh
        
        // Add video input.
        do {
            
            var defaultVideoDevice: AVCaptureDevice?
            
            if #available(iOS 10.0, *) {
                
                // Choose the back camera if available, otherwise default to a back dual angle camera.
                if let dualCameraDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInDuoCamera, mediaType: AVMediaTypeVideo, position: .back) {
                    
                    defaultVideoDevice = dualCameraDevice
                } else if let backCameraDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back) {
                    
                    defaultVideoDevice = backCameraDevice
                } else if let frontCameraDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front) {
                    
                    defaultVideoDevice = frontCameraDevice
                }
            } else {
                defaultVideoDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            }
            
            let deviceInput = try AVCaptureDeviceInput(device: defaultVideoDevice)
            if session.canAddInput(deviceInput) {
                
                session.addInput(deviceInput)
                viewCameraPreview.videoPreviewLayer.connection.videoOrientation = .portrait
                viewCameraPreview.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            } else {
                print("Could not add video device input to the session")
                
                // ERROR
                setupResult = .configurationFailed
                session.commitConfiguration()
                return
            }
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            session.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
        } catch {
            print("Could not create video device input: \(error)")
            
            // ERROR
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }
        session.commitConfiguration()
    }
    
    fileprivate func configureQRCodeBorder() {
        // Initialize QR Code Frame to highlight the QR code
        viewQRCodeBorder = UIView()
        
        if let viewQRCodeBorder = viewQRCodeBorder {
            viewQRCodeBorder.layer.borderColor = UIColor.green.cgColor
            viewQRCodeBorder.layer.borderWidth = 2
            viewCameraPreview.addSubview(viewQRCodeBorder)
            viewCameraPreview.bringSubview(toFront: viewQRCodeBorder)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == GSSegueIdentifier.goToGist {
            let destination = segue.destination as? GSGistDetailViewController
            destination?.gistURL = sender as? URL
        }
    }
}

extension GSQRCodeReaderViewController {
    
    fileprivate func startSession() {
        session.startRunning()
    }
    
    fileprivate func stopSession() {
        session.stopRunning()
    }
}

extension GSQRCodeReaderViewController {
    
    fileprivate func videoNotAuthorized() {
        DispatchQueue.main.async { [unowned self] in
            let message = NSLocalizedString("Gist Searcher doesn't have permission to use the camera, please change privacy settings", comment: "Alert message when the user has denied access to the camera")
            let alertController = UIAlertController(title: "Gist Searcher", message: message, preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"), style: .`default`, handler: { action in
                
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.openURL(url)
                    }
                }
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    fileprivate func configurationFailed() {
        DispatchQueue.main.async { [unowned self] in
            
            let message = NSLocalizedString("Unable to capture media", comment: "Alert message when something goes wrong during capture session configuration")
            let alertController = UIAlertController(title: "Gist Searcher", message: message, preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    fileprivate func showQRInfo(withMessage message: String) {
        viewQRInfo.isHidden = false
        labelQRInfo.text = message
    }
    
    fileprivate func hideQRInfo() {
        viewQRInfo.isHidden = true
        labelQRInfo.text = ""
    }
    
    fileprivate func goToGist(withURL url: URL) {
        
        if canPerformSegue {
            canPerformSegue = false
            performSegue(withIdentifier: GSSegueIdentifier.goToGist, sender: url)
        }
    }
}

extension GSQRCodeReaderViewController: AVCaptureMetadataOutputObjectsDelegate {

    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        guard metadataObjects != nil && metadataObjects.count != 0 else {
            viewQRCodeBorder?.frame = .zero
            return
        }
        
        // Get metadata object
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           supportedCodeTypes.contains(metadataObject.type) {
            
            
            // Check if is a valid URL
            if let qrValue = metadataObject.stringValue, qrValue.isValidURL(), let url = URL(string: qrValue) {
                // Check if is a Gist URL
                if url.host == "gist.github.com" {
                    hideQRInfo()
                    goToGist(withURL: url)
                } else {
                    // Not a Gist URL
                    showQRInfo(withMessage: "Not a Gist URL")
                }
                
                debugPrint(qrValue)
            } else {
                // Not a valid url
                showQRInfo(withMessage: "Not a valid URL")
            }
            
            
            let barCodeObject = viewCameraPreview.videoPreviewLayer.transformedMetadataObject(for: metadataObject)
            viewQRCodeBorder?.frame = barCodeObject?.bounds ?? .zero
        }
    }
}
