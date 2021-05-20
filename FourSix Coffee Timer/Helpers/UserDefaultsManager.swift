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
    private static let launchedBeforeKey = "launchedBeforeKey"
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
    private static let userHasMigratedStepAdvanceKey = "userHasMigratedStepAdvanceKey"
    private static let autoAdvanceTimerKey = "autoAdvanceTimerKey"
    private static let hasSeenNotificationRequestKey = "hasSeenNotificationRequestKey"
    private static let sendReminderNotificationKey = "sendReminderNotificationKey"

    // MARK: Variables

    static var launchedBefore: Bool {
        get {
            return userDefaults.object(forKey: launchedBeforeKey) as? Bool ?? false
        }
        set {
            userDefaults.set(newValue, forKey: launchedBeforeKey)
        }
    }

    static var totalTimeShown: Bool {
        get {
            return userDefaults.object(forKey: totalTimeShownKey) as? Bool ?? false
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
            return userDefaults.object(forKey: ratioKey) as? Float ?? Ratio.defaultRatio.consequent
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
            return userDefaults.object(forKey: timerStepIntervalKey) as? Int ?? Int(Recipe.defaultRecipe.interval)
        }
        set {
            userDefaults.set(newValue, forKey: timerStepIntervalKey)
        }
    }

    static var previousCoffee: Float {
        get {
            return userDefaults.object(forKey: previousCoffeeKey) as? Float ?? Recipe.defaultRecipe.coffee
        }
        set {
            userDefaults.set(newValue, forKey: previousCoffeeKey)
        }
    }

    static var previousSelectedBalance: Float {
        get {
            return userDefaults.object(forKey: previousSelectedBalanceKey) as? Float ?? Balance.even.rawValue
        }
        set {
            userDefaults.set(newValue, forKey: previousSelectedBalanceKey)
        }
    }

    static var previousSelectedStrength: Int {
        get {
            return userDefaults.object(forKey: previousSelectedStrengthKey) as? Int ?? Strength.medium.rawValue
        }
        set {
            userDefaults.set(newValue, forKey: previousSelectedStrengthKey)
        }
    }

    static var userHasSeenWalkthrough: Bool {
        get {
            return userDefaults.object(forKey: userHasSeenWalkthroughKey) as? Bool ?? false
        }
        set {
            userDefaults.set(newValue, forKey: userHasSeenWalkthroughKey)
        }
    }

    static var reviewWorthyActionCount: Int {
        get {
            return userDefaults.object(forKey: reviewWorthyActionCountKey) as? Int ?? 0
        }
        set {
            userDefaults.set(newValue, forKey: reviewWorthyActionCountKey)
        }
    }

    static var lastReviewRequestAppVersion: String? {
        get {
            return userDefaults.object(forKey: lastReviewRequestAppVersionKey) as? String
        }
        set {
            userDefaults.set(newValue, forKey: lastReviewRequestAppVersionKey)
        }
    }

    static var userHasSeenCoffeeRangeWarning: Bool {
        get {
            return userDefaults.object(forKey: userHasSeenCoffeeRangeWarningKey) as? Bool ?? false
        }
        set {
            userDefaults.set(newValue, forKey: userHasSeenCoffeeRangeWarningKey)
        }
    }

    static var userHasMigratedStepAdvance: Bool {
        get {
            return userDefaults.object(forKey: userHasMigratedStepAdvanceKey) as? Bool ?? false
        }
        set {
            userDefaults.set(newValue, forKey: userHasMigratedStepAdvanceKey)
        }
    }

    static var autoAdvanceTimer: Bool {
        get {
            return userDefaults.object(forKey: autoAdvanceTimerKey) as? Bool ?? true
        }
        set {
            userDefaults.set(newValue, forKey: autoAdvanceTimerKey)
        }
    }

    static var hasSeenNotificationRequest: Bool {
        get {
            return userDefaults.object(forKey: hasSeenNotificationRequestKey) as? Bool ?? false
        }
        set {
            userDefaults.set(newValue, forKey: hasSeenNotificationRequestKey)
        }
    }

    static var sendReminderNotification: Bool {
        get {
            return userDefaults.object(forKey: sendReminderNotificationKey) as? Bool ?? false
        }
        set {
            userDefaults.set(newValue, forKey: sendReminderNotificationKey)
        }
    }
}
