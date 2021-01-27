//
//  LikedCollectionViewController.swift
//  PhotoTapps
//
//  Created by Nikolay Kryuchkov on 11.01.2021.
//

import UIKit

class LikedCollectionViewController: UICollectionViewController {

    let paddingWidth: CGFloat = 3
    let itemsPerRow: CGFloat = 3
    
    var likedPhotos: [ImageItems] = []
//    var likedPhotos: [Int: ImageItems] = [:]
    
    override func viewWillAppear(_ animated: Bool) {
        likedPhotos = obtainLikedImages()
//        likedPhotos = GlobalVariables.photos.filter{$0.value.liked == true}
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        likedPhotos = obtainLikedImages()
        
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickImageSegue3" {
            let photoVC = segue.destination as! PhotoViewController
            let cell = sender as! PhotoCell
//            photoVC.image = cell.cellImageView.image
            photoVC.imageID = cell.imageID
        }
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
//        return GlobalVariables.photos.count
        return likedPhotos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "likedCell", for: indexPath) as! PhotoCell
        
        cell.backgroundColor = .systemGray5
        
//        let imageName = GlobalVariables.photos[indexPath.item].name
//        print(likedPhotos[indexPath.item]!.name)
//        print(likedPhotos)
//        print(type(of: likedPhotos[indexPath.item]!))
        let imageName = likedPhotos[indexPath.item].name
        let image = UIImage(named: imageName)
        cell.cellImageView.image = image
        cell.imageID = indexPath.item
        
//        collectionView.reloadData()
        
        return cell
    }
    
    func obtainLikedImages() -> [ImageItems] {
        var likedArray: [ImageItems] = []
        
        for item in GlobalVariables.photos.values {
            if item.liked {
                likedArray.append(item)
            }
        }
        
        return likedArray
    }

}
