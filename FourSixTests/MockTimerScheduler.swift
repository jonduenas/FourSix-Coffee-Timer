//
//  MockTimerScheduler.swift
//  FourSixTests
//
//  Created by Jon Duenas on 9/24/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import Foundation
import FourSix

class MockTimerScheduler: TimerScheduling {

    var timeIntervalPassed: TimeInterval?
    var repeatsPassed: Bool?
    var blockPassed: ((Timer) -> Void)?
    var invalidateCalled = false
    var startCalled = false

    func start(timeInterval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) {
        startCalled = true
        timeIntervalPassed = timeInterval
        repeatsPassed = repeats
        blockPassed = block
        let timer = Timer(timeInterval: timeInterval, repeats: repeats, block: block)
        block(timer)
    }

    func invalidate() {
        invalidateCalled = true
    }
}
