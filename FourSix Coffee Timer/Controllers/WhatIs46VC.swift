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
    @IBOutlet var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadYoutube(videoID: "wmCW8xSWGZY")
        
        contentLabel.text = "\"A new coffee brewing theory created with the concept of 'easily-brewed delicious coffee for everyone.' Divide water into a ratio of 4 to 6. Adjust taste with the first 40% of water and density with the remaining 60%.\n\n\"The point is to use coarse grounds and make the second pour after the water from the first pour completely drips through.\"*"
    }
    
    func loadYoutube(videoID:String) {
        guard
            let youtubeURL = URL(string: "http://www.youtube.com/embed/\(videoID)?rel=0&cc_load_policy=1")
            else { return }
        webView.load(URLRequest(url: youtubeURL) )
    }

}