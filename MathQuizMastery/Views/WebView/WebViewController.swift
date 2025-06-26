//
//  WebViewController.swift
//  MathQuizMastery
//
//  Created by AydınKaya on 26.06.2025.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var urlString: String?
    var navigationTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        title = navigationTitle
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(closeTapped))
        
        if let urlString = urlString,
           let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    @objc func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
}
