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
    
    enum Constants {
        static let timerInterval: TimeInterval = 0.25
    }
    
    enum TimerUpdate {
        case tick(step: TimeInterval, total: TimeInterval)
        case nextStep(step: TimeInterval, total: TimeInterval)
        case done
    }
    
    private var startTime: Date?
    private var currentStepStartTime: Date?
    private var timer: Timer!
    private var countdownTimer: Timer!
    var timerState: TimerState = .new
    private let recipeStepInterval: TimeInterval = 45
    var totalElapsedTime: TimeInterval = 0
    var currentStepElapsedTime: TimeInterval = 0
    var recipe: Recipe
    var timerUpdateCallback: ((TimerUpdate) -> Void)!
//    var timerEndedCallback: (() -> Void)!
    var countdownEndedCallback: (() -> Void)!
//    var nextStepCallback: ((_ stepElapsedTime: TimeInterval, _ totalElapsedTime: TimeInterval) -> Void)!
//    var timerInProgressCallback: ((_ stepElapsedTime: TimeInterval, _ totalElapsedTime: TimeInterval) -> Void)!
    var countdownInProgressCallback: ((_ countdown: Int) -> Void)!
    
    var fromPercentage: CGFloat = 0
    var toPercentage: CGFloat = 0
    var recipeIndex = 0
    var startCountdown = 3
    var stepsActualTime = [TimeInterval]()
    
    init(recipe: Recipe) {
        timer = Timer()
        self.recipe = recipe
    }
    
    func start(timerUpdate: @escaping ((TimerUpdate) -> Void)) {
        switch timerState {
        case .new:
            print("start")
            startTimer()
            startTime = Date()
            currentStepStartTime = Date()
            timerState = .running
            timerUpdateCallback = timerUpdate
        case .paused:
            print("resume")
            startTimer()
            startTime = Date().addingTimeInterval(-totalElapsedTime)
            currentStepStartTime = Date().addingTimeInterval(-currentStepElapsedTime)
            timerState = .running
            timerUpdateCallback = timerUpdate
        default:
            return
        }
    }
    
    func pause() {
        if timerState == .running {
            print("pause")
            timerState = .paused
            timer.invalidate()
            timer = nil
        } else {
            return
        }
    }
    
    func nextStep() {
        if recipeIndex < recipe.waterPours.count - 1 {
            currentStepStartTime = Date()
            stepsActualTime.append(currentStepElapsedTime)
            currentStepElapsedTime = 0
            timerUpdateCallback(.nextStep(step: currentStepElapsedTime, total: totalElapsedTime))
        } else {
            endTimer()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: Constants.timerInterval, target: self, selector: #selector(runCoffeeTimer), userInfo: nil, repeats: true)
    }
    
    func startCountdownTimer(countdownTimerEnded: @escaping () -> Void, countdownInProgress: @escaping (_ countdown: Int) -> Void) {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        countdownEndedCallback = countdownTimerEnded
        countdownInProgressCallback = countdownInProgress
    }
    
    @objc func runCoffeeTimer() {
        let newCurrentStepElapsedTime = abs(currentStepStartTime?.timeIntervalSinceNow ?? 0)
        
        fromPercentage = CGFloat(currentStepElapsedTime) / CGFloat(recipeStepInterval)
        toPercentage = CGFloat(newCurrentStepElapsedTime) / CGFloat(recipeStepInterval)
        
        totalElapsedTime = abs(startTime?.timeIntervalSinceNow ?? 0)
        currentStepElapsedTime = newCurrentStepElapsedTime
        
        //Check if end of recipe's set interval
        if currentStepElapsedTime < recipe.interval - Constants.timerInterval {
            // Continue counting - send elapsed time to closure
            timerUpdateCallback(.tick(step: currentStepElapsedTime, total: totalElapsedTime))
        } else {
            // End of interval - Check if user has set auto-advance on
            if UserDefaultsManager.timerStepAdvance == 0 {
                // Check if end of recipe
                if recipeIndex < recipe.waterPours.count - 1 {
                    // Move to next step
                    nextStep()
                } else {
                    // End timer
                    endTimer()
                }
            } else {
                timerUpdateCallback(.tick(step: currentStepElapsedTime, total: totalElapsedTime))
            }
        }
    }
    
    @objc func countdown() {
        if startCountdown > 1 {
            startCountdown -= 1
            countdownInProgressCallback(startCountdown)
        } else {
            countdownEndedCallback()
            countdownTimer.invalidate()
            countdownTimer = nil
        }
    }
    
    func endTimer() {
        timer.invalidate()
        timer = nil
        timerUpdateCallback(.done)
    }
    
    func cancelTimer() {
        timer.invalidate()
        timer = nil
    }
}

extension TimeInterval {

    func stringFromTimeInterval() -> String {

        let time = Int(ceil(self))

        let seconds = time % 60
        let minutes = (time / 60) % 60

        return String(format: "%0.2d:%0.2d", minutes, seconds)

    }
}
