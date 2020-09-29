//
//  CoffeeTimerTests.swift
//  FourSixTests
//
//  Created by Jon Duenas on 9/22/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import XCTest
@testable import FourSix

class CoffeeTimerTests: XCTestCase {
    
    var sut: CoffeeTimer!
    var timerScheduler: MockTimerScheduler!
    var recipe: Recipe!

    override func setUp() {
        super.setUp()
        
        recipe = Recipe(coffee: 20, waterTotal: 300, waterPours: [50, 70, 60, 60, 60], balance: .sweet, strength: .medium)
        timerScheduler = MockTimerScheduler()
    }

    override func tearDown() {
        super.tearDown()
        
        sut = nil
        timerScheduler = nil
        recipe = nil
    }
    
    func testTimerScheduler_Start() {
        let timeInterval: TimeInterval = 0.25
        let didFinish = self.expectation(description: #function)
        
        timerScheduler.start(timeInterval: timeInterval, repeats: true) { _ in
            didFinish.fulfill()
        }
        
        wait(for: [didFinish], timeout: 1)
        
        XCTAssertNotNil(timerScheduler.repeatsPassed)
        XCTAssertEqual(timerScheduler.timeIntervalPassed!, timeInterval)
        XCTAssertNotNil(timerScheduler.blockPassed)
        XCTAssertTrue(timerScheduler.startCalled)
    }
    
    func testTimerScheduler_Invalidate() {
        timerScheduler.invalidate()
        
        XCTAssertTrue(timerScheduler.invalidateCalled)
    }
    
    func testTimerStart_New() {
        sut = CoffeeTimer(timerState: .new, timerScheduler: timerScheduler, recipe: recipe)
        
        sut.start { [weak self] timerUpdate in
            switch timerUpdate {
            case .tick(step: let stepTime, total: let totalTime):
                XCTAssertNotEqual(stepTime, 0)
                XCTAssertNotEqual(totalTime, 0)
                XCTAssertEqual(self?.sut.timerState, .running)
                XCTAssertEqual(self?.sut.fromPercentage, 0)
                XCTAssertNotEqual(self?.sut.toPercentage, 0)
            default:
                XCTFail("timerUpdate should be .tick")
            }
        }
    }
    
    func testTimerStart_Paused() {
        sut = CoffeeTimer(timerState: .paused, timerScheduler: timerScheduler, recipe: recipe)
        
        XCTAssertEqual(sut.timerState, .paused)
        
        sut.start { [weak self] timerUpdate in
            switch timerUpdate {
            case .tick(step: let stepTime, total: let totalTime):
                XCTAssertNotEqual(stepTime, 0)
                XCTAssertNotEqual(totalTime, 0)
                XCTAssertEqual(self?.sut.timerState, .running)
                XCTAssertEqual(self?.sut.fromPercentage, 0)
                XCTAssertNotEqual(self?.sut.toPercentage, 0)
            default:
                XCTFail("timerUpdate should be .tick")
            }
        }
    }
    
    func testTimerStart_Running() {
        sut = CoffeeTimer(timerState: .running, timerScheduler: timerScheduler, recipe: recipe)
        
        let didFinish = self.expectation(description: #function)
        
        XCTAssertEqual(sut.timerState, .running)
        
        sut.start { timerUpdate in
            switch timerUpdate {
            case .error:
                didFinish.fulfill()
            default:
                didFinish.fulfill()
                XCTFail()
            }
        }
        
        wait(for: [didFinish], timeout: 1)
        
        XCTAssertNil(sut.timerUpdateCallback)
    }
    
    func testTimerPause() {
        sut = CoffeeTimer(timerState: .new, timerScheduler: timerScheduler, recipe: recipe)
        
        var didFinish: XCTestExpectation? = self.expectation(description: #function)
        
        sut.start { _ in
            didFinish?.fulfill()
        }
        
        if let didFinishSafe = didFinish {
            wait(for: [didFinishSafe], timeout: 1)
        } else {
            XCTFail()
        }
        
        didFinish = nil
        
        XCTAssertEqual(self.sut.timerState, .running)
        
        sut.pause()
        
        XCTAssertEqual(sut.timerState, .paused, "Timer state should be paused")
    }
    
    func testTimerNextStep_Auto() {
        sut = CoffeeTimer(timerState: .new, timerScheduler: timerScheduler, recipe: recipe)
        
        var didFinish: XCTestExpectation? = self.expectation(description: #function)
        
        sut.start { _ in
            didFinish?.fulfill()
        }
        
        if let didFinishSafe = didFinish {
            wait(for: [didFinishSafe], timeout: 1)
        } else {
            XCTFail()
        }
        
        didFinish = nil
        
        XCTAssertEqual(self.sut.timerState, .running)
        let currentStep = sut.recipeIndex
        sut.nextStep(auto: true)
        
        XCTAssertEqual(sut.stepsActualTime[0], sut.recipe.interval)
        XCTAssertEqual(sut.currentStepElapsedTime, 0, "currentStepElapsedTime should be 0")
        XCTAssertEqual(currentStep + 1, sut.recipeIndex)
    }
    
    func testTimerNextStep_Manual() {
        sut = CoffeeTimer(timerState: .new, timerScheduler: timerScheduler, recipe: recipe)
        
        var didFinish: XCTestExpectation? = self.expectation(description: #function)
        
        sut.start { _ in
            didFinish?.fulfill()
        }
        
        if let didFinishSafe = didFinish {
            wait(for: [didFinishSafe], timeout: 1)
        } else {
            XCTFail()
        }
        
        didFinish = nil
        
        XCTAssertEqual(self.sut.timerState, .running)
        let currentStep = sut.recipeIndex
        sut.nextStep(auto: true)
        
        XCTAssertNotEqual(sut.stepsActualTime[0], sut.currentStepElapsedTime)
        XCTAssertEqual(sut.currentStepElapsedTime, 0, "currentStepElapsedTime should be 0")
        XCTAssertEqual(currentStep + 1, sut.recipeIndex)
    }
    
    func testTimerNextStep_LastStep() {
        recipe = Recipe(coffee: 20, waterTotal: 300, waterPours: [300], balance: .bright, strength: .medium)
        
        sut = CoffeeTimer(timerState: .new, timerScheduler: timerScheduler, recipe: recipe)
        
        var didStart: XCTestExpectation? = expectation(description: "didStart")
        var didFinish: XCTestExpectation? = self.expectation(description: "didFinish")
        
        sut.start { [weak self] timerUpdate in
            didStart?.fulfill()
            switch timerUpdate {
            case.nextStep(step: _, total: _):
                XCTFail("Test should never reach this point")
            case .done:
                didFinish?.fulfill()
                XCTAssertEqual(self?.sut.timerState, .done)
            default:
                XCTAssertEqual(self?.sut.timerState, .running)
            }
        }
        
        if let didStartSafe = didStart {
            wait(for: [didStartSafe], timeout: 1)
            didStart = nil
        }
        
        sut.nextStep(auto: true)
        
        if let didFinishSafe = didFinish {
            wait(for: [didFinishSafe], timeout: 1)
            didFinish = nil
        } else {
            XCTFail()
        }
        
        XCTAssertEqual(self.sut.timerState, .done)
    }
    
    func testCountdown_Start() {
        sut = CoffeeTimer(timerState: .countdown, timerScheduler: timerScheduler, recipe: recipe)
        
        let currentCountdownTime = sut.countdownTime
        
        sut.startCountdownTimer { countDownUpdate in
            switch countDownUpdate {
            case .countdown(let countdownTime):
                XCTAssertEqual(currentCountdownTime - 1, countdownTime)
            default:
                XCTFail("Test should not reach this point.")
            }
        }
    }
    
    func testCountdown_End() {
        sut = CoffeeTimer(timerState: .countdown, timerScheduler: timerScheduler, recipe: recipe, countdownTime: 1)
        
        var didFinish: XCTestExpectation? = expectation(description: "countdownFinish")
        
        sut.startCountdownTimer { countdownUpdate in
            switch countdownUpdate {
            case .done:
                didFinish?.fulfill()
            default:
                XCTFail("Test should not reach this point")
            }
        }
        
        wait(for: [didFinish!], timeout: 1)
        didFinish = nil
        
        XCTAssertEqual(sut.timerState, .new)
    }
}
