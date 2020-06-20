//
//  Timer.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/19/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

enum TimerState {
    case new
    case running
    case paused
}

class CoffeeTimer {
    
    private var startTime: Date?
    private var currentStepStartTime: Date?
    private var timer: Timer?
    var timerState: TimerState = .new
    var totalElapsedTime: TimeInterval = 0
    var currentStepElapsedTime: TimeInterval = 0
    
    func start() {
        switch timerState {
        case .new:
            //disable screen from sleeping while timer being used
            UIApplication.shared.isIdleTimerDisabled = true
            print("start")
            startTime = Date()
            currentStepStartTime = Date()
            timerState = .running
            print(timerState)
        case .paused:
            print("resume")
            startTime = Date().addingTimeInterval(-totalElapsedTime)
            currentStepStartTime = Date().addingTimeInterval(-currentStepElapsedTime)
            timerState = .running
            print(timerState)
        default:
            return
        }
    }
    
    func pause() {
        if timerState == .running {
            print("pause")
            timerState = .paused
            print(timerState)
        } else {
            return
        }
    }
    
    func nextStep() {
        currentStepStartTime = Date()
    }
    
    func runCoffeeTimer() {
        totalElapsedTime = -round(startTime?.timeIntervalSinceNow ?? 0)
        currentStepElapsedTime = -round(currentStepStartTime?.timeIntervalSinceNow ?? 0)
    }
}

extension TimeInterval {

    func stringFromTimeInterval() -> String {

        let time = NSInteger(abs(self))

        let seconds = time % 60
        let minutes = (time / 60) % 60

        return String(format: "%0.2d:%0.2d",minutes,seconds)

    }
}
