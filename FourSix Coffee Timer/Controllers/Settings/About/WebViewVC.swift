//
//  WebViewVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/11/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit
import WebKit

class WebViewVC: UIViewController, WKNavigationDelegate {
    let webView = WKWebView()
    var progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.setProgress(0.0, animated: true)
        progressView.backgroundColor = .gray
        progressView.tintColor = UIColor(named: AssetsColor.accent.rawValue)
        return progressView
    }()
    
    var urlString = ""
    var showTitle: Bool = false
    var backButton: UIBarButtonItem?
    var forwardButton: UIBarButtonItem?
    
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureToolbar()
        configureBackAndForwardButtons()
        configureProgressBar()
        
        if showTitle {
            webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        }
        
        webView.navigationDelegate = self
        webView.load(urlString)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setToolbarHidden(true, animated: animated)
    }
    
    private func configureToolbar() {
        navigationController?.setToolbarHidden(false, animated: false)
        navigationController?.toolbar.tintColor = UIColor(named: AssetsColor.accent.rawValue)
        
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left")!,
            style: .plain,
            target: self.webView,
            action: #selector(WKWebView.goBack))
        let forwardButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.right")!,
            style: .plain,
            target: self.webView,
            action: #selector(WKWebView.goForward))
        let reloadButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.counterclockwise")!,
            style: .plain,
            target: self.webView,
            action: #selector(WKWebView.reload))
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)
        
        toolbarItems = [backButton,
                        forwardButton,
                        flexibleSpace,
                        reloadButton]
        
        self.backButton = backButton
        self.forwardButton = forwardButton
    }
    
    private func configureBackAndForwardButtons() {
        backButton?.isEnabled = webView.canGoBack
        forwardButton?.isEnabled = webView.canGoForward
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoBack), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoForward), options: .new, context: nil)
    }
    
    private func configureProgressBar() {
        view.addSubview(progressBar)
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
        progressBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        progressBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    private func updateProgressBar() {
        let newProgress = self.webView.estimatedProgress
        
        // Only animate moving forward
        if Float(newProgress) > progressBar.progress {
            progressBar.setProgress(Float(newProgress), animated: true)
        } else {
            progressBar.setProgress(Float(newProgress), animated: false)
        }
        
        // Hides progress bar when finished
        if newProgress >= 1 {
            // Delaying so that user can see progress view reach 100%
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                self.progressBar.isHidden = true
            })
        } else {
            progressBar.isHidden = false
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let webView = object as? WKWebView, webView == self.webView else { return }
        
        switch keyPath {
        case #keyPath(WKWebView.canGoBack):
            self.backButton?.isEnabled = self.webView.canGoBack
        case #keyPath(WKWebView.canGoForward):
            self.forwardButton?.isEnabled = self.webView.canGoForward
        case #keyPath(WKWebView.estimatedProgress):
            updateProgressBar()
        case #keyPath(WKWebView.title):
            navigationItem.title = webView.title
        default:
            return
        }
    }
}

extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}
