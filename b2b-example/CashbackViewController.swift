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
        

        let config = WKWebViewConfiguration()
        config.userContentController.add(self, name: "jsMessageHandler")
        
        let web = WKWebView(frame: CGRect.zero, configuration: config)
        webContentView.addSubview(web)
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
extension CashbackViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "jsMessageHandler" {
            guard let ms = message.body as? String else { return }
            guard let data = ms.data(using: .utf8) else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:String] {
                   guard let type = json["type"], let value = json["value"] else { return }
                    print("-- value: ", value)
                   var url: URL?
                   if type == "open_affiliate_link", let url_ = URL(string: value) {
                       url = url_
                   }
                   if type == "open_tel_link", let url_ = URL(string: "tel:\(value)") {
                       url = url_
                   }

                   guard url != nil else { return }
                   if UIApplication.shared.canOpenURL(url!) {
                       UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                   }
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
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
