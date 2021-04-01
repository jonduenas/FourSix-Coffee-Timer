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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
