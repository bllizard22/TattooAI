//
//  GeneratorViewController.swift
//  TattooAI
//
//  Created by Nikolay Kryuchkov on 09.02.2021.
//

import UIKit
import CoreData
import Firebase
import Kingfisher

class GeneratorViewController: UIViewController {

    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var generateButton: UIButton!
    
    @IBOutlet weak var textStackView: UIStackView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    //    var settings = ["colorArray": 0, "placeArray": 0, "styleArray": 0]
    var imageLikes: [ImageLike] = []
    
    let storage = Storage.storage(url:"gs://firephotos-40d70.appspot.com")
    var storageItems: [FirebaseStorage.StorageReference] = []
    var storageItemsFiltered: [FirebaseStorage.StorageReference] = []
    var imageURL = URL(string: " ")
//    var imageURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/firephotos-40d70.appspot.com/o/70.jpg?alt=media&token=a4f4c0fb-5ebd-4a9c-964e-c0d63c6d9bdc")
//    var imageSegueURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadStorageData()
        loadCoreData()
        
        colorLabel.text = commonArray[0][0]
        placeLabel.text = commonArray[1][0]
        styleLabel.text = commonArray[2][0]

        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        let verticalPadding = (screenHeight - (textStackView.bounds.size.height + imageView.bounds.height + buttonsStackView.bounds.height))/4
        let safeArea = self.view.safeAreaLayoutGuide
        let textStackTopConstraint = textStackView.topAnchor.constraint(equalTo: safeArea.topAnchor,
                                                                        constant: verticalPadding)
        let imageTopConstraint = imageView.topAnchor.constraint(equalTo: textStackView.bottomAnchor,
                                                                constant: verticalPadding)
        let buttonsTopConstraint = buttonsStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor,
                                                                         constant: verticalPadding)
//        NSLayoutConstraint.activate([textStackTopConstraint, imageTopConstraint, buttonsTopConstraint])
        
        imageView.layer.cornerRadius = 10
        settingsButton.layer.cornerRadius = 10
        settingsButton.clipsToBounds = true
        settingsButton.contentMode = .scaleAspectFit
