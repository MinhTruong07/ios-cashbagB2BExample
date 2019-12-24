//
//  CashbackViewController.swift
//  b2b-example
//
//  Created by Minh Truong on 12/24/19.
//  Copyright © 2019 Minh Truong. All rights reserved.
//

import UIKit
import WebKit

class CashbackViewController: UIViewController {
    @IBOutlet fileprivate weak var webContentView: UIView!
    
    lazy var backButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "ic-back"), style: .plain, target: self, action: #selector(close))
    }()
    
    weak var webView: WKWebView!
    var url: URL!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hoàn tiền"
        navigationItem.leftBarButtonItem = backButton
        
        let web = WKWebView()
        webContentView.addSubview(web)
        web.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        web.translatesAutoresizingMaskIntoConstraints = false
        web.topAnchor.constraint(equalTo: webContentView.topAnchor).isActive = true
        web.bottomAnchor.constraint(equalTo: webContentView.bottomAnchor).isActive = true
        web.leadingAnchor.constraint(equalTo: webContentView.leadingAnchor).isActive = true
        web.trailingAnchor.constraint(equalTo:webContentView.trailingAnchor).isActive = true
        webView = web
        
        // Load URL
        webView.load(URLRequest(url: url))
        print("Start load URL: ", url ?? "")
        //
    }
    
    @objc fileprivate func close() {
        dismiss(animated: true, completion: nil)
    }
}

// Detected URL
extension CashbackViewController {
    // ?cashback_aff_url={url}
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
      if keyPath == #keyPath(WKWebView.url) {
        guard let url = webView.url else { return }
        if let querry = url.queryParameters {
            if querry["cashback_aff_url"] != nil && querry["cashback_aff_url"] != ""  { // detect cashback url
                guard let cashbackURL = URL(string: querry["cashback_aff_url"]!) else { return }
                UIApplication.shared.open(cashbackURL, options: [:], completionHandler: nil)
                webView.stopLoading()
            }
        }
      }
    }
}


// URL Extension
extension URL {
    var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}
