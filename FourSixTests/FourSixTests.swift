//
//  FourSixTests.swift
//  FourSixTests
//
//  Created by Jon Duenas on 9/17/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import XCTest
@testable import FourSix

class FourSixTests: XCTestCase {
    
    var sut: Calculator!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = Calculator()
    }

    override func tearDownWithError() throws {
        sut = nil
        
        try super.tearDownWithError()
    }

    func testCalculator_40() {
        // given
        let balance = Balance.sweet
        let strength = Strength.medium
        let coffee: Float = 25
        let water: Float = 375
        
        // when
        let recipe = sut.calculateRecipe(balance: balance, strength: strength, coffee: coffee, water: water)
        
        // then
        XCTAssertEqual(recipe.waterPours[0], 63, "First pour should be 50")
        XCTAssertEqual(recipe.waterPours[1], 87, "Second pour should be 70")
    }

    func testCalculator_60() {
        // given
        let balance = Balance.bright
        let strength = Strength.strong
        let coffee: Float = 25
        let water: Float = 375
        
        // when
        let recipe = sut.calculateRecipe(balance: balance, strength: strength, coffee: coffee, water: water)
        
        // then
        XCTAssertEqual(recipe.waterPours[3], 56, "Third pour should be 56")
        XCTAssertEqual(recipe.waterPours.count, 6, "Total pour count should be 6")
    }
    
    func testCalculator_TotalWater() {
        // given
        let balance = Balance.neutral
        let strength = Strength.light
        let coffee: Float = 25
        let water: Float = 375
        
        // when
        let recipe = sut.calculateRecipe(balance: balance, strength: strength, coffee: coffee, water: water)
        
        // then
        let acceptableRange: ClosedRange<Float> = 374.0...376.0
        XCTAssertTrue(acceptableRange.contains(recipe.waterPours.reduce(0, +)))
    }
}
