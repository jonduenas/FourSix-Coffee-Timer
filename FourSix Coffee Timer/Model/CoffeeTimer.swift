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
    
    let recipe: Recipe
    private let timerScheduler: TimerScheduling
    private let recipeStepInterval: TimeInterval
    
    private var startTime: Date?
    private(set) var timerState: TimerState!
    private(set) var totalElapsedTime: TimeInterval = 0
    private(set) var currentStepElapsedTime: TimeInterval = 0
    
    private(set) var timerUpdateCallback: ((TimerUpdate) -> Void)!
    private var countdownUpdateCallback: ((TimerUpdate) -> Void)!
    private(set) var fromPercentage: CGFloat = 0
    private(set) var toPercentage: CGFloat = 0
    private(set) var recipeIndex = 0
    private(set) var countdownTime: Int
    private(set) var stepsActualTime = [TimeInterval]()
    private(set) var totalStepTime: TimeInterval = 0
    
    init(timerState: TimerState = .countdown, timerScheduler: TimerScheduling, recipe: Recipe, countdownTime: Int = 3) {
        self.timerScheduler = timerScheduler
        self.recipe = recipe
        self.timerState = timerState
        self.countdownTime = countdownTime
        self.recipeStepInterval = recipe.interval
    }
    
    func start(timerUpdate: @escaping ((TimerUpdate) -> Void)) {
        switch timerState {
        case .new:
            print("start")
            startTime = Date()
            timerState = .running
            timerUpdateCallback = timerUpdate
            timerScheduler.start(timeInterval: Constants.timerInterval, repeats: true) { [weak self] _ in
                self?.runCoffeeTimer()
            }
        case .paused:
            print("resume")
            startTime = Date().addingTimeInterval(-totalElapsedTime)
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
    
    func nextStep(auto: Bool) {
        // Check if end of recipe
        if recipeIndex >= recipe.waterPours.count - 1 {
            endTimer()
        } else {
            recipeIndex += 1
            if auto {
                stepsActualTime.append(recipe.interval)
            } else {
                stepsActualTime.append(currentStepElapsedTime)
            }
            totalStepTime = stepsActualTime.reduce(0, +)
            timerUpdateCallback(.nextStep(step: currentStepElapsedTime, total: totalElapsedTime))
            currentStepElapsedTime = 0
        }
    }
    
    private func runCoffeeTimer() {
        calculateProgress()
        // Check if end of recipe's set interval
        if currentStepElapsedTime < recipe.interval {
            // Continue counting - send elapsed time to closure
            timerUpdateCallback(.tick(step: currentStepElapsedTime, total: totalElapsedTime))
        } else {
            // End of interval - Check if user has set auto-advance on (0 = Auto)
            if UserDefaultsManager.timerStepAdvance == 0 {
                nextStep(auto: true)
            } else {
                // User has step advance set to manual - send elapsed time to closure
                timerUpdateCallback(.tick(step: currentStepElapsedTime, total: totalElapsedTime))
            }
        }
    }
    
    private func calculateProgress() {
        guard let start = startTime else {
            print("Error with startTime")
            return
        }
        
        totalElapsedTime = -start.timeIntervalSinceNow
        
        let newCurrentStepElapsedTime = totalElapsedTime - totalStepTime
        
        fromPercentage = CGFloat(currentStepElapsedTime) / CGFloat(recipeStepInterval)
        toPercentage = CGFloat(newCurrentStepElapsedTime) / CGFloat(recipeStepInterval)
        
        currentStepElapsedTime = newCurrentStepElapsedTime
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
            timerScheduler.invalidate()
            timerState = .new
            countdownUpdateCallback(.done)
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

        let time = Int(self)

        let seconds = time % 60
        let minutes = (time / 60) % 60

        return String(format: "%0.2d:%0.2d", minutes, seconds)

    }
}
