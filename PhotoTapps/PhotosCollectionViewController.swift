//
//  PhotosCollectionViewController.swift
//  PhotoTapps
//
//  Created by Nikolay Kryuchkov on 10.01.2021.
//

import UIKit
import Firebase

struct ImageItems {
    var name: String
    var liked: Bool
}

struct GlobalVariables {
//    static var photos = ["dog0","dog1", "dog2", "dog3", "dog4", "dog5", "dog6", "dog7", "dog8", "dog9", "dog10", "dog11", "dog12", "dog13", "dog14", "dog15"]
    static var photos: [Int: ImageItems] = [0: ImageItems(name: "dog0", liked: true),
                                            1: ImageItems(name: "dog1", liked: false),
                                            2: ImageItems(name: "dog2", liked: true),
                                            3: ImageItems(name: "dog3", liked: false),
                                            4: ImageItems(name: "dog4", liked: true)]
}

class PhotosCollectionViewController: UICollectionViewController {

    let paddingWidth: CGFloat = 3
    let itemsPerRow: CGFloat = 3
    
    let storage = Storage.storage(url:"gs://firephotos-40d70.appspot.com")
    var storageSize: String = ""
    
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
        
//        // Firebase implement
//        let storageRef = storage.reference().child("images")
//        storageRef.listAll { [weak self] (result, error) in
//          if let error = error {
//            print("list Error\n", error)
//          }
//          for prefix in result.prefixes {
//            print(prefix)
//          }
//          for item in result.items {
//            print(item)
//          }
//            self?.storageSize = String(result.items.count)
//            print(self!.storageSize)
//        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickImageSegue" {
            let photoVC = segue.destination as! PhotoViewController
            let cell = sender as! PhotoCell
//            photoVC.image = cell.cellImageView.image
//            photoVC.imageID = cell.imageID
        }
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return GlobalVariables.photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        
//        cell.backgroundColor = .systemGray5
        
        let imageName = GlobalVariables.photos[indexPath.item]!.name
//        print(imageName)
        let image = UIImage(named: imageName)
        cell.cellImageView.image = image
        cell.imageID = indexPath.item
        
//        collectionView.reloadData()
        
        return cell
    }

}

//extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let paddingWidth = paddingValue * (itemsPerRow + 1)
//        let itemWidth = CGFloat(Int( (collectionView.frame.width - paddingWidth) / itemsPerRow ))
//        return CGSize(width: itemWidth, height: itemWidth)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: paddingValue
//                            , left: paddingValue
//                            , bottom: paddingValue
//                            , right: paddingValue)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return paddingValue
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//
//        return paddingValue
//    }
//}
