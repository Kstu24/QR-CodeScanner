//
//  ViewController.swift
//  QRCodeScanner
//
//  Created by Kevin Stewart on 8/22/21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var video = AVCaptureVideoPreviewLayer()
    @IBOutlet weak var scannerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scannerImageView.layer.borderWidth = 3
        scannerImageView.layer.borderColor = UIColor.yellow.cgColor
        
        // Creating session
        let session = AVCaptureSession()
        
        // Define capture device
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        } catch {
            print("Error!")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        self.view.bringSubviewToFront(scannerImageView)
        
        session.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.qr {
                    let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "View", style: .default, handler: { _ in
                        let url = URL(string: object.stringValue!)
                        UIApplication.shared.open(url!)
                    }))
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
