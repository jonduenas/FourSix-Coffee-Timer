//
//  UserDefaultsManager.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 7/6/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    
    private static let userDefaults = UserDefaults.standard
    
    //MARK: Key Values
    private static let didPurchaseProKey = "didPurchaseProKey"
    private static let totalTimeShownKey = "totalTimeShownKey"
    private static let timerAutoAdvanceKey = "timerAutoAdvanceKey"
    private static let ratioKey = "ratioKey"
    private static let previousCoffeeKey = "previousCoffeeKey"
    private static let previousSelectedBalanceKey = "previousSelectedBalanceKey"
    private static let previousSelectedStrengthKey = "previousSelectedStrengthKey"
    private static let userHasSeenWalkthroughKey = "userHasSeenWalkthroughKey"
    
    //MARK: Variables
    
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
    
    static var timerAutoAdvance: Bool {
        get {
            return userDefaults.bool(forKey: timerAutoAdvanceKey)
        }
        set {
            userDefaults.set(newValue, forKey: timerAutoAdvanceKey)
        }
    }
    
    static var ratio: Int {
        get {
            return userDefaults.integer(forKey: ratioKey)
        }
        set {
            userDefaults.set(newValue, forKey: ratioKey)
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
}
