//
//  Storyboarded.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 2/12/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

protocol Storyboarded {
    static func instantiate(fromStoryboardNamed storyboardName: String) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(fromStoryboardNamed storyboardName: String) -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
