//
//  DetailViewController.swift
//  Project 16
//
//  Created by Артём Бурмистров on 4/11/20.
//  Copyright © 2020 Артём Бурмистров. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {
    var safariView: WKWebView!
    var cityName: String!
    
    override func loadView() {
        safariView = WKWebView()
        safariView.navigationDelegate = self
        view = safariView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = cityName
        
        if let url = URL(string: "https://en.wikipedia.org/wiki/\(cityName ?? "")") {
            safariView.load(URLRequest(url: url))
        }
    }
}
