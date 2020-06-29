//
//  AcknowledgementsVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/29/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class AcknowledgementsVC: UIViewController {

    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = "4:6 Method invented by Tetsu Kasuya.\n\nTimer sound effect is \"Up Chime 2\" by FoolBoyMedia used under Creative Commons Attribution License 3.0."
    }
}
