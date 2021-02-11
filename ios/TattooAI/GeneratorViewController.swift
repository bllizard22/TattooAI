//
//  GeneratorViewController.swift
//  TattooAI
//
//  Created by Nikolay Kryuchkov on 09.02.2021.
//

import UIKit
import Firebase
import Kingfisher

class GeneratorViewController: UIViewController {

    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var generateButton: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.layer.cornerRadius = 10
//        likeButton.setImage(UIImage(named: "like")?.withRenderingMode(.alwaysTemplate),
//                            for: .normal)
//        likeButton.tintColor = .white
//        likeButton.tintColor = UIColor(red: MainColor.red,
//                                       green: MainColor.green,
//                                       blue: MainColor.blue,
//                                       alpha: 1.0)
        settingsButton.layer.cornerRadius = 10
        generateButton.layer.masksToBounds = true
        generateButton.layer.cornerRadius = 10
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settings" {
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
