//
//  PhotoCollectionViewCell.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 23/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell, PhotoCellConfiguration {
    
    @IBOutlet var imageView: UIImageView!
    
    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
}
