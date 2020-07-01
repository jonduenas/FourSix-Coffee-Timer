//
//  CoffeeTimer.swift
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
    case countdown
}

class CoffeeTimer {
    
    private var startTime: Date?
    private var currentStepStartTime: Date?
    private var timer: Timer?
    var timerState: TimerState = .new
    var recipeStepInterval: TimeInterval = 45
    var totalElapsedTime: TimeInterval = 0
    var currentStepElapsedTime: TimeInterval = 0
    
    var fromPercentage: CGFloat = 0
    var toPercentage: CGFloat = 0
    
    func start() {
        switch timerState {
        case .new:
            print("start")
            startTime = Date()
            currentStepStartTime = Date()
            timerState = .running
        case .paused:
            print("resume")
            startTime = Date().addingTimeInterval(-totalElapsedTime)
            currentStepStartTime = Date().addingTimeInterval(-currentStepElapsedTime)
            timerState = .running
        default:
            return
        }
    }
    
    func pause() {
        if timerState == .running {
            print("pause")
            timerState = .paused
        } else {
            return
        }
    }
    
    func nextStep() {
        currentStepStartTime = Date()
        currentStepElapsedTime = 0
    }
    
    func runCoffeeTimer() {
        let newCurrentStepElapsedTime = abs(currentStepStartTime?.timeIntervalSinceNow ?? 0)
        
        fromPercentage = CGFloat(currentStepElapsedTime) / CGFloat(recipeStepInterval)
        toPercentage = CGFloat(newCurrentStepElapsedTime) / CGFloat (recipeStepInterval)
        
        totalElapsedTime = abs(startTime?.timeIntervalSinceNow ?? 0)
        currentStepElapsedTime = newCurrentStepElapsedTime
    }
}

extension TimeInterval {

    func stringFromTimeInterval() -> String {

        let time = Int(ceil(self))

        let seconds = time % 60
        let minutes = (time / 60) % 60

        return String(format: "%0.2d:%0.2d",minutes,seconds)

    }
}
