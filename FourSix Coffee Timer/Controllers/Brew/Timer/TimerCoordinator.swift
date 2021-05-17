//
//  TimerCoordinator.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 2/19/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class TimerCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: BrewCoordinator?
    var navigationController: UINavigationController
    let recipe: Recipe
    let dataManager: DataManager
    
    init(navigationController: UINavigationController, recipe: Recipe, dataManager: DataManager) {
        self.navigationController = navigationController
        self.recipe = recipe
        self.dataManager = dataManager
    }
    
    func start() {
        let vc = TimerVC.instantiate(fromStoryboardNamed: String(describing: TimerVC.self))
        vc.coordinator = self
        vc.recipe = recipe
        navigationController.modalPresentationStyle = .fullScreen
        
        if navigationController.traitCollection.userInterfaceStyle == .light {
            setStatusBarStyle(.darkContent)
        } else {
            setStatusBarStyle(.lightContent)
        }
        
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showSummary(recipe: Recipe, session: Session) {
        let vc = BrewSummaryVC.instantiate(fromStoryboardNamed: String(describing: BrewSummaryVC.self))
        vc.coordinator = self
        vc.dataManager = dataManager
        vc.recipe = recipe
        vc.session = session
        
        let summaryTransitioningDelegate = SlideOverTransitioningDelegate()
        summaryTransitioningDelegate.height = 450
        summaryTransitioningDelegate.tapToDismiss = false
        vc.transitioningDelegate = summaryTransitioningDelegate
        vc.modalPresentationStyle = .custom
        
        navigationController.present(vc, animated: true)
    }
    
    func didCancelTimer() {
        parentCoordinator?.childDidFinish(self)
    }
    
    func didFinishSummary() {
        navigationController.dismiss(animated: true) {
            self.parentCoordinator?.childDidFinish(self)
        }
    }
    
    func showNewNote(note: NoteMO?) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: AssetsColor.header.rawValue)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.newYork(size: 17, weight: .medium)]
        navigationController.navigationBar.standardAppearance = appearance
        
        setStatusBarStyle(.lightContent)
        
        let child = NoteDetailsCoordinator(navigationController: navigationController, dataManager: dataManager)
        childCoordinators.append(child)
        child.timerCoordinator = self
        child.note = note
        child.isNewNote = true
        child.start()
    }
    
    func didFinishNewNote() {
        parentCoordinator?.childDidFinish(self)
    }
    
    private func setStatusBarStyle(_ style: UIStatusBarStyle) {
        if let timerNav = navigationController as? TimerNavigationController {
            timerNav.darkBackground = style == .lightContent
        }
    }
}
