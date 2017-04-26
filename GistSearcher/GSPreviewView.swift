//
//  GSPreviewView.swift
//  GistSearcher
//
//  Created by Enrique Melgarejo on 21/04/17.
//  Copyright © 2017 Choynowski. All rights reserved.
//

import UIKit
import AVFoundation

class GSPreviewView: UIView {
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    var session: AVCaptureSession? {
        get {
            return videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.session = newValue
        }
    }
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}
