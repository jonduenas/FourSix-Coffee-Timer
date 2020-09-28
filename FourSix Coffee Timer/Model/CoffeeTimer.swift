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
    case done
}

class CoffeeTimer {
    
    enum Constants {
        static let timerInterval: TimeInterval = 0.25
    }
    
    enum TimerUpdate {
        case tick(step: TimeInterval, total: TimeInterval)
        case countdown(_: Int)
        case nextStep(step: TimeInterval, total: TimeInterval)
        case done
        case error
    }
    
    let timerScheduler: TimerScheduling
    
    private var startTime: Date?
    private var currentStepStartTime: Date?
    
    private(set) var timerState: TimerState!
    private let recipeStepInterval: TimeInterval = 45
    private(set) var totalElapsedTime: TimeInterval = 0
    private(set) var currentStepElapsedTime: TimeInterval = 0
    var recipe: Recipe
    var timerUpdateCallback: ((TimerUpdate) -> Void)!
    var countdownUpdateCallback: ((TimerUpdate) -> Void)!
    
    var fromPercentage: CGFloat = 0
    var toPercentage: CGFloat = 0
    private(set) var recipeIndex = 0
    private(set) var countdownTime: Int
    var stepsActualTime = [TimeInterval]()
    
    init(timerState: TimerState = .countdown, timerScheduler: TimerScheduling, recipe: Recipe, countdownTime: Int = 3) {
        self.timerScheduler = timerScheduler
        self.recipe = recipe
        self.timerState = timerState
        self.countdownTime = countdownTime
    }
    
    func start(timerUpdate: @escaping ((TimerUpdate) -> Void)) {
        switch timerState {
        case .new:
            print("start")
            startTime = Date()
            currentStepStartTime = Date()
            timerState = .running
            timerUpdateCallback = timerUpdate
            timerScheduler.start(timeInterval: Constants.timerInterval, repeats: true) { [weak self] _ in
                self?.runCoffeeTimer()
            }
        case .paused:
            print("resume")
            startTime = Date().addingTimeInterval(-totalElapsedTime)
            currentStepStartTime = Date().addingTimeInterval(-currentStepElapsedTime)
            timerState = .running
            timerUpdateCallback = timerUpdate
            timerScheduler.start(timeInterval: Constants.timerInterval, repeats: true) { [weak self] _ in
                self?.runCoffeeTimer()
            }
        default:
            timerUpdate(.error)
            return
        }
    }
    
    func pause() {
        if timerState == .running {
            print("pause")
            timerState = .paused
            timerScheduler.invalidate()
        } else {
            return
        }
    }
    
    func nextStep() {
        if recipeIndex < recipe.waterPours.count - 1 {
            recipeIndex += 1
            currentStepStartTime = Date()
            stepsActualTime.append(currentStepElapsedTime)
            currentStepElapsedTime = 0
            timerUpdateCallback(.nextStep(step: currentStepElapsedTime, total: totalElapsedTime))
        } else {
            endTimer()
        }
    }
    
    private func runCoffeeTimer() {
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
    
    func startCountdownTimer(countdownUpdate: @escaping (TimerUpdate) -> Void) {
        countdownUpdateCallback = countdownUpdate
        timerScheduler.start(timeInterval: 1, repeats: true) { [weak self] _ in
            self?.countdown()
        }
    }
    
    private func countdown() {
        if countdownTime > 1 {
            countdownTime -= 1
            countdownUpdateCallback(.countdown(countdownTime))
        } else {
            countdownUpdateCallback(.done)
            timerScheduler.invalidate()
            timerState = .new
        }
    }
    
    func endTimer() {
        timerState = .done
        timerScheduler.invalidate()
        timerUpdateCallback(.done)
    }
    
    func cancelTimer() {
        timerScheduler.invalidate()
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
