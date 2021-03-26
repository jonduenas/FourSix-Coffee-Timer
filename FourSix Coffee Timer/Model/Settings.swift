//
//  Settings.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/8/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import Foundation

enum TempUnit: Int {
    case celsius, fahrenheit
}

class Settings {
    var ratio: Float = UserDefaultsManager.ratio {
        didSet {
            UserDefaultsManager.ratio = ratio
        }
    }
    
    let defaultRatio = Ratio.defaultRatio.consequent
    
    var stepInterval: Int = UserDefaultsManager.timerStepInterval {
        didSet {
            UserDefaultsManager.timerStepInterval = stepInterval
        }
    }
    
    let defaultInterval = Recipe.defaultRecipe.interval
    
    var showTotalTime: Bool = UserDefaultsManager.totalTimeShown {
        didSet {
            UserDefaultsManager.totalTimeShown = showTotalTime
        }
    }
    
    var autoAdvanceTimer: Bool = UserDefaultsManager.autoAdvanceTimer {
        didSet {
            UserDefaultsManager.autoAdvanceTimer = autoAdvanceTimer
        }
    }
    
    var tempUnit: TempUnit = TempUnit(rawValue: UserDefaultsManager.tempUnitRawValue) ?? .celsius {
        didSet {
            UserDefaultsManager.tempUnitRawValue = tempUnit.rawValue
        }
    }
}
