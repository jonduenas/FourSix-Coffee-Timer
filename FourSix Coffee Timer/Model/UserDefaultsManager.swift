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
    private static let totalTimeShownKey = "totalTimeShownKey"
    private static let timerAutoAdvanceKey = "timerAutoAdvanceKey"
    private static let ratioKey = "ratioKey"
    
    //MARK: Variables
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
}
