//
//  WhatIs46VC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/10/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit
import WebKit

class WhatIs46VC: UIViewController {

    @IBOutlet var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        loadYoutube(videoID: "wmCW8xSWGZY")
    }
    
    func loadYoutube(videoID:String) {
        guard
            let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)?rel=0&cc_load_policy=1")
            else { return }
        webView.load(URLRequest(url: youtubeURL) )
    }

}
