//
//  TipView.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/12/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class TipView: UIView {
    var tipLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.text = ""
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()

    var tipPriceButton: LoadingButton = {
        let button = LoadingButton()
        button.setTitle("", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = UIColor(named: AssetsColor.accent.rawValue)
        button.cornerRadius = 22
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 44).isActive = true

        addSubview(tipLabel)
        addSubview(tipPriceButton)

        tipLabel.translatesAutoresizingMaskIntoConstraints = false
        tipLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tipLabel.trailingAnchor.constraint(equalTo: tipPriceButton.leadingAnchor, constant: 8).isActive = true
        tipLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        tipLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        tipPriceButton.translatesAutoresizingMaskIntoConstraints = false
        tipPriceButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 75).isActive = true
        tipPriceButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        tipPriceButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tipPriceButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        tipPriceButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}
