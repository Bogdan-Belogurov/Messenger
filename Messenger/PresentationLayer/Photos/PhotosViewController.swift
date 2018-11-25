//
//  PhotosCollectionViewController.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 23/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import UIKit

private let reuseIdentifier = "collectionCell"

class PhotosViewController: UIViewController {

    @IBAction func dismissVC(_ sender: Any) {
        self.imagesCashArray.removeAllObjects()
        dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusBarView: UIView!
    var imagesCashArray = NSCache<NSString, UIImage>()
    var closurePhoto: ((UIImage) -> ())?
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    var photosModel: IPhotosModel = AppDelegate.rootAssembly.presentationAssembly.photosModel
    private var dataSource: [CellDisplayModel] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photosModel.delegate = self
        statusBarView.backgroundColor = UINavigationBar.appearance().barTintColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.photosModel.fetchNewPhotos()
    }
    
}

extension PhotosViewController: IPhotoModelDelegate {
    func setup(dataSource: [CellDisplayModel]) {
        self.dataSource = dataSource
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.collectionView.reloadData()
        }
    }
    
    func show(error message: String) {
        let alertController = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

    // MARK: UICollectionViewDataSource
extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotoCollectionViewCell else { return PhotoCollectionViewCell(frame: CGRect.zero) }
        if let cashedPhoto = imagesCashArray.object(forKey: self.dataSource[indexPath.item].previewURL as NSString) {
            cell.image = cashedPhoto
            return cell
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                self.photosModel.fetchImage(urlString: self.dataSource[indexPath.item].previewURL) { (image) in
                    if let image = image {
                        self.imagesCashArray.setObject(image, forKey: self.dataSource[indexPath.item].previewURL as NSString)
                        DispatchQueue.main.async {
                                cell.image = image
                        }
                    }
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Chose image")
        
        UIView.animate(withDuration: 0.2, animations: {
            self.collectionView?.alpha = 0.1
        }, completion: nil)
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.imagesCashArray.removeAllObjects()
        DispatchQueue.global(qos: .userInitiated).async {
            self.photosModel.fetchImage(urlString: self.dataSource[indexPath.item].webformatUrl) { (image) in
                if let image = image {
                    DispatchQueue.main.async {
                            self.closurePhoto?(image)
                            self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
        
    }
}
    // MARK: UICollectionViewDelegate
extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let commonSpace = self.sectionInsets.right * (self.itemsPerRow + 1)
        let availableWidth = self.view.frame.width - commonSpace
        let spaceForItem = availableWidth / itemsPerRow
        return CGSize(width: spaceForItem, height: spaceForItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.sectionInsets.left
    }
}
