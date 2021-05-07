//
//  RatingStackView.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/7/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class RatingStackView: UIStackView {
    @IBInspectable var starSize: CGSize = CGSize(width: 18, height: 18) {
        didSet {
            setupImages()
        }
    }
    
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupImages()
        }
    }
    
    var rating: Int = 0 {
        didSet {
            setupImages()
        }
    }
    
    private var ratingImages: [UIImageView] = []
    private var offImage: UIImage? = UIImage(systemName: "star", withConfiguration: UIImage.SymbolConfiguration(scale: .small))
    private var onImage: UIImage? = UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .small))
    @IBInspectable var color: UIColor? = UIColor(named: AssetsColor.accent.rawValue) {
        didSet {
            setupImages()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImages()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupImages()
    }
    
    private func setupImages() {
        // Clear existing images
        for image in ratingImages {
            removeArrangedSubview(image)
            image.removeFromSuperview()
        }
        
        ratingImages.removeAll()
        
        let offCount = starCount - rating
        
        // Create new images
        for _ in 0..<rating {
            let imageView = createImageView(with: onImage)
            addArrangedSubview(imageView)
            ratingImages.append(imageView)
        }
        
        for _ in 0..<offCount {
            let imageView = createImageView(with: offImage)
            addArrangedSubview(imageView)
            ratingImages.append(imageView)
        }
    }
    
    private func createImageView(with image: UIImage?) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
        return imageView
    }
}
