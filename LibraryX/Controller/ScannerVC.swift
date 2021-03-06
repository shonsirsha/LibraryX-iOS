//
//  ScannerVC.swift
//  LibraryX
//
//  Created by Sean Saoirse on 24/01/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import AVFoundation
import UIKit

var player: AVAudioPlayer?

class ScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var boxVev: UIVisualEffectView!
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var returnedCode: Double = 0
    @IBOutlet weak var closeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
         guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) else { return }
        
        
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
        
        closeBtn.layer.zPosition = 100
        boxVev.layer.zPosition = 100
        boxVev.layer.cornerRadius = 11.25
        boxVev.clipsToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if toMyAccVC == true{
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
    
    
    func playSound(sound: String) {
        guard let url = Bundle.main.url(forResource: sound, withExtension: "wav") else { return }
        
        do {
            print("AWAWAWAWAAW")
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    func found(code: String) {
        print(code)
        if let returnedCode2 = Double(code) {
            print("AAAA")
            print(returnedCode2)
            print("ASD")
            print(code)
            DataService.instance.scannedBookFromImgTitle(imgTitleinMS: returnedCode2, bookStatusAndTitleHandler: { (returnedBookStatusAndTitle) in
                if returnedBookStatusAndTitle[0] == "avail" || returnedBookStatusAndTitle[0] == "no"{ //0 is status, 1 is title
                    self.returnedCode = returnedCode2
                    print(self.returnedCode)
                    //self.playSound(sound: "scansound")
                    self.performSegue(withIdentifier: "toAfterBarcodeVC", sender: self)
                }else{
                    //self.playSound(sound: "fail")
                    let alert = UIAlertController(title: "Invalid QR Code", message: "QR Code scanned is invalid.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { (action:UIAlertAction) in
                        self.captureSession.startRunning()
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }) { (num) in
                return
            }
           
        } else { // not a double valued qrcode
            //playSound(sound: "fail")
            print(code)
            let alert = UIAlertController(title: "Invalid QR Code", message: "QR Code scanned is invalid.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { (action:UIAlertAction) in
                self.captureSession.startRunning()
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            return
        }
    
       

       
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if returnedCode != 0{
            if segue.identifier == "toAfterBarcodeVC"{
                if let afterBarcodeVC = segue.destination as? AfterBarcodeVC {
                    afterBarcodeVC.imgTitleInMS = returnedCode
                }
            }
        }
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
