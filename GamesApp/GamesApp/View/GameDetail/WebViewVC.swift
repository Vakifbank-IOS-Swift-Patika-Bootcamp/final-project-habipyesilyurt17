//
//  WebViewVC.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 14.12.2022.
//

import UIKit
import WebKit

final class WebViewVC: BaseVC, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!
    var urlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let urlString = urlString else { return }
        if let url = URL(string: urlString) {
            webView.navigationDelegate = self
            webView.uiDelegate = self
            webView.load(URLRequest(url: url))
        }
    }
}

extension WebViewVC: WKUIDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if error.localizedDescription != "" {
            showErrorAlert(message: error.localizedDescription) {
            }
        }
    }
}
