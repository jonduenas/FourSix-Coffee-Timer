//
//  Coordinator.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 2/12/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
    func childDidFinish(_ child: Coordinator?)
    func showProPaywall(delegate: PaywallDelegate)
}

extension Coordinator {
    func showProPaywall(delegate: PaywallDelegate) {
        let vc = PurchaseProVC.instantiate(fromStoryboardNamed: String(describing: PurchaseProVC.self))
        vc.delegate = delegate
        
        // Checks if screen height can accomodate custom presentation style
        let transitioningDelegate = PaywallTransitioningDelegate()
        if UIScreen.main.bounds.height > transitioningDelegate.height {
            vc.transitioningDelegate = transitioningDelegate
            vc.modalPresentationStyle = .custom
        }
        
        navigationController.present(vc, animated: true, completion: nil)
    }
}
