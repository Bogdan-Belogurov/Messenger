//
//  IImagesService.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 23/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation
protocol IImagesService {
    func loadPhoto(completionHandler: @escaping ([PhotoModel]?, String?) -> Void)
    func loadImage(urlString: String, completionHandler: @escaping (ImageModel?, String?) -> ())
}
