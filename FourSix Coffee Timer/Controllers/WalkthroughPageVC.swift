//
//  WalkthroughPageVC.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/30/20.
//  Copyright © 2020 Jon Duenas. All rights reserved.
//

import UIKit

class WalkthroughPageVC: UIPageViewController, UIPageViewControllerDataSource {
    
    @IBOutlet weak var contentView: UIView!
    
    var walkthroughImageNames = ["walkthrough-1", "walkthrough-2", "walkthrough-3", "walkthrough-4"]
    
    var currentViewControllerIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        //Create the first walkthrough screen
        if let startingViewController = viewControllerAtIndex(0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
        
//        configurePageViewController()
    }
    
    //MARK: PageViewController methods
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentVC).index
        index -= 1
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentVC).index
        index += 1
        
        return viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(_ index: Int) -> WalkthroughContentVC? {
        if index == NSNotFound || index < 0 || index >= walkthroughImageNames.count {
            return nil
        }
        
        //Create a new view controller and pass the data
        if let pageContentViewController = storyboard?.instantiateViewController(identifier: "WalkthroughContentVC") as? WalkthroughContentVC {
            pageContentViewController.walkthroughImageName = walkthroughImageNames[index]
            pageContentViewController.index = index
            
            return pageContentViewController
        }
        
        return nil
    }
    
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return walkthroughImageNames.count
//    }
//    
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        if let pageContentViewController = storyboard?.instantiateViewController(identifier: "WalkthroughContentVC") as? WalkthroughContentVC {
//            return pageContentViewController.index
//        }
//        return 0
//    }
    
//    func configurePageViewController() {
//
//        guard let pageViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: CustomPageViewController.self)) as? CustomPageViewController else { return }
//
//        pageViewController.delegate = self
//        pageViewController.dataSource = self
//
//        addChild(pageViewController)
//        pageViewController.didMove(toParent: self)
//
//        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
//
//        contentView.addSubview(pageViewController.view)
//
//        let views: [String: Any] = ["pageView": pageViewController.view as Any]
//
//        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
//
//        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
//
//        guard let startingViewController = contentViewControllerAt(index: currentViewControllerIndex) else { return }
//
//        pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true)
//    }
//
//    func contentViewControllerAt(index: Int) -> WalkthroughContentVC? {
//
//        if index >= recipeWater.count || recipeWater.count == 0 {
//            return nil
//        }
//
//        guard let contentViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: WalkthroughContentVC.self)) as? WalkthroughContentVC else { return nil }
//
//        contentViewController.index = index
//        contentViewController.stepText = "Step \(index + 1)"
//        contentViewController.amountText = recipeWater[index].clean + "g"
//
//        if let recipe = recipe {
//            contentViewController.recipe = recipe
//        }
//
//        if index == recipeStepCount - 1 {
//            //last page - show start button
//            contentViewController.startIsHidden = false
//        }
//
//        return contentViewController
//    }
}

//extension WalkthroughVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
//
//    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return currentViewControllerIndex
//    }
//
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return recipeStepCount
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        let contentViewController = viewController as? WalkthroughContentVC
//
//        guard var currentIndex = contentViewController?.index else { return nil }
//
//        currentViewControllerIndex = currentIndex
//
//        if currentIndex == 0 {
//            return nil
//        }
//
//        currentIndex -= 1
//
//        return contentViewControllerAt(index: currentIndex)
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        let contentViewController = viewController as? WalkthroughContentVC
//
//        guard var currentIndex = contentViewController?.index else { return nil }
//
//        if currentIndex == recipeStepCount - 1 {
//            return nil
//        }
//
//        currentIndex += 1
//
//        currentViewControllerIndex = currentIndex
//
//        return contentViewControllerAt(index: currentIndex)
//    }
//}
