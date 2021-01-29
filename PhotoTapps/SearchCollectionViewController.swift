//
//  SearchCollectionViewController.swift
//  PhotoTapps
//
//  Created by Nikolay Kryuchkov on 11.01.2021.
//

import UIKit
import Firebase
import Kingfisher

class SearchCollectionViewController: UICollectionViewController {

    let paddingWidth: CGFloat = 3
    let itemsPerRow: CGFloat = 3
    
    var imageLikes: [ImageLike] = []
    
    let storageURL = "gs://firephotos-40d70.appspot.com/"
    let folderURL = "images/"
    
    let storage = Storage.storage(url:"gs://firephotos-40d70.appspot.com")
    var storageRef = Storage.storage(url:"gs://firephotos-40d70.appspot.com").reference().child("images")
    var imageURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/1920px-Apple_logo_black.svg.png")
    
    var storageSize: String = ""
    var storageItems: [FirebaseStorage.StorageReference] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark
        
        // Count size of item based on screen size
        let paddingTotalWidth = paddingWidth * (itemsPerRow + 1)
        let itemWidth = CGFloat(Int( (collectionView.frame.width - paddingTotalWidth) / itemsPerRow ))
        
        // Set layout parameters
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: paddingWidth
                                           , left: paddingWidth
                                           , bottom: paddingWidth
                                           , right: paddingWidth)
        layout.minimumLineSpacing = paddingWidth
        layout.minimumInteritemSpacing = paddingWidth
        layout.estimatedItemSize = CGSize(width: 0, height: 0)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        // Turn off scroll indicator
        collectionView.showsVerticalScrollIndicator = false

        // Firebase implement
//        let storageRef = storage.reference().child("images")
//
//        // Download 1.jpg from Storage and set it as image in ImageView
//        let imageRef = storageRef.child("1.jpg")
//
//        imageRef.getData(maxSize: 1 * 1024 * 1024) { [weak self] data, error in
//            if let error = error {
//                // Uh-oh, an error occurred!
//                print("get Error\n",error)
//            } else {
//                // Data for "images/island.jpg" is returned
//                let image = UIImage(data: data!)
//                self?.imageView.image = image
//            }
//        }
        
//        // List all images in Storage
//        storageRef.listAll { [weak self] (result, error) in
//            if let error = error {
//                print("list Error\n", error)
//          }
//          for prefix in result.prefixes {
//            print(prefix)
//          }
//          for item in result.items {
//            print(item)
//            self?.storageItems.append(item)
//          }
////            storageItems += String(result.items)
//            self?.storageSize = String(result.items.count)
//            print(self!.storageSize)
//        }
        
//        let imageRef = storageRef.child("1.jpg")
//        imageRef.downloadURL { [weak self] (url, error) in
//            guard let url = url else { return }
//            print(url)
//            print(url.absoluteURL)
//            self?.imageURL = url
//            let resource = ImageResource(downloadURL: (self?.imageURL)!)
//            self?.testImageView.kf.setImage(with: resource) { (result) in
//                switch result {
//                case .success(_):
//                    print("success")
//                case .failure(_):
//                    print("fail")
//                }
//            }
//        }
        
        loadStorageData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        loadStorageData()
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        storageRef.observe(.value) { [weak self] (snapshot) in
//            var tasksBuffer = Array<Task>()
//            for item in snapshot.children {
//                let task = Task(snapshot: item as! DataSnapshot)
//                tasksBuffer.append(task)
//            }
//
//            self?.tasks = tasksBuffer
//            self?.tableView.reloadData()
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickImageSegue2" {
            let photoVC = segue.destination as! PhotoViewController
            let cell = sender as! PhotoCell
//            photoVC.image = cell.cellImageView.image
//            photoVC.imageID = cell.imageID
            photoVC.imageSegueURL = cell.imageURL
        }
    }

    func loadStorageData() {
        // List all images in Storage
        let storageRef = storage.reference().child("images")
        storageRef.listAll { [weak self] (result, error) in
            if let error = error {
                print("list Error\n", error)
          }
          for prefix in result.prefixes {
            print(prefix)
          }
          for item in result.items {
            print(item)
            self?.storageItems.append(item)
          }
//            storageItems += String(result.items)
            self?.storageSize = String(result.items.count)
            print(self!.storageSize)
            self?.collectionView.reloadData()
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return storageItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! PhotoCell
        
        cell.backgroundColor = .systemGray5
        
//        let imageName = photos[indexPath.item]
//        let image = UIImage(named: imageName)
//        cell.cellImageView.image = image
        cell.imageID = indexPath.item
        
        
        
        // Download image from Storage and set it as image in ImageView
//        print("\nindexpath.item", indexPath.item)
//        print("storageItems.count", storageItems.count)
        if indexPath.item < storageItems.count {
            let imageRef = storageItems[indexPath.item]
            
//            imageRef.getData(maxSize: 1 * 1024 * 512) { [weak self] data, error in
//                if let error = error {
//                    // Uh-oh, an error occurred!
//                    print("get Error\n",error)
//                } else {
//                    // Data for "images/*.jpg" is returned
//                    let image = UIImage(data: data!)
//                    cell.cellImageView.image = image
//                }
//            }
            
            imageRef.downloadURL { [weak self] (url, error) in
                if let error = error {
                    print("get Error\n",error)
                }
                
                guard let url = url else { return }
//                print(url)
//                print(url.absoluteURL)
                let newURL = URL(string: "")
                self?.imageURL = url
                cell.imageURL = url
                let resource = ImageResource(downloadURL: (self?.imageURL)!)
                cell.cellImageView.kf.setImage(with: resource) { (result) in
                    switch result {
                    case .success(_):
                        //                print("success")
                        break
                    case .failure(_):
                        print("fail")
                    }
                }
            }
            
        }
        
        return cell
    }

}
