//
//  ImagesService.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 23/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

class ImagesService: IImagesService {
    
    private let requestSender: IRequestSender
    
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    func loadPhoto(completionHandler: @escaping ([PhotoModel]?, String?) -> Void) {
        let requestConfig = RequestsFactory.PhotoRequests.photosConfig()
        
        self.requestSender.send(requestConfig: requestConfig) { (result: Result<[PhotoModel]>) in
            switch result {
            case .success(let images):
                completionHandler(images, nil)
            case .error(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    func loadImage(urlString: String, completionHandler: @escaping (ImageModel?, String?) -> ()) {
        let requestConfig = RequestsFactory.PhotoRequests.imageConfig(urlString: urlString)
        
        self.requestSender.send(requestConfig: requestConfig) { (result: Result<ImageModel>) in
            switch result {
            case .success(let images):
                completionHandler(images, nil)
            case .error(let error):
                completionHandler(nil, error)
            }
        }
    }
}
