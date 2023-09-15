//
//  MarvelHeroWebView.swift
//  ComicCosmos
//
//  Created by Benjamin Simpson on 9/6/23.
//

import UIKit
import WebKit

class MarvelHeroWebView: UIViewController, WKUIDelegate {
    
    var url: String? = nil
        
        lazy var webView: WKWebView = {
            let webConfiguration = WKWebViewConfiguration()
            let webView = WKWebView(frame: .zero, configuration: webConfiguration)
            webView.uiDelegate = self
            webView.translatesAutoresizingMaskIntoConstraints = false
            return webView
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupView()
            openWeb(from: url!)
        }
        
        func setupView() {
            self.view.addSubview(webView)
            webView.frame = self.view.bounds
        }
    
        func openWeb(from url: String) {
            let myURL = URL(string: url)
            let request = URLRequest(url: myURL!)
            webView.load(request)
        }
        
        
}
