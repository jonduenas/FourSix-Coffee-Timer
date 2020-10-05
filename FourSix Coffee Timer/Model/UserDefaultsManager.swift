//
//  UserDefaultsManager.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 7/6/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import Foundation

class UserDefaultsManager: NSObject {
    
    private static let userDefaults = UserDefaults.standard
    
    // MARK: Key Values
    private static let didPurchaseProKey = "didPurchaseProKey"
    private static let totalTimeShownKey = "totalTimeShownKey"
    private static let timerStepAdvanceKey = "timerStepAdvanceKey"
    private static let ratioKey = "ratioKey"
    private static let ratioSelectKey = "ratioSelectKey"
    private static let timerStepIntervalKey = "timerStepIntervalKey"
    private static let previousCoffeeKey = "previousCoffeeKey"
    private static let previousSelectedBalanceKey = "previousSelectedBalanceKey"
    private static let previousSelectedStrengthKey = "previousSelectedStrengthKey"
    private static let userHasSeenWalkthroughKey = "userHasSeenWalkthroughKey"
    private static let reviewWorthyActionCountKey = "reviewWorthyActionCountKey"
    private static let lastReviewRequestAppVersionKey = "lastReviewRequestAppVersionKey"
    private static let userHasSeenCoffeeRangeWarningKey = "userHasSeenCoffeeRangeWarningKey"
    
    // MARK: Variables
    
    static var didPurchasePro: Bool {
        get {
            return userDefaults.bool(forKey: didPurchaseProKey)
        }
        set {
            userDefaults.set(newValue, forKey: didPurchaseProKey)
        }
    }
    
    static var totalTimeShown: Bool {
        get {
            return userDefaults.bool(forKey: totalTimeShownKey)
        }
        set {
            userDefaults.set(newValue, forKey: totalTimeShownKey)
        }
    }
    
    static var timerStepAdvance: Int {
        get {
            return userDefaults.integer(forKey: timerStepAdvanceKey)
        }
        set {
            userDefaults.set(newValue, forKey: timerStepAdvanceKey)
        }
    }
    
    static var ratio: Float {
        get {
            return userDefaults.float(forKey: ratioKey)
        }
        set {
            userDefaults.set(newValue, forKey: ratioKey)
        }
    }
    
    static var ratioSelect: Int {
        get {
            return userDefaults.object(forKey: ratioSelectKey) as? Int ?? 3
        }
        set {
            userDefaults.set(newValue, forKey: ratioSelectKey)
        }
    }
    
    static var timerStepInterval: Int {
        get {
            return userDefaults.integer(forKey: timerStepIntervalKey)
        }
        set {
            userDefaults.set(newValue, forKey: timerStepIntervalKey)
        }
    }
    
    static var previousCoffee: Float {
        get {
            return userDefaults.float(forKey: previousCoffeeKey)
        }
        set {
            userDefaults.set(newValue, forKey: previousCoffeeKey)
        }
    }
    
    static var previousSelectedBalance: Float {
        get {
            return userDefaults.float(forKey: previousSelectedBalanceKey)
        }
        set {
            userDefaults.set(newValue, forKey: previousSelectedBalanceKey)
        }
    }
    
    static var previousSelectedStrength: Int {
        get {
            return userDefaults.integer(forKey: previousSelectedStrengthKey)
        }
        set {
            userDefaults.set(newValue, forKey: previousSelectedStrengthKey)
        }
    }
    
    static var userHasSeenWalkthrough: Bool {
        get {
            return userDefaults.bool(forKey: userHasSeenWalkthroughKey)
        }
        set {
            userDefaults.set(newValue, forKey: userHasSeenWalkthroughKey)
        }
    }
    
    static var reviewWorthyActionCount: Int {
        get {
            return userDefaults.integer(forKey: reviewWorthyActionCountKey)
        }
        set {
            userDefaults.set(newValue, forKey: reviewWorthyActionCountKey)
        }
    }
    
    static var lastReviewRequestAppVersion: String? {
        get {
            return userDefaults.string(forKey: lastReviewRequestAppVersionKey)
        }
        set {
            userDefaults.set(newValue, forKey: lastReviewRequestAppVersionKey)
        }
    }
    
    static var userHasSeenCoffeeRangeWarning: Bool {
        get {
            return userDefaults.bool(forKey: userHasSeenCoffeeRangeWarningKey)
        }
        set {
            userDefaults.set(newValue, forKey: userHasSeenCoffeeRangeWarningKey)
        }
    }
}
