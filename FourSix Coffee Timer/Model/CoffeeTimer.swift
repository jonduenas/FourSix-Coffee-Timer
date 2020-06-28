//
//  CoffeeTimer.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 6/19/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import Foundation

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
    
    var currentElapsedPercentage: Double = 0
    var lastElapsedPercentage: Double = 0
    
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
        currentElapsedPercentage = 0
        lastElapsedPercentage = 0
    }
    
    func runCoffeeTimer() {
        totalElapsedTime = -round(startTime?.timeIntervalSinceNow ?? 0)
        currentStepElapsedTime = -round(currentStepStartTime?.timeIntervalSinceNow ?? 0)
    }
    
    func getCurrentElapsedPercentageFor(_ recipeInterval: Double) -> Double {
        lastElapsedPercentage = currentElapsedPercentage
        currentElapsedPercentage = currentStepElapsedTime / recipeInterval
        
        return currentElapsedPercentage
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
