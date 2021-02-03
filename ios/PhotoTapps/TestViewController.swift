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
    
    var storageItems: [FirebaseStorage.StorageReference] = []
    var urlList: [String] = []
    
    @IBOutlet weak var testImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storageRef = Storage.storage(url:"gs://firephotos-40d70.appspot.com").reference()
        let imageRef = storageRef.child("787.jpg")
        
        imageRef.downloadURL { [weak self] (url, error) in
            guard let url = url else { return }
            print(url)
            print(url.absoluteURL)
            self?.imageURL = url
            let resource = ImageResource(downloadURL: (self?.imageURL)!)
            self?.urlList.append(url.absoluteString)
            self?.testImageView.kf.setImage(with: resource, options: [.cacheOriginalImage]) { (result) in
                switch result {
                case .success(_):
                    print("success")
                case .failure(_):
                    print("fail")
                }
            }
        }
//        let collectionView = UICollectionView()
//        collectionView.backgroundColor = .systemTeal
//        view.addSubview(collectionView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        let resource = ImageResource(downloadURL: imageURL!)
//        testImageView.kf.setImage(with: resource) { (result) in
//            switch result {
//            case .success(_):
//                print("success")
//            case .failure(_):
//                print("fail")
//            }
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickImageSegueTest" {
            let photoVC = segue.destination as! PhotoViewController
            let cell = sender as! PhotoCell
//            photoVC.image = cell.cellImageView.image
//            photoVC.imageID = cell.imageID
        }
    }
    
    

}
