//
//  HowToVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/21/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class HowToVC: UIViewController {

    @IBOutlet var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = Bundle.main.url(forResource: "howto", withExtension: "rtf") {
            do {
                let opts: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.rtf]
                let string = try NSAttributedString(url: url, options: opts, documentAttributes: nil)
                contentLabel.attributedText = string
            } catch {
                print("Contents couldn't be loaded. Error: \(Error.self)")
            }
        } else {
            print("File not found.")
        }
    }
}
