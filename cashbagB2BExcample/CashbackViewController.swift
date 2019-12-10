//
//  CashbackViewController.swift
//  cashbagB2BExcample
//
//  Created by Minh Truong on 12/10/19.
//  Copyright © 2019 Minh Truong. All rights reserved.
//

import UIKit
import WebKit

class CashbackViewController: UIViewController {
    
    weak var webView: WKWebView!
    private let mainURL: String = "http://192.168.1.53:3000"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hoàn tiền"
        startLoadURL()
    }
}

extension CashbackViewController {
    fileprivate func startLoadURL() {
        guard let url = URL(string: mainURL) else { return }
        if webView == nil {
            let web = WKWebView(frame: view.frame)
            view.addSubview(web)
            webView = web
        }
        webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        webView.load(URLRequest(url: url))
    }
}

extension CashbackViewController {
    // ?cashback_aff_url={url}
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
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
