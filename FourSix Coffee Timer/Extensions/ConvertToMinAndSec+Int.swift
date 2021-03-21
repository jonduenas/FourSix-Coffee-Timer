//
//  Int.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/3/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import Foundation

extension Int {
    func convertToMinAndSec() -> (Int, Int) {
        let minutes: Int = (self % 3600) / 60
        let seconds: Int = (self % 3600) % 60
        
        return (minutes, seconds)
    }
    
    func convertToMinAndSecString() -> String {
        let (minutes, seconds) = self.convertToMinAndSec()
        
        if minutes == 0 {
            return "\(seconds) sec"
        } else if seconds == 0 {
            return "\(minutes) min"
        } else {
            return "\(minutes) min \(seconds) sec"
        }
    }
}

extension TimeInterval {
    func convertToMinAndSec() -> (Int, Int) {
        let minutes: Int = (Int(self) % 3600) / 60
        let seconds: Int = (Int(self) % 3600) % 60
        
        return (minutes, seconds)
    }
    
    func convertToMinAndSecString() -> String {
        let (minutes, seconds) = self.convertToMinAndSec()
        
        if minutes == 0 {
            return "\(seconds) sec"
        } else if seconds == 0 {
            return "\(minutes) min"
        } else {
            return "\(minutes) min \(seconds) sec"
        }
    }
}

//extension Int {
//    func convertToMinAndSec() -> (Int, Int) {
//        let minutes = (self % 3600) / 60
//        let seconds = (self % 3600) % 60
//
//        return (minutes, seconds)
//    }
//}
