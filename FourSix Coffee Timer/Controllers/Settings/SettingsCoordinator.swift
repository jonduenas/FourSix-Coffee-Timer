//
//  SettingsCoordinator.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 2/13/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit
import MessageUI

class SettingsCoordinator: NSObject, Coordinator {
    var childCoordinators = [Coordinator]()
    weak var parentCoordinator: BrewCoordinator?
    var navigationController: UINavigationController
    weak var parentVC: SettingsVC?
    let settingsStoryboardName = String(describing: SettingsVC.self)

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = SettingsVC.instantiate(fromStoryboardNamed: settingsStoryboardName)
        vc.coordinator = self
        parentVC = vc
        navigationController.pushViewController(vc, animated: false)
    }

    func didFinishSettings() {
        parentCoordinator?.didFinishSettings()
        parentCoordinator?.childDidFinish(self)
    }

    func showLearnMore() {
        let vc = WebViewVC()
        vc.urlString = Constants.learnMoreURLString
        vc.showTitle = false
        navigationController.pushViewController(vc, animated: true)
    }

    func showTipJar() {
        let vc = TipJarVC.instantiate(fromStoryboardNamed: String(describing: TipJarVC.self))

        // Checks if screen height can accomodate custom presentation style
        let tipJarTransitioningDelegate = SlideOverTransitioningDelegate()
        tipJarTransitioningDelegate.height = 580
        tipJarTransitioningDelegate.tapToDismiss = true

        if UIScreen.main.bounds.height > tipJarTransitioningDelegate.height {
            vc.transitioningDelegate = tipJarTransitioningDelegate
            vc.modalPresentationStyle = .custom
        }

        navigationController.present(vc, animated: true, completion: nil)
    }

    func showAcknowledgements() {
        pushVCWithNoDependencies(viewController: AcknowledgementsVC())
    }

    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([Constants.emailAddress])
            mail.setSubject("Feedback")

            navigationController.present(mail, animated: true)
        } else {
            AlertHelper.showAlert(
                title: "Error Creating Email",
                message: "Please make sure you've setup email on your device. You can also simply send an email to jon@foursixcoffeeapp.com.",
                on: navigationController)
        }
    }

    func rateInAppStore() {
        guard let writeReviewURL = Constants.reviewProductURL else { return }
        UIApplication.shared.open(writeReviewURL)
    }

    func shareFourSix() {
        let activityVC = UIActivityViewController(activityItems: [Constants.productURL], applicationActivities: nil)
        navigationController.present(activityVC, animated: true)
    }

    private func pushVCWithNoDependencies <T: Storyboarded>(viewController: T) where T: UIViewController {
        let vc = T.instantiate(fromStoryboardNamed: settingsStoryboardName)
        navigationController.pushViewController(vc, animated: true)
    }
}

extension SettingsCoordinator: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
