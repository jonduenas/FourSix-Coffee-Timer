//
//  SettingsDelegate.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/6/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

protocol SettingsPresenting {
    func selectedCell(row: Int)
}

class SettingsDelegate: NSObject, UITableViewDelegate {
    var parentController: SettingsPresenting?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        parentController?.selectedCell(row: indexPath.row)
    }
}
