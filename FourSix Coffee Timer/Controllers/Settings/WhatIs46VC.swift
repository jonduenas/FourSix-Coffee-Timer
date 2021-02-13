//
//  WhatIs46VC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/10/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit
import WebKit

class WhatIs46VC: UIViewController, Storyboarded {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadYoutube(videoID: "wmCW8xSWGZY")
        
        contentLabel.text = "FourSix is named after a method of brewing coffee called the \"4:6 method\" invented by Tetsu Kasuya, former World Brewer's Champion.\n\n4:6 is \"a new coffee brewing theory created with the concept of 'easily-brewed delicious coffee for everyone.' Divide water into a ratio of 4 to 6. Adjust taste with the first 40% of water and density with the remaining 60%.\n\n\"The point is to use coarse grounds and make the second pour after the water from the first pour completely drips through.\"*"
    }
    
    func loadYoutube(videoID: String) {
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)?rel=0&cc_load_policy=1") else { return }
        webView.load(URLRequest(url: youtubeURL) )
    }
}
