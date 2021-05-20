//
//  TextFieldTableCell.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/6/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

protocol TextFieldCellDelegate: AnyObject {
    func textField(_ textField: UITextField, didUpdateTo string: String)
}

class TextFieldTableCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()

        cellTextField.textColor = .secondaryLabel
    }
}
