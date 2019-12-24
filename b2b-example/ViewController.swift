//
//  ViewController.swift
//  b2b-example
//
//  Created by Minh Truong on 12/24/19.
//  Copyright © 2019 Minh Truong. All rights reserved.
//

import UIKit
import CryptoSwift

class ViewController: UIViewController {
    @IBOutlet weak var partnerIdTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        partnerIdTextField.text = "hien001"
        nameTextField.text = "Hiền Nguyễn"
    }
    
    @IBAction func start() {
        let partnerId = partnerIdTextField.text ?? ""
        let name = nameTextField.text ?? ""
        
        if partnerId.isEmpty {
            partnerIdTextField.becomeFirstResponder()
            return
        }
        
        if name.isEmpty {
            nameTextField.becomeFirstResponder()
            return
        }
        view.endEditing(true)
        guard let url = generateURL(partnerId: partnerId, name: name) else {
            print("GenerateURL error")
            return
        }
        
        // Show Cashback viewcontroller
        let vc = CashbackViewController(nibName: "CashbackViewController", bundle: nil)
        vc.url = url
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.isTranslucent = false
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.shadowImage = UIImage()
        nav.navigationBar.barTintColor = UIColor.mainColor
        nav.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        nav.navigationBar.tintColor = UIColor.white
        DispatchQueue.main.async {
            self.present(nav, animated: true, completion: nil)
        }
        
    }
}

extension ViewController {
    func generateURL(partnerId: String, name: String) -> URL? {
        let timestamp = Int64(Date().timeIntervalSince1970)
        let privateKey = "Q2FzaGJhZy1WaW5pZC1Ub2tlbg==" // Sẽ được cashbag cung cấp khi tích hợp
        let tokenString =  partnerId + name + privateKey + "\(timestamp)"
        let token = tokenString.sha256()
        var components = URLComponents()
        components.scheme = "https"
        components.host = "dev-webview.cashbagb2b.vn" // Sẽ được cashbag cung cấp khi tích hợp
        components.queryItems = [
            URLQueryItem(name: "partnerId", value: partnerId),
            URLQueryItem(name: "name", value: name),
            URLQueryItem(name: "timestamp", value: "\(timestamp)"),
            URLQueryItem(name: "token", value: token)
        ]
        return components.url
    }
}

extension UIColor {
    public convenience init(r: Int, g: Int, b: Int, a: CGFloat = 1) {
        let red   = max(0, min(CGFloat(r)/255, 1))
        let green = max(0, min(CGFloat(g)/255, 1))
        let blue  = max(0, min(CGFloat(b)/255, 1))
        let alpha = max(0, min(a, 1))
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static var mainColor: UIColor = UIColor(r: 182, g: 46, b: 52)
}


