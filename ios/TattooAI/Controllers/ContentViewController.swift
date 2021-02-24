//
//  ContentViewController.swift
//  TattooAI
//
//  Created by Nikolay Kryuchkov on 18.02.2021.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var presentTextLabel: UILabel!
    @IBOutlet weak var pictoImage: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var exitButton: UIButton!
    
    var presentText = ""
    var assetImage = UIImage(named: "Asset1")
    var currentPage = 0
    var numberOfPages = 0
    var isHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presentTextLabel.text = presentText
        presentTextLabel.textColor = .white
        let size = UIScreen.main.bounds.size
        let screenHeight = size.height
        let screenWidth = size.width
        let safeArea = self.view.safeAreaLayoutGuide
        let textTopConstraint = presentTextLabel.topAnchor.constraint(equalTo: safeArea.topAnchor,
                                                                      constant: screenHeight/10*5)
        let imageBottomConstraint = pictoImage.bottomAnchor.constraint(equalTo: safeArea.topAnchor,
                                                                       constant: screenHeight/10*4)
        NSLayoutConstraint.activate([textTopConstraint, imageBottomConstraint])
        
        pictoImage.image = assetImage
        pageControl.numberOfPages = numberOfPages // Have to be set before currentPage
        pageControl.currentPage = currentPage
        exitButton.isHidden = isHidden
        exitButton.layer.cornerRadius = 10
    }
    
    @IBAction func exitButtonDidPressed(_ sender: Any) {
        guard let generatorVC = storyboard?.instantiateViewController(identifier: "InitialTabBarVC")
                as? UITabBarController else { return }
        generatorVC.modalPresentationStyle = .fullScreen
        present(generatorVC, animated: true, completion: nil)
    }
    
}
