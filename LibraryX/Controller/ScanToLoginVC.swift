//
//  ScanToLoginVC.swift
//  LibraryX
//
//  Created by Sean Saoirse on 31/01/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//


import AVFoundation
import UIKit
import Firebase

class ScanToLoginVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var gotoDiffMethodBtn: UIButton!
    @IBOutlet weak var boxVev: UIVisualEffectView!
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.text = "Scan the QR Code on your Student ID Card to Sign In"
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for:
            AVMediaType.video, position: .front) else { return }
        
       
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        logo.layer.zPosition = 100
        boxVev.layer.zPosition = 100
        boxVev.layer.cornerRadius = 11.25
        boxVev.clipsToBounds = true
                gotoDiffMethodBtn.layer.zPosition = 100
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if toMyAccVC == true{
            dismiss(animated: true, completion: nil)
        }
        
        if Auth.auth().currentUser != nil{
            dismiss(animated: true, completion: nil)
        }
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            found(code: stringValue)
        }
        
    }
    
    
    
    func found(code: String) {
        var email = ""
        var pw = ""
        statusLabel.text = "Signing In..."
        DataService.instance.getUnamePwForScannedLogin(scannedUid: code, email: { (returnedEmail) in
            email = returnedEmail
            print(returnedEmail)
        }) { (returnedPassword) in
            pw = returnedPassword
            print(returnedPassword)
            if email != "" && pw != ""{
                
                AuthService.instance.loginUser(email: email, password: pw, loginComplete: { (success, err) in
                    if success {
                         self.dismiss(animated: true, completion: nil)
                    }else{ // error in logging in
                        self.statusLabel.text = "Scan the QR Code on your Student ID Card to Sign In"
                        let alert = UIAlertController(title: "Invalid QR Code", message: "QR Code scanned is invalid", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { (action:UIAlertAction) in
                            self.captureSession.startRunning()
                            
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                })
            }else{ // false uid
                self.statusLabel.text = "Scan the QR Code on your Student ID Card to Sign In"
                let alert = UIAlertController(title: "Invalid QR Code", message: "QR Code scanned is invalid.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { (action:UIAlertAction) in
                    self.captureSession.startRunning()
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            
        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
