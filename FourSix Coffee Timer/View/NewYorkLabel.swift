//
//  NewYorkLabel.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 4/29/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit


class NewYorkLabel: UILabel {
    @IBInspectable var fontWeight: UIFont.Weight = .medium {
        didSet {
            setFont()
        }
    }
    
    @IBInspectable var metricsStyle: UIFont.TextStyle = .headline {
        didSet {
            setFont()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setFont()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setFont()
    }
    
    private func setFont() {
        let newYorkFont = UIFont.newYork(size: font.pointSize, weight: fontWeight)
        let metrics = UIFontMetrics(forTextStyle: metricsStyle)
        font = metrics.scaledFont(for: newYorkFont)
    }
}
