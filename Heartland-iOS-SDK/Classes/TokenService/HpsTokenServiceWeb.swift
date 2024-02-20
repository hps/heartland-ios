//
//
//  HpsTokenService.swift
//  Heartland-iOS-SDK
//
    

import Foundation
import WebKit

public typealias HpsTokenServiceWebCompletionHandler = (_ response: [String : AnyObject]?) -> Void

public class HpsTokenServiceWeb {
    public init() {}
    
    public func tokenServiceWebView(completion: HpsTokenServiceWebCompletionHandler?) throws -> UIViewController? {
        if let pathURL = Bundle(identifier: "com.heartland.Heartland-iOS-SDK")?.path(forResource: "TokenService", ofType: "html") {
            let html = try String(contentsOfFile: pathURL)
            return self.tokenServiceWebView(html: html, completion: completion)
        }
        
        return nil
    }
    
    public func tokenServiceWebView(html: String, completion: HpsTokenServiceWebCompletionHandler?) -> UIViewController? {
        let vc = TokenServiceViewController()
        vc.html = html
        vc.completion = completion
        return vc
    }
}
