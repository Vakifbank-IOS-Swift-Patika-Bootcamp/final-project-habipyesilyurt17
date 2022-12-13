//
//  WebViewVC.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 13.12.2022.
//

import UIKit
import WebKit

final class WebViewVC: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!
    var urlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let urlString = urlString else { return }
        if let url = URL(string: urlString) {
            webView.navigationDelegate = self
            webView.load(URLRequest(url: url))
        }
    }
}
