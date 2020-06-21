//
//  ViewController.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/21/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class TroubleshootingVC: UIViewController {

    @IBOutlet var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = Bundle.main.url(forResource: "troubleshooting", withExtension: "rtf")!
        let opts: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.rtf]
        let string = try! NSAttributedString(url: url, options: opts, documentAttributes: nil)
        contentLabel.attributedText = string
    }
}
