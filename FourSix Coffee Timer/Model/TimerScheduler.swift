//
//  TimerScheduler.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 9/24/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import Foundation

public protocol TimerScheduling {
    func start(timeInterval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void)
    func invalidate()
}

class TimerScheduler: TimerScheduling {
    
    private weak var timer: Timer?
    
    deinit {
        timer = nil
    }
    
    func start(timeInterval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: repeats, block: block)
    }
    
    func invalidate() {
        timer?.invalidate()
    }
}

