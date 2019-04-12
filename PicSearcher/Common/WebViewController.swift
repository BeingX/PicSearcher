//
//  WebViewController.swift
//  PicSearcher
//
//  Created by 尹啟星 on 2019/4/12.
//  Copyright © 2019 xingxing. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    @objc let webView = WKWebView()
    var urlString: String?
    var htmlString: String?
    var progressView: UIProgressView = {
        let view = UIProgressView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.size.width, height: 4))
        view.tintColor = UIConstants.systemColor
        view.trackTintColor = UIColor.White100
        view.progress = 0.0
        return view
    }()
    override func loadView() {
        self.view = webView
    }
    init(urlString: String) {
        super.init(nibName: nil, bundle: nil)
        self.urlString = urlString
    }
    
    convenience init(htmlString: String) {
        self.init(urlString: "")
        self.htmlString = htmlString
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let urlStr = urlString, let url = URL(string: urlStr) {
            let request = URLRequest(url: url)
            webView.load(request)
        } else if let htmlStr = htmlString {
            webView.loadHTMLString(htmlStr, baseURL: nil)
        }
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        self.navigationController?.navigationBar.addSubview(progressView)
        
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            let progress = Float(webView.estimatedProgress)
            progressView.progress = progress
            if progress == 1.0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.progressView.isHidden = true
                }
            } else {
                progressView.isHidden = false
            }
        }
    }
}
