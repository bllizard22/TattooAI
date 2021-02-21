//
//  PageViewController.swift
//  TattooAI
//
//  Created by Nikolay Kryuchkov on 18.02.2021.
//

import UIKit

class PageViewController: UIPageViewController {

    let presentScreenContent = ["This application is based on a neural network with the GAN algorithm (the same as used to generate images of not existing people). It consists of two parts: 'student' and 'mentor'",
                                "The 'student' studies real tattoo photos and tries to draw his own from scratch. The 'mentor' checks whether the result of the 'student' is similar to a real tattoo",
                                "Gradually, the neural network improves the result and the images become more realistic",
                                "This process requires quite a lot of computing power, so the generation takes place on the server, and the finished images are loaded into the application",
                                ""]
    
    let pictoNameArray = ["Asset1",
                          "Asset2",
                          "Asset3",
                          "Asset4",
                          ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        dataSource = self
        
        if let contentViewController = showViewControllerAtIndex(0) {
            setViewControllers([contentViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func showViewControllerAtIndex(_ index: Int) -> ContentViewController? {
        guard index >= 0 else { return nil }
        guard index < presentScreenContent.count else {
//            dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
            return nil
        }
        guard let contentViewController = storyboard?.instantiateViewController(identifier: "ContentViewController") as? ContentViewController else { return nil }
        
        contentViewController.presentText = presentScreenContent[index]
        contentViewController.assetImage = UIImage(named: pictoNameArray[index])
        contentViewController.currentPage = index
        contentViewController.numberOfPages = presentScreenContent.count
        contentViewController.isHidden = true
        
        if index == (presentScreenContent.count-1) && !isAppAlreadyLaunchedOnce()  {
            contentViewController.isHidden = false
        }
        
        return contentViewController
    }
    
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults()
        
        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var pageNumber = (viewController as! ContentViewController).currentPage
        pageNumber -= 1
        
        return showViewControllerAtIndex(pageNumber)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var pageNumber = (viewController as! ContentViewController).currentPage
        pageNumber += 1
        
        return showViewControllerAtIndex(pageNumber)
    }
    
    
}
