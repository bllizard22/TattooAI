//
//  PhotoViewController.swift
//  PhotoTapps
//
//  Created by Nikolay Kryuchkov on 10.01.2021.
//

import UIKit
import CoreData
import Kingfisher
import Firebase

class PhotoViewController: UIViewController {

//    var image: UIImage?
//    var imageName: String?
//    var imageID: Int?
//    var imageEntity: ImageLike?
//    var imageLikesList: [String] = []
    var imageSegueURL: URL?
    var imageLikes: [ImageLike] = []
    var likedVC: LikedCollectionViewController?
    
    // MARK: Firebase variables
//    let storageURL = "gs://firephotos-40d70.appspot.com/"
//    let folderURL = "images/"
    let storage = Storage.storage(url:"gs://firephotos-40d70.appspot.com")
    
//    var storageRef = Storage.storage(url:"gs://firephotos-40d70.appspot.com").reference().child("images")
//    var imageURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/1920px-Apple_logo_black.svg.png")
//    var storageSize: String = ""
    var storageItems: [FirebaseStorage.StorageReference] = []
    
    @IBOutlet weak var photoImageView: UIImageView!
//    @IBOutlet weak var imageScrollView: UIScrollView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadStorageData()
//        overrideUserInterfaceStyle = .dark
        
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

        if imageLikes.first(where: { $0.imageURL == imageSegueURL?.absoluteString}) != nil {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.tintColor = #colorLiteral(red: 0, green: 0.9913747907, blue: 0.7009736896, alpha: 1)
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = .white
        }


        let resource = ImageResource(downloadURL: imageSegueURL!)
        photoImageView.kf.setImage(with: resource) { (result) in
            switch result {
            case .success(_):
//                print("success")
                break
            case .failure(_):
                print("fail")
            }
        }
        
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 20
//        photoImageView.layer.masksToBounds = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard likedVC != nil else {
            return
        }
        likedVC?.collectionView.reloadData()
    }
    // MARK: Image zoom
//    private func setMinZoomScaleForImageSize(_ imageSize: CGSize) {
//        let widthScale = view.frame.width / imageSize.width
//        let heightScale = view.frame.height / imageSize.height
//        let minScale = min(widthScale, heightScale)
//
//        // Scale the image down to fit in the view
//        imageScrollView.minimumZoomScale = minScale
//        imageScrollView.zoomScale = minScale
//
//        // Set the image frame size after scaling down
//        let imageWidth = imageSize.width * minScale
//        let imageHeight = imageSize.height * minScale
//        let newImageFrame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
//        photoImageView.frame = newImageFrame
//
//        centerImage()
//    }
//
//    private func centerImage() {
//        let imageViewSize = photoImageView.frame.size
//        let scrollViewSize = view.frame.size
//        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
//        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
//
//        imageScrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
//    }
    
//    @IBAction func doubleTapImage(_ sender: Any) {
//        if imageScrollView.zoomScale == imageScrollView.minimumZoomScale {
//            imageScrollView.zoom(to: zoomRectangle(scale: imageScrollView.maximumZoomScale, center: (sender as AnyObject).location(in: (sender as AnyObject).view)), animated: true)
//        } else {
//            imageScrollView.setZoomScale(imageScrollView.minimumZoomScale, animated: true)
//        }
//    }
//    
//    private func zoomRectangle(scale: CGFloat, center: CGPoint) -> CGRect {
//            var zoomRect = CGRect.zero
//            zoomRect.size.height = photoImageView.frame.size.height / scale
//            zoomRect.size.width  = photoImageView.frame.size.width  / scale
//            zoomRect.origin.x = center.x - (center.x * imageScrollView.zoomScale)
//            zoomRect.origin.y = center.y - (center.y * imageScrollView.zoomScale)
//            
//            return zoomRect
//        }
    
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
//            let storageSize = String(result.items.count)
//            print(storageSize)
//            self?.collectionView.reloadData()
        }
    }
    
    
    // MARK: IBActions
    
    @IBAction func shareAction(_ sender: Any) {
        let shareController = UIActivityViewController(activityItems: [photoImageView.image!], applicationActivities: nil)
        
        present(shareController, animated: true, completion: nil )
    }
    
    @IBAction func likeAction(_ sender: Any) {
        
        if imageLikes.first(where: { $0.imageURL == imageSegueURL?.absoluteString}) != nil {
            deleteString(withString: imageSegueURL!.absoluteString)
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = .white
        } else {
            saveString(withString: imageSegueURL!.absoluteString)
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.tintColor = #colorLiteral(red: 0, green: 0.9913747907, blue: 0.7009736896, alpha: 1)
        }
    }
    
    @IBAction func randomImage(_ sender: Any) {
        guard let randomItem = storageItems.randomElement() else {return}
        print(randomItem)
        
//        let resource = ImageResource(downloadURL: randomItem)
//        photoImageView.kf.setImage(with: resource) { (result) in
//            switch result {
//            case .success(_):
////                print("success")
//                break
//            case .failure(_):
//                print("fail")
//            }
//        }
        
        randomItem.downloadURL { [weak self] (url, error) in
            if let error = error {
                print("get Error\n",error)
            }
            
            guard let url = url else { return }
//                print(url)
//                print(url.absoluteURL)
            let newURL = URL(string: "")
            let imageURL = url
//            cell.imageURL = url
            let resource = ImageResource(downloadURL: imageURL)
            self?.photoImageView.kf.setImage(with: resource) { (result) in
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
    
    // MARK: CoreData work with context and data
    
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
                if image.imageURL == imageSegueURL?.absoluteString {
                    context.delete(image)
                    guard let index = imageLikes.firstIndex(where: {$0.imageURL == imageSegueURL?.absoluteString}) else {return}
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

}

//extension UIImageView {
//  func enableZoom() {
//    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
//    isUserInteractionEnabled = true
//    addGestureRecognizer(pinchGesture)
//  }
//
//  @objc
//  private func startZooming(_ sender: UIPinchGestureRecognizer) {
//    let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
//    guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
//    sender.view?.transform = scale
//    sender.scale = 1
//  }
//}
//
//extension PhotoViewController: UIScrollViewDelegate {
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return photoImageView
//    }
//
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        centerImage()
//    }
//}
