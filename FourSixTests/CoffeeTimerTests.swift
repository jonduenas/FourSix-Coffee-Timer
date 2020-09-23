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
    
    var coffeeTimer: CoffeeTimer!

    override func setUp() {
        super.setUp()
        
        coffeeTimer = CoffeeTimer()
    }

    override func tearDown() {
        super.tearDown()
        
        coffeeTimer = nil
    }
    
    func testTimerStart() {
        coffeeTimer.timerState = .new
        
        coffeeTimer.start()
        
        XCTAssertEqual(coffeeTimer.timerState, .running, "Timer state should be running")
        
        coffeeTimer.timerState = .paused
        coffeeTimer.start()
        
        XCTAssertEqual(coffeeTimer.timerState, .running, "Timer state should be running")
    }
    
    func testTimerPause() {
        coffeeTimer.timerState = .running
        
        coffeeTimer.pause()
        
        XCTAssertEqual(coffeeTimer.timerState, .paused, "Timer state should be paused")
    }
    
    func testTimerNextStep() {
        coffeeTimer.currentStepElapsedTime = 45
        
        coffeeTimer.nextStep()
        
        XCTAssertEqual(coffeeTimer.currentStepElapsedTime, 0, "currentStepElapsedTime should be 0")
    }
    
    func testRunCoffeeTimer() {
        coffeeTimer.timerState = .new
        
        coffeeTimer.start()
        
        coffeeTimer.runCoffeeTimer()
        
        XCTAssertEqual(coffeeTimer.fromPercentage, 0, "From percentage should be 0")
        XCTAssertTrue(coffeeTimer.toPercentage != 0, "To percentage should not be 0")
        XCTAssertTrue(coffeeTimer.currentStepElapsedTime != 0, "Current step time should not be 0")
        XCTAssertTrue(coffeeTimer.totalElapsedTime != 0, "Total time should not be 0")
    }
}
