//
//  ProductLinkViewController.swift
//  HotdogOrNot
//
//  Created by SP21 on 6/6/18.
//  Copyright © 2018 ucu.joliu. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class ProductLinkViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    var productURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        let myRequest = URLRequest(url: productURL)
        webView.load(myRequest)
        SVProgressHUD.show()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
