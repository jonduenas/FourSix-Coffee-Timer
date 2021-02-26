//
//  TimerScheduling.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 2/26/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import Foundation

public protocol TimerScheduling {
    func start(timeInterval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void)
    func invalidate()
}
