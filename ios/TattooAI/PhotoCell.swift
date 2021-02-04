//
//  PhotoCell.swift
//  PhotoTapps
//
//  Created by Nikolay Kryuchkov on 10.01.2021.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    var imageID: Int?
    var imageURL: URL?
    
    @IBOutlet weak var cellImageView: UIImageView!
}
