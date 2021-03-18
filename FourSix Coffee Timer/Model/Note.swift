//
//  Note.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/18/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import Foundation

struct Note: Hashable {
    let id: Int
    let date: String
    let rating: Int
    let noteText: String
}
