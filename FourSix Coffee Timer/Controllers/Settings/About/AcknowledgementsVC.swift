//
//  AcknowledgementsVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/29/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class AcknowledgementsVC: UITableViewController, Storyboarded {

    @IBOutlet var ackLabel1: UILabel!
    @IBOutlet var ackLabel2: UILabel!
    @IBOutlet var ackLabel4: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 240

        ackLabel1.text = "4:6 Method invented by Tetsu Kasuya."
        ackLabel2.text = "Timer sound effect is \"Up Chime 2\" by FoolBoyMedia used under Creative Commons Attribution License 3.0."
        // swiftlint:disable:next line_length
        ackLabel4.text = "Purchases Copyright (c) 2017 Jacob Eiting, used under the MIT License, details of which can be found in System Settings > FourSix."
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
