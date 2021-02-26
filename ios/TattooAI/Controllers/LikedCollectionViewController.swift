//
//  LikedCollectionViewController.swift
//  PhotoTapps
//
//  Created by Nikolay Kryuchkov on 11.01.2021.
//

import UIKit
import CoreData
import Firebase
import Kingfisher

class LikedCollectionViewController: UICollectionViewController {

    var paddingWidth: CGFloat = 3
    var itemsPerRow: CGFloat = 3
    
//    var likedPhotos: [ImageItems] = []
//    var likedPhotos: [Int: ImageItems] = [:]
    var imageLikes: [ImageLike] = []
    
    let testImageURL = "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/1920px-Apple_logo_black.svg.png"
    
    @IBOutlet weak var collectionControl: UISegmentedControl!
    @IBOutlet weak var gridSegmentedControl: UISegmentedControl!
    
    override func viewWillAppear(_ animated: Bool) {
//        likedPhotos = obtainLikedImages()
////        likedPhotos = GlobalVariables.photos.filter{$0.value.liked == true}
//        collectionView.reloadData()
        
        let context = getContext()
        let fetchRequest: NSFetchRequest<ImageLike> = ImageLike.fetchRequest()
        // Sorting of tasks list
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
//        fetchRequest.sortDescriptors = [sortDescriptor]
        
//        saveString(withString: testImageURL)
        
        // Obtain data from context
//        imageLikes = []
        do {
            try imageLikes = context.fetch(fetchRequest)
//            print("\nLikes: \(imageLikes.count)\n")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Clear all CoreData
//        clearString()
//        collectionView.reloadData()
        
        overrideUserInterfaceStyle = .dark
        
        // Turn off scroll indicator
        collectionView.showsVerticalScrollIndicator = false
        
        // Count size of item based on screen size
        calculateCollection()
        
        gridSegmentedControl.selectedSegmentTintColor = UIColor(named: "AccentColor")
//        let segment0Image = UIImage(systemName: "square.grid.3x2.fill")?.withTintColor(.blue, renderingMode: .alwaysTemplate)
//        gridSegmentedControl.setImage(segment0Image, forSegmentAt: 0)
        
//        // Count size of item based on screen size
//        let paddingTotalWidth = paddingWidth * (itemsPerRow + 1)
//        let itemWidth = CGFloat(Int( (collectionView.frame.width - paddingTotalWidth) / itemsPerRow ))
//
//        //Set layout parameters
//        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.sectionInset = UIEdgeInsets(top: paddingWidth
//                                           , left: paddingWidth
//                                           , bottom: paddingWidth
//                                           , right: paddingWidth)
//        layout.minimumLineSpacing = paddingWidth
//        layout.minimumInteritemSpacing = paddingWidth
//        layout.estimatedItemSize = CGSize(width: 0, height: 0)
//        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
    }
    
    // Segue to image detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickImageSegue3" {
            let navVC = segue.destination as! UINavigationController
            let photoVC = navVC.viewControllers.first as! PhotoViewController
            let cell = sender as! PhotoCell
            photoVC.imageSegueURL = cell.imageURL
            photoVC.likedVC = self
        }
    }
    
    func calculateCollection() {
        let paddingTotalWidth = paddingWidth * (itemsPerRow + 1)
//        print(itemsPerRow, paddingTotalWidth, "\n")
//        let itemWidth = CGFloat(Int( (collectionView.frame.width - paddingTotalWidth) / itemsPerRow ))
        let itemWidth = CGFloat((collectionView.frame.width - paddingTotalWidth) / itemsPerRow )
        
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
    }

    @IBAction func collectionControlAction(_ sender: Any) {
        switch collectionControl.selectedSegmentIndex {
        case 0:
            itemsPerRow = 3
            paddingWidth = 3
        case 1:
            itemsPerRow = 1
            paddingWidth = 12
        default:
            break
        }
        calculateCollection()
        collectionView.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageLikes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "likedCell", for: indexPath) as! PhotoCell
        
        cell.backgroundColor = .systemGray5
        
        let imageName = URL(string: imageLikes[indexPath.item].imageURL!)
//        else {
//            print("No test URL\n\n")
//            return
//        }
        
//        let imageRef = storageItems[indexPath.item]
        
//        imageName.downloadURL { [weak self] (url, error) in
//            if let error = error {
//                print("get Error\n",error)
//            }
//
//            guard let url = url else { return }
//            print(url)
//            print(url.absoluteURL)
//            let newURL = URL(string: "")
//            self?.imageURL = url
            cell.imageURL = imageName
//        print(imageName?.absoluteURL)
//        print(imageName?.absoluteString)
            let resource = ImageResource(downloadURL: imageName!)
            cell.cellImageView.kf.setImage(with: resource) { (result) in
                switch result {
                case .success(_):
                    //                print("success")
                    break
                case .failure(_):
                    print("fail")
                }
            }
//        }
        
//        collectionView.reloadData()
        
        return cell
    }
    
    // MARK: CoreData functions
    
    // Get context for app
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // Add new record in CoreData
    private func saveString(withString title: String) {
        let context = getContext()
         
        guard let entity = NSEntityDescription.entity(forEntityName: "ImageLike", in: context) else {return}
        
        // Create new task
        let taskObject = ImageLike(entity: entity, insertInto: context)
        taskObject.imageURL = title
        
        // Save new task in memory at 0 position
        do {
            try context.save()
//            tasks.append(taskObject)
            imageLikes.insert(taskObject, at: 0)
        } catch let error as NSError  {
            print(error.localizedDescription)
        }
    }
    
    // Clear all records in CoreData
    private func clearString() {
        let context = getContext()
        let fetchRequest: NSFetchRequest<ImageLike> = ImageLike.fetchRequest()
        if let result = try? context.fetch(fetchRequest) {
            for object in result {
                context.delete(object)
            }
        }
        
        do {
            try context.save()
        } catch let error as NSError  {
            print(error.localizedDescription)
        }
        imageLikes = []
    }
    
    // Read Likes from hardcoded global variable (struct)
//    func obtainLikedImages() -> [ImageItems] {
//        var likedArray: [ImageItems] = []
//
//        for item in GlobalVariables.photos.values {
//            if item.liked {
//                likedArray.append(item)
//            }
//        }
//
//        return likedArray
//    }

}
