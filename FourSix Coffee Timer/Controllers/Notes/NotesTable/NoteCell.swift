//
//  NoteCell.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/17/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var recipeLabel: UILabel!
    @IBOutlet weak var coffeeLabel: UILabel!
    @IBOutlet weak var waterLabel: UILabel!
    @IBOutlet weak var ratingStackView: RatingControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initializeFonts()
        setSelectedBackgroundColor()
    }
    
    private func initializeFonts() {
        monthLabel.font = UIFont.newYork(size: 18, weight: .regular)
        dayLabel.font = UIFont.newYork(size: 44, weight: .medium)
    }
    
    private func setSelectedBackgroundColor() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(named: AssetsColor.separator.rawValue)
        selectedBackgroundView = backgroundView
    }
}
