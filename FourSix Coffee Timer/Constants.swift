//
//  Constants.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 3/5/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import Foundation

struct Constants {
    static let revenueCatAPIKey = "dDIhCeApJetzFIZVnXDjcLxLTPTjIoyr"
    static let appVersion: String = {
        guard let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else { return "" }
        guard let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else { return "" }
        let versionWithBuild = "v\(appVersionString) (\(buildNumber))"
        return versionWithBuild
    }()
}
