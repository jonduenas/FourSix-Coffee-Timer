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
    static let productURL = URL(string: "https://apps.apple.com/app/id1519905670")!
    
    static let reviewProductURL: URL? = {
        var components = URLComponents(url: Constants.productURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "action", value: "write-review")]
        guard let writeReviewURL = components?.url else { return nil }
        return writeReviewURL
    }()
    
    static let appVersion: String = {
        guard let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else { return "" }
        guard let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else { return "" }
        let versionWithBuild = "v\(appVersionString) (\(buildNumber))"
        return versionWithBuild
    }()
}
