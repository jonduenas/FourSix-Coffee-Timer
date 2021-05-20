//
//  LoadingButton.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 7/15/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class LoadingButton: RoundButton {
    private var originalButtonText: String?
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        activityIndicator.color = titleColor(for: .normal)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    func showLoading() {
        originalButtonText = self.titleLabel?.text
        self.setTitle("", for: .normal)

        activityIndicator.startAnimating()

        self.isEnabled = false
    }

    func hideLoading() {
        self.setTitle(originalButtonText, for: .normal)

        activityIndicator.stopAnimating()

        self.isEnabled = true
    }
}
