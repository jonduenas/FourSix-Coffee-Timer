//
//  Ratio.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 2/17/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import Foundation

struct Ratio: Equatable {
    let antecedent = 1
    var consequent: Float

    var stringValue: String {
        return "\(antecedent):\(consequent.clean)"
    }
}

extension Ratio {
    static var oneToTwelve: Ratio { .init(consequent: 12) }
    static var oneToThirteen: Ratio { .init(consequent: 13) }
    static var oneToFourteen: Ratio { .init(consequent: 14) }
    static var oneToFifteen: Ratio { .init(consequent: 15) }
    static var oneToSixteen: Ratio { .init(consequent: 16) }
    static var oneToSeventeen: Ratio { .init(consequent: 17) }
    static var oneToEighteen: Ratio { .init(consequent: 18) }
    static let presets: [Ratio] = [oneToTwelve, oneToThirteen, oneToFourteen, oneToFifteen, oneToSixteen, oneToSeventeen, oneToEighteen]
    static let defaultRatio = oneToFifteen
}
