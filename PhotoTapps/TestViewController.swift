//
//  TestViewController.swift
//  PhotoTapps
//
//  Created by Nikolay Kryuchkov on 20.01.2021.
//

import UIKit
import Kingfisher
import Firebase

class TestViewController: UIViewController {

    let storageURL = "gs://firephotos-40d70.appspot.com/"
    let folderURL = "images/"
    
    var storageRef = Storage.storage(url:"gs://firephotos-40d70.appspot.com").reference().child("images")
    var imageURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/1920px-Apple_logo_black.svg.png")
    
    @IBOutlet weak var testImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageRef = storageRef.child("1.jpg")
        
        imageRef.downloadURL { [weak self] (url, error) in
            guard let url = url else { return }
            print(url)
            print(url.absoluteURL)
            self?.imageURL = url
            let resource = ImageResource(downloadURL: (self?.imageURL)!)
            self?.testImageView.kf.setImage(with: resource) { (result) in
                switch result {
                case .success(_):
                    print("success")
                case .failure(_):
                    print("fail")
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let resource = ImageResource(downloadURL: imageURL!)
        testImageView.kf.setImage(with: resource) { (result) in
            switch result {
            case .success(_):
                print("success")
            case .failure(_):
                print("fail")
            }
        }
    }

}
