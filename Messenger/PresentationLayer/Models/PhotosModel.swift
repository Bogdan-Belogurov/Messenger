//
//  PhotosModel.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 24/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

struct CellDisplayModel {
    let webformatUrl: String
    let previewURL: String
}

protocol IPhotosModel: class {
    var delegate: IPhotoModelDelegate? { get set }
    func fetchNewPhotos()
    func fetchImage(urlString: String, completionHandler: @escaping (UIImage?) -> ())
}

protocol IPhotoModelDelegate: class {
    func setup(dataSource: [CellDisplayModel])
    func show(error message: String)
}

class PhotosModel: IPhotosModel {
    var delegate: IPhotoModelDelegate?
    
    private let imageService: IImagesService
    
    init(imageService: IImagesService) {
        self.imageService = imageService
    }
    
    func fetchNewPhotos() {
        self.imageService.loadPhoto { (photos: [PhotoModel]?, error) in
            if let photos = photos {
                let cells = photos.map({CellDisplayModel(webformatUrl: $0.webformatURL, previewURL: $0.previewURL)})
                self.delegate?.setup(dataSource: cells)
            } else {
                self.delegate?.show(error: error ?? "error")
            }
        }
    }
    
    func fetchImage(urlString: String, completionHandler: @escaping (UIImage?) -> ()) {
        self.imageService.loadImage(urlString: urlString) { (imageModel: ImageModel?, error) in
            if let imageModel = imageModel {
                completionHandler(imageModel.image)
            } else {
                completionHandler(nil)
            }
        }
    }
}
