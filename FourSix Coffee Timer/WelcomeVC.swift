//
//  ViewController.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/20/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func infoButton(_ sender: Any) {
    }
    
    @IBAction func brewButton(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Start")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
}

