//
//  WalkthroughVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/30/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class WalkthroughVC: UIViewController {

    @IBOutlet weak var contentView: UIView!
    
    var recipeWater = [Double]()
    var recipeWaterString = [String]()
    var recipeStepCount = 0
    
    var currentViewControllerIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //remove shadow from navigation controller
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        if recipeWater.isEmpty {
            recipeWater = [60, 60, 60, 60, 60]
        }
        
        print(recipeWater)
        
        configurePageViewController()
    }
    
    func configurePageViewController() {
        
        guard let pageViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: CustomPageViewController.self)) as? CustomPageViewController else { return }
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(pageViewController.view)
        
        let views: [String: Any] = ["pageView": pageViewController.view as Any]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        
        guard let startingViewController = contentViewControllerAt(index: currentViewControllerIndex) else { return }
        
        pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true)
    }

    func contentViewControllerAt(index: Int) -> WalkthroughContentVC? {
        
        if index >= recipeWater.count || recipeWater.count == 0 {
            return nil
        }
        
        guard let contentViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: WalkthroughContentVC.self)) as? WalkthroughContentVC else { return nil }
        
        contentViewController.index = index
        contentViewController.stepText = "Step \(index + 1)"
        contentViewController.amountText = recipeWater[index].clean + "g"
        
        return contentViewController
    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func skipButtonTapped(_ sender: Any) {
        
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Timer")
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true)
    }
}

extension WalkthroughVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentViewControllerIndex
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return recipeStepCount
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let contentViewController = viewController as? WalkthroughContentVC
        
        guard var currentIndex = contentViewController?.index else { return nil }
        
        currentViewControllerIndex = currentIndex
        
        if currentIndex == 0 {
            return nil
        }
        
        currentIndex -= 1
        
        return contentViewControllerAt(index: currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let contentViewController = viewController as? WalkthroughContentVC
        
        guard var currentIndex = contentViewController?.index else { return nil }
        
        if currentIndex == recipeStepCount - 1 {
            return nil
        }
        
        currentIndex += 1
        
        currentViewControllerIndex = currentIndex
        
        return contentViewControllerAt(index: currentIndex)
    }
}

extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
