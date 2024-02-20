//
//
//  TokenServiceViewController.swift
//  Heartland-iOS-SDK
//
    

import Foundation
import WebKit

class TokenServiceViewController: UIViewController {
    var webView: WKWebView!
    var html: String?
    var completion: HpsTokenServiceWebCompletionHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView(frame: self.view.frame)
        let contentController = self.webView.configuration.userContentController
        contentController.add(self, name: "cardFormMessageHandler")
        
        self.view.addSubview(webView)
        
        if let html = html {
            webView.loadHTMLString(html, baseURL: URL(string: "https://api.heartlandportico.com")!)
        }
    }
}

extension TokenServiceViewController: WKScriptMessageHandler{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let dict = message.body as? [String : AnyObject] else {
            self.completion?(nil)
            return
        }

        self.completion?(dict)
    }
}
