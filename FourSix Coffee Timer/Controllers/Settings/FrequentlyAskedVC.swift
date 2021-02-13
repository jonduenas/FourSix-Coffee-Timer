//
//  ViewController.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/21/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class FrequentlyAskedVC: UIViewController, Storyboarded {

    @IBOutlet var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "FAQ"

        if let url = Bundle.main.url(forResource: "faq", withExtension: "rtf") {
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
