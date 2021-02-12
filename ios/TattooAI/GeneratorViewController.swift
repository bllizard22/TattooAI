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
    @IBOutlet weak var generateButton: UILabel!
    
//    var settings = ["colorArray": 0, "placeArray": 0, "styleArray": 0]
    var imageLikes: [ImageLike] = []
    
    let storage = Storage.storage(url:"gs://firephotos-40d70.appspot.com")
    var storageItems: [FirebaseStorage.StorageReference] = []
    var imageURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/1920px-Apple_logo_black.svg.png")
    var imageSegueURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorLabel.text = commonArray[0][0]
        placeLabel.text = commonArray[1][1]
        styleLabel.text = commonArray[2][2]
        
        loadStorageData()
        loadCoreData()
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(GeneratorViewController.labelTap))
        colorLabel.isUserInteractionEnabled = true
        colorLabel.addGestureRecognizer(tap)

        imageView.layer.cornerRadius = 10
//        imageView.image = UIImage(named: "70")
        
//        let storageRef = storage.reference()
//        storageRef.downloadURL { [weak self] (url, error) in
//            if let error = error {
//                print("get Error\n",error)
//            }
//
//            guard let url = url else { return }
////                print(url)
////                print(url.absoluteURL)
////                let newURL = URL(string: "")
//            self?.imageURL = url
//            cell.imageURL = url
//            let resource = ImageResource(downloadURL: (self?.imageURL)!)
//            cell.cellImageView.kf.setImage(with: resource) { (result) in
//                switch result {
//                case .success(_):
//                    //                print("success")
//                    break
//                case .failure(_):
//                    print("fail")
//                }
//            }
//        }
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
        
        if segue.identifier == "pickImageSegue4" {
            let navVC = segue.destination as! UINavigationController
            let photoVC = navVC.viewControllers.first as! PhotoViewController
//            let image = sender as! UIImageView
//            photoVC.image = cell.cellImageView.image
//            photoVC.imageID = cell.imageID
            photoVC.imageSegueURL = imageURL
        }
    }
    
//    override func performSegue(withIdentifier identifier: String, sender: Any?) {
//        if identifier == "pickImageSegue4" {
//            let navVC = destination as! UINavigationController
//            let photoVC = navVC.viewControllers.first as! PhotoViewController
//            let cell = sender as! PhotoCell
////            photoVC.image = cell.cellImageView.image
////            photoVC.imageID = cell.imageID
//            photoVC.imageSegueURL = cell.imageURL
//        }
//    }
    
    @IBAction func generateImage(_ sender: Any) {
        generateRandomImage()
        print(imageURL)
    }
    
    @IBAction func labelTap(sender: UITapGestureRecognizer) {
//            print("tap working")
        
        displayError(message: "new")
        }
    
    func displayError(message: String) {
        let alertView = UIAlertController(title: "Oops!", message: "message", preferredStyle: .actionSheet)
        
//        let doneAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        for item in colorArray {
            let colorAction = UIAlertAction(title: item.value, style: .default, handler: nil)
            alertView.addAction(colorAction)
        }
        
        
        self.present(alertView, animated: true, completion: nil)
    }
    
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
    
    // MARK: CoreData work with context and data
    
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
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func checkLike() {
        if imageLikes.first(where: { $0.imageURL == imageSegueURL?.absoluteString}) != nil {
            likeButton.setImage(UIImage(named: "heart_green")?.withRenderingMode(.alwaysTemplate),
                                for: .normal)
            
            likeButton.tintColor = UIColor(red: MainColor.red,
                                           green: MainColor.green,
                                           blue: MainColor.blue,
                                           alpha: 1.0)
        } else {
            likeButton.setImage(UIImage(named: "heart_white")?.withRenderingMode(.alwaysTemplate),
                                for: .normal)
            likeButton.tintColor = .white
        }
    }
    
    func generateRandomImage() {
        guard let randomItem = storageItems.randomElement() else {return}
        print(randomItem)
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
