//
//  CustomSlider.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 4/26/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class CustomSlider: UISlider {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        setImages()
    }
    
    private func setImages() {
        let insets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)

        let minTrackImage = UIImage(named: "slider-min")
        let minResizable = minTrackImage?.resizableImage(withCapInsets: insets)
        setMinimumTrackImage(minResizable, for: .normal)

        let maxTrackImage = UIImage(named: "slider-max")
        let maxResizable = maxTrackImage?.resizableImage(withCapInsets: insets)
        setMaximumTrackImage(maxResizable, for: .normal)
        
        setThumbImage(UIImage(named: "thumb-image"), for: .normal)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setImages()
    }
}
