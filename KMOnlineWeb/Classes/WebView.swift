//
//  WebView.swift
//  KMOnlineWeb
//
//  Created by Ed on 2020/4/1.
//

import Foundation
import JavaScriptCore

protocol JSCallBackDelegate: NSObjectProtocol {
    func jsCallChatWithParameterDictionary(_ pDictionary: [String: AnyObject])
    func jsCallAudioOrVideoWithParameterDictionary(_ pDictionary: [String: AnyObject])
    func jsCallBack()
    func jsRefreshLoginInfo()
}

@objc protocol JSObjcCall: JSExport {
    func callChat(_ info: String)
    func callVideo(_ info: String)
    func backToNative()
    func getToken()
}

@objc class JSObjCModel: NSObject, JSObjcCall {
    weak var controller: WebView?
    weak var jsContext: JSContext?
    weak var delegate: JSCallBackDelegate?
    
    func ToDicFromJson(_ jsonStr: String) -> [String: AnyObject]? {
        if let data = jsonStr.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: AnyObject]
            } catch {
                print(error)
            }
        }
        return nil
    }
    
    func callChat(_ info: String) {
        if let dic = ToDicFromJson(info) {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.jsCallChatWithParameterDictionary(dic)
            }
        }
    }
    
    func callVideo(_ info: String) {
        if let dic = ToDicFromJson(info) {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.jsCallAudioOrVideoWithParameterDictionary(dic)
            }
        }
    }
    
    func backToNative() {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.jsCallBack()
        }
    }
    
    func getToken() {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.jsRefreshLoginInfo()
        }
    }
}

class WebView: UIView {
    var request: URLRequest!
    lazy var model: JSObjCModel = { JSObjCModel() }()
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.style = .gray
        activity.startAnimating()
        activity.isHidden = true
        return activity
    }()
    
    lazy var webView: UIWebView = {
        let web = UIWebView()
        web.delegate = self
        if #available(iOS 11.0, *) {
            web.scrollView.contentInsetAdjustmentBehavior = .never
        }
        return web
    }()
    
    public static let sharedInstance: WebView = { WebView() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let statusHeight = UIApplication.shared.statusBarFrame.size.height
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        webView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - statusHeight)
        addSubview(webView)
        addSubview(activityIndicatorView)
        activityIndicatorView.center = webView.center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUrl(url: URL) {
        request = URLRequest(url: url)
    }
    
    func setUrlStr(urlStr: String) {
        if let url = URL(string: urlStr) {
            request = URLRequest(url: url)
        }
    }
    
    func loadRequest() {
        webView.loadRequest(request)
    }
    
    public func refreshLoginInfoWithJSONString(_ loginInfoJSONStr: String) {
        if (model.jsContext?.objectForKeyedSubscript("newToken")) != nil {
            model.jsContext?.objectForKeyedSubscript("native")?.call(withArguments: [loginInfoJSONStr])
        }
    }
}

extension WebView: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityIndicatorView.isHidden = false
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicatorView.isHidden = true
        
        if let jsCallContext = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext {
            model.controller = self
            model.jsContext = jsCallContext
            jsCallContext.setObject(model, forKeyedSubscript: NSString(string: "android"))
            jsCallContext.setObject(model, forKeyedSubscript: NSString(string: "native"))
            jsCallContext.exceptionHandler = { _, exception in
                print("exception @%", exception as Any)
            }
        }
    }
}
