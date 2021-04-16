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
    
    enum UserDefaultsKeys: String {
        case launchedBeforeKey
        case totalTimeShownKey
        case timerStepAdvanceKey
        case ratioKey
        case ratioSelectKey
        case timerStepIntervalKey
        case previousCoffeeKey
        case previousSelectedBalanceKey
        case previousSelectedStrengthKey
        case userHasSeenWalkthroughKey
        case reviewWorthyActionCountKey
        case lastReviewRequestAppVersionKey
        case userHasSeenCoffeeRangeWarningKey
        case userHasMigratedStepAdvanceKey
        case autoAdvanceTimerKey
        case tempUnitRawValueKey
    }
    
    static var launchedBefore: Bool {
        get {
            return userDefaults.object(forKey: UserDefaultsKeys.launchedBeforeKey.rawValue) as? Bool ?? false
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKeys.launchedBeforeKey.rawValue)
        }
    }
    
    static var totalTimeShown: Bool {
        get {
            return userDefaults.object(forKey: UserDefaultsKeys.totalTimeShownKey.rawValue) as? Bool ?? false
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKeys.totalTimeShownKey.rawValue)
        }
    }
    
    static var timerStepAdvance: Int {
        get {
            return userDefaults.integer(forKey: UserDefaultsKeys.timerStepAdvanceKey.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKeys.timerStepAdvanceKey.rawValue)
        }
    }
    
    static var ratio: Float {
        get {
            return userDefaults.object(forKey: UserDefaultsKeys.ratioKey.rawValue) as? Float ?? Ratio.defaultRatio.consequent
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKeys.ratioKey.rawValue)
        }
    }
    
    static var ratioSelect: Int {
        get {
            return userDefaults.object(forKey: UserDefaultsKeys.ratioSelectKey.rawValue) as? Int ?? 3
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKeys.ratioSelectKey.rawValue)
        }
    }
    
    static var timerStepInterval: Int {
        get {
            return userDefaults.object(forKey: UserDefaultsKeys.timerStepIntervalKey.rawValue) as? Int ?? Int(Recipe.defaultRecipe.interval)
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKeys.timerStepIntervalKey.rawValue)
        }
    }
    
    static var previousCoffee: Float {
        get {
            return userDefaults.object(forKey: UserDefaultsKeys.previousCoffeeKey.rawValue) as? Float ?? Recipe.defaultRecipe.coffee
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKeys.previousCoffeeKey.rawValue)
        }
    }
    
    static var previousSelectedBalance: Float {
        get {
            return userDefaults.object(forKey: UserDefaultsKeys.previousSelectedBalanceKey.rawValue) as? Float ?? Balance.neutral.rawValue
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKeys.previousSelectedBalanceKey.rawValue)
        }
    }
    
    static var previousSelectedStrength: Int {
        get {
            return userDefaults.object(forKey: UserDefaultsKeys.previousSelectedStrengthKey.rawValue) as? Int ?? Strength.medium.rawValue
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKeys.previousSelectedStrengthKey.rawValue)
        }
    }
    
    static var userHasSeenWalkthrough: Bool {
        get {
            return userDefaults.object(forKey: UserDefaultsKeys.userHasSeenWalkthroughKey.rawValue) as? Bool ?? false
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKeys.userHasSeenWalkthroughKey.rawValue)
        }
    }
    
    static var reviewWorthyActionCount: Int {
        get {
            return userDefaults.object(forKey: UserDefaultsKeys.reviewWorthyActionCountKey.rawValue) as? Int ?? 0
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKeys.reviewWorthyActionCountKey.rawValue)
        }
    }
    
    static var lastReviewRequestAppVersion: String? {
        get {
            return userDefaults.object(forKey: UserDefaultsKeys.lastReviewRequestAppVersionKey.rawValue) as? String
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKeys.lastReviewRequestAppVersionKey.rawValue)
        }
    }
    
    static var userHasSeenCoffeeRangeWarning: Bool {
        get {
            return userDefaults.object(forKey: UserDefaultsKeys.userHasSeenCoffeeRangeWarningKey.rawValue) as? Bool ?? false
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKeys.userHasSeenCoffeeRangeWarningKey.rawValue)
        }
    }
    
    static var userHasMigratedStepAdvance: Bool {
        get {
            return userDefaults.object(forKey: UserDefaultsKeys.userHasMigratedStepAdvanceKey.rawValue) as? Bool ?? false
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKeys.userHasMigratedStepAdvanceKey.rawValue)
        }
    }
    
    static var autoAdvanceTimer: Bool {
        get {
            return userDefaults.object(forKey: UserDefaultsKeys.autoAdvanceTimerKey.rawValue) as? Bool ?? true
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKeys.autoAdvanceTimerKey.rawValue)
        }
    }
    
    static var tempUnitRawValue: Int {
        get {
            return userDefaults.object(forKey: UserDefaultsKeys.tempUnitRawValueKey.rawValue) as? Int ?? 0
        }
        set {
            let allowedValues = [0, 1]
            guard allowedValues.contains(newValue) else { fatalError("This value should never be anything besides 0 or 1.") }
            userDefaults.set(newValue, forKey: UserDefaultsKeys.tempUnitRawValueKey.rawValue)
        }
    }
}
