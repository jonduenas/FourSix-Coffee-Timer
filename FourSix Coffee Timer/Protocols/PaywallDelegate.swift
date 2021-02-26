//
//  PaywallDelegate.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 2/26/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import Foundation

@objc protocol PaywallDelegate {
    func purchaseCompleted()
    @objc optional func purchaseRestored()
    @objc optional func purchaseFailed()
}
