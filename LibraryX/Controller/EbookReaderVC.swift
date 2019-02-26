//
//  EbookReaderVC.swift
//  LibraryX
//
//  Created by Sean Saoirse on 26/02/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import UIKit
import WebKit
class EbookReaderVC: UIViewController,WKNavigationDelegate{
    var imgTitleInMS: Double = 0
    var bookTitle = ""
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        webView.navigationDelegate = self
        if imgTitleInMS != 0{
            
            DataService.instance.getEbookURL(imgTitleInMS: imgTitleInMS) { (returnedURL) in
                let myUrl: URL! = URL(string: returnedURL)
                self.webView.load(URLRequest(url: myUrl))
            }
            titleLabel.text = bookTitle
        }
        
        self.webView.addSubview(self.Activity)
        Activity.transform = transform
        self.Activity.startAnimating()
        self.webView.navigationDelegate = self
        self.Activity.hidesWhenStopped = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Activity.stopAnimating()
        statusLabel.text = ""
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Activity.stopAnimating()
        let alert = UIAlertController(title: "Ouch! 🤕 ", message: "Sorry, An error occured. Please try again.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)

    }
    
   
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
