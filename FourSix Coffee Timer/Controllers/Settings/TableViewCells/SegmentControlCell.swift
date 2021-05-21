//
//  SegmentControlCell.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/26/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class SegmentControlCell: UITableViewCell {
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellSegmentedControl: UISegmentedControl!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureSegmentControl(options: [String]) {
        cellSegmentedControl.removeAllSegments()

        for (index, segment) in options.enumerated() {
            cellSegmentedControl.insertSegment(withTitle: segment, at: index, animated: false)
        }
    }
}
