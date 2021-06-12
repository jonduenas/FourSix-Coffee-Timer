//
//  WebViewVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/11/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit
import WebKit

class WebViewVC: UIViewController {
    let webView = WKWebView()
    var progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.setProgress(0.0, animated: true)
        progressView.backgroundColor = .gray
        progressView.tintColor = UIColor(named: AssetsColor.accent.rawValue)
        return progressView
    }()
    var estimatedProgressObserver: NSKeyValueObservation?
    var urlString = ""
    var showTitle: Bool = false
    var titleObserver: NSKeyValueObservation?
    var backButton: UIBarButtonItem?
    var canGoBackObserver: NSKeyValueObservation?
    var forwardButton: UIBarButtonItem?
    var canGoForwardObserver: NSKeyValueObservation?

    override func loadView() {
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureToolbar()
        configureBackAndForwardButtons()
        configureProgressBar()

        if showTitle {
            titleObserver = webView.observe(\.title, options: [.new], changeHandler: { _, change in
                guard let newTitle = change.newValue else { return }
                self.navigationItem.title = newTitle
            })
        }

        webView.navigationDelegate = self
        webView.load(urlString)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        navigationController?.setToolbarHidden(false, animated: animated)
    }

    private func configureToolbar() {
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

        canGoBackObserver = webView.observe(\.canGoBack, options: [.new]) { _, change in
            guard let newValue = change.newValue else { return }
            self.backButton?.isEnabled = newValue
        }

        canGoForwardObserver = webView.observe(\.canGoForward, options: [.new], changeHandler: { _, change in
            guard let newValue = change.newValue else { return }
            self.forwardButton?.isEnabled = newValue
        })
    }

    private func configureProgressBar() {
        view.addSubview(progressBar)

        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
        progressBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        progressBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true

        estimatedProgressObserver = webView.observe(\.estimatedProgress, options: [.new], changeHandler: { _, change in
            self.updateProgressBar(change.newValue)
        })
    }

    private func updateProgressBar(_ progress: Double?) {
        guard let newProgress = progress else { return }

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
}

extension WebViewVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        AlertHelper.showAlert(title: "Error",
                              message: error.localizedDescription,
                              on: self)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        AlertHelper.showAlert(title: "Error Loading Webpage",
                              message: error.localizedDescription,
                              on: self)
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
