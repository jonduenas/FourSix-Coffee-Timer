//
//  NewYorkLabel.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 4/29/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class NewYorkLabel: UILabel {
    @IBInspectable var fontWeight: String = "" {
        didSet {
            switch fontWeight {
            case "bold":
                weight = .bold
            case "medium":
                weight = .medium
            case "regular", "":
                weight = .regular
            case "semibold":
                weight = .semibold
            case "ultralight":
                weight = .ultraLight
            case "light":
                weight = .light
            case "thin":
                weight = .thin
            case "heavy":
                weight = .heavy
            case "black":
                weight = .black
            default:
                print("Error: NewYorkLabel - \(self) - fontWeight set to invalid case.")
                weight = .regular
            }

            convertFont()
        }
    }

    private var weight: UIFont.Weight = .regular
    private var sbFont: UIFont?

    override init(frame: CGRect) {
        super.init(frame: frame)

        if let font = font {
            sbFont = font
        }

        convertFont()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        if let font = font {
            sbFont = font
        }

        convertFont()
    }

    private func convertFont() {
        guard let originalFont = sbFont else { return }

        if let currentStyle = originalFont.fontDescriptor.fontAttributes[.textStyle] as? UIFont.TextStyle {
            font = UIFont.newYork(style: currentStyle, weight: weight)
            return
        }

        font = UIFont.newYork(size: originalFont.pointSize, weight: weight)
    }
}
