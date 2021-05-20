//
//  FourSixUITests.swift
//  FourSixUITests
//
//  Created by Jon Duenas on 5/14/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import XCTest

class FourSixUITests: XCTestCase {

    override func setUpWithError() throws {

        continueAfterFailure = false

        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        snapshot("0Launch")
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