//        settingsButton.setImage(UIImage(named: "list"), for: .normal)
        generateButton.layer.masksToBounds = true
        generateButton.layer.cornerRadius = 10
        
        checkLike()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        if let pageVC = storyboard?.instantiateViewController(withIdentifier: "PageViewController") as? PageViewController {
//            present(pageVC, animated: true, completion: nil)
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settings" {
            
        }
        
        if segue.identifier == "pickImageSegue4" {
//            guard imageURL!.absoluteString == " " else {
//                return
//            }
            let navVC = segue.destination as! UINavigationController
            let photoVC = navVC.viewControllers.first as! PhotoViewController
//            let image = sender as! UIImageView
//            photoVC.image = cell.cellImageView.image
//            photoVC.imageID = cell.imageID
            photoVC.imageSegueURL = imageURL
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func generateImage(_ sender: Any) {
        generateRandomImage()
    }
    
    @IBAction func likeAction(_ sender: Any) {
        if imageLikes.first(where: { $0.imageURL == imageURL?.absoluteString}) != nil {
            deleteString(withString: imageURL!.absoluteString)
            likeButton.setImage(UIImage(named: "like_clear")?.withRenderingMode(.alwaysTemplate),
                                for: .normal)
            likeButton.tintColor = .white
        } else {
            saveString(withString: imageURL!.absoluteString)
            likeButton.setImage(UIImage(named: "like_fill")?.withRenderingMode(.alwaysTemplate),
                                for: .normal)
            likeButton.tintColor = UIColor(named: "AccentColor")
        }
        loadCoreData()
    }
    
    
//    @IBAction func labelTap(sender: UITapGestureRecognizer) {
////            print("tap working")
//
//        displayError(message: "new")
//        }
    
//    func displayError(message: String) {
//        let alertView = UIAlertController(title: "Oops!", message: "message", preferredStyle: .actionSheet)
//
////        let doneAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        for item in colorArray {
//            let colorAction = UIAlertAction(title: item.value, style: .default, handler: nil)
//            alertView.addAction(colorAction)
//        }
//
//
//        self.present(alertView, animated: true, completion: nil)
//    }
    
    func loadStorageData() {
        // List all images in Storage
        let storageRef = storage.reference().child("images")
        storageRef.listAll { [weak self] (result, error) in
            if let error = error {
                print("list Error\n", error)
          }
//          for prefix in result.prefixes {
//            print(prefix)
//          }
          for item in result.items {
//            print(item)
            self?.storageItems.append(item)
          }
        }
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
        } catch let error as NSError  {
            print(error.localizedDescription)
        }
    }
    
    // Add new record in CoreData
    private func deleteString(withString title: String) {
        let context = getContext()
        
        let fetchRequest: NSFetchRequest<ImageLike> = ImageLike.fetchRequest()
        if let result = try? context.fetch(fetchRequest) {
            for image in result {
                if image.imageURL == imageURL?.absoluteString {
                    context.delete(image)
                    guard let index = imageLikes.firstIndex(where: {$0.imageURL == imageURL?.absoluteString}) else {return}
                    imageLikes.remove(at: index)
                }
            }
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
        
        do {
            try context.save()
        } catch let error as NSError  {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - CoreData work with context and data
    
    // Get context for app
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // Reload data from CoreData
    func loadCoreData() {
        let context = getContext()
        let fetchRequest: NSFetchRequest<ImageLike> = ImageLike.fetchRequest()
        // Sorting of tasks list
        let sortDescriptor = NSSortDescriptor(key: "imageURL", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        // Obtain data from context
        
        do {
            try imageLikes = context.fetch(fetchRequest)
//            print(imageLikes, "likes")
//            print("[2] in imageLikes\n", imageLikes[2].imageURL)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func checkLike() {
//        print(imageLikes, "likes")
        if imageLikes.first(where: { $0.imageURL == imageURL?.absoluteString}) != nil {
            likeButton.setImage(UIImage(named: "like_fill")?.withRenderingMode(.alwaysTemplate),
                                for: .normal)
            
            likeButton.tintColor = UIColor(named: "AccentColor")
        } else {
            likeButton.setImage(UIImage(named: "like_clear")?.withRenderingMode(.alwaysTemplate),
                                for: .normal)
            likeButton.tintColor = .white
        }
    }
    
    func generateRandomImage() {
        var randomItem = storage.reference().child("70.jpg")
        if colorLabel.text == "Any" {
            guard let _randomItem = storageItems.randomElement() else { return }
            randomItem = _randomItem
        } else {
            guard let _randomItem = storageItemsFiltered.randomElement() else { return }
            randomItem = _randomItem
        }
//        print(randomItem)
        
        randomItem.downloadURL { [weak self] (url, error) in
            if let error = error {
                print("get Error\n",error)
            }
            
            guard let url = url else { return }
//                print(url)
//                print(url.absoluteURL)
//            let newURL = URL(string: "")
            let imageURL = url
            self?.imageURL = url
            //            cell.imageURL = url
            let resource = ImageResource(downloadURL: imageURL)
            self?.checkLike()
            self?.imageView.kf.setImage(with: resource,
//                                             placeholder: UIImage(systemName: "heart"),
                                             options: [.progressiveJPEG(ImageProgressive(isBlur: true, isFastestScan: true, scanInterval: 0.5)),
                                                       .transition(ImageTransition.fade(0.3)),
                                                       .forceTransition])
            { (result) in
                switch result {
                case .success(_):
//                    self?.checkLike()
                    break
                case .failure(_):
                    print("fail")
                }
            }
        }
    }
    
    func getFilteredItems() {
        // List all images in Storage
        let colorParameter = colorLabel.text?.lowercased() ?? "images"
        if colorParameter == "any" { return }
        storageItemsFiltered.removeAll()
        let storageRef = storage.reference().child(colorParameter)
        storageRef.listAll { [weak self] (result, error) in
            if let error = error {
                print("list Error\n", error)
          }
//          for prefix in result.prefixes {
//            print(prefix)
//          }
          for item in result.items {
//            print(item)
            self?.storageItemsFiltered.append(item)
          }
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
