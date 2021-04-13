//
//  SummaryTransitioningDelegate.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 4/13/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class SummaryTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentation = SlideOverPresentation(presentedViewController: presented, presenting: presenting)
        presentation.height = 450
        return presentation
    }
}
