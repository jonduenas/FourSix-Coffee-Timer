//
//  SlideOverPresentation.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 4/13/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit

class SlideOverPresentation: UIPresentationController {
    private let blurEffectView: UIVisualEffectView!

    var height: CGFloat = 300.0
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    var tapToDismiss: Bool = true

    @objc func dismiss() {
        if tapToDismiss {
            self.presentedViewController.dismiss(animated: true, completion: nil)
        }
    }

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)

        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismiss))

        blurEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        blurEffectView.isUserInteractionEnabled = true
        blurEffectView.addGestureRecognizer(tapGestureRecognizer)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        var frame = CGRect.zero
        if let containerBounds = containerView?.bounds {
            frame = CGRect(x: 0, y: containerBounds.height - height, width: containerBounds.width, height: height)
        }
        return frame
    }

    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.blurEffectView.alpha = 0
        }, completion: { _ in
            self.blurEffectView.removeFromSuperview()
        })
    }

    override func presentationTransitionWillBegin() {
        if let containerView = self.containerView, let coordinator = presentingViewController.transitionCoordinator {
            self.blurEffectView.alpha = 0
            containerView.addSubview(blurEffectView)
            coordinator.animate(alongsideTransition: { _ in
                self.blurEffectView.alpha = 1
            })
        }
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView!.layer.masksToBounds = true
        presentedView!.layer.cornerRadius = 10
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        self.presentedView?.frame = frameOfPresentedViewInContainerView
        blurEffectView.frame = containerView!.bounds
    }
}

class SlideOverTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var height: CGFloat = 569
    var tapToDismiss: Bool = true

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentation = SlideOverPresentation(presentedViewController: presented, presenting: presenting)
        presentation.height = height
        presentation.tapToDismiss = tapToDismiss
        return presentation
    }
}
