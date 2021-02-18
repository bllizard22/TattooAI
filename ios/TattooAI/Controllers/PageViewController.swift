//
//  PageViewController.swift
//  TattooAI
//
//  Created by Nikolay Kryuchkov on 18.02.2021.
//

import UIKit

class PageViewController: UIPageViewController {

    let presentScreenContent = ["1",
                                "2",
                                "3",
                                "4",
                                ""]
    let emojiArray = ["🤖",
    "🤓",
    "🙌",
    "🧑‍💻",
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
        contentViewController.emoji = emojiArray[index]
        contentViewController.currentPage = index
        contentViewController.numberOfPages = presentScreenContent.count
        
        return contentViewController
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
