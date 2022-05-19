//
//  WebViewController.swift
//  MakeStep
//
//  Created by novotorica on 29.09.2021.
//

import Foundation
import UIKit
import WebKit


class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate  {
    
    var webKitView: WKWebView = {
        var web = WKWebView()
        return web
    }()
    
    var url: String? = nil
    var urlTitles: String = ""
    private var keyValueObservations: [NSKeyValueObservation] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webKitView)
        webKitView.fillSuperview()
        webKitView.navigationDelegate = self
        webKitView.uiDelegate = self
        webKitView.configuration.preferences.javaScriptEnabled = true
        webKitView.allowsBackForwardNavigationGestures = true
        
        if let webPageUrl = URL(string: url ?? "") {
            loadPage(url: webPageUrl)
        }
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(image: #imageLiteral(resourceName: "backButton"), style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = newBackButton
        guard let url = url else { return }

        self.navigationItem.title = self.separateURL(url: url)
        
        keyValueObservations.append(webKitView.observe(\.title, options: [.new]) { [weak self] _, change in
            guard let urlTitle = change.newValue else { return }
 
                self?.navigationItem.title = urlTitle
        
            
        })
    }
    
    @objc func back() {
        if(webKitView.canGoBack) {       
            webKitView.goBack()
            } else {
                self.navigationController?.popViewController(animated:true)
            }
        }
    
    private func loadPage(url: URL) {
        let urlRequest = URLRequest.init(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        webKitView.load(urlRequest)
    }
    
    private func separateURL(url:String) -> String {
        let items = url.components(separatedBy: "/")
        guard let title = items.last else { return ""}
        return title
    }
}
