//
//  RatingStackView.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/22/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class RatingStackView: UIStackView {
    var rating: Int = 0 {
        didSet {
            setRating(rating)
        }
    }
    
    var maximumRating: Int = 5
    var offImage: UIImage? = UIImage(systemName: "star")
    var onImage: UIImage? = UIImage(systemName: "star.fill")
    var onColor: UIColor? = UIColor(named: AssetsColor.accent.rawValue)
    var offColor: UIColor? = UIColor(named: AssetsColor.accent.rawValue)

    private func image(for number: Int) -> UIImage {
        if number > rating {
            return offImage ?? UIImage()
        } else {
            return onImage ?? UIImage()
        }
    }
    
    private func imageView(for image: UIImage?) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.tintColor = onColor
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return imageView
    }
    
    func setRating(_ rating: Int) {
        if !arrangedSubviews.isEmpty {
            arrangedSubviews.forEach { $0.removeFromSuperview() }
        }
        
        for number in 1..<maximumRating + 1 {
            let ratingImage = image(for: number)
            let imageView = self.imageView(for: ratingImage)
            addArrangedSubview(imageView)
        }
    }
}
