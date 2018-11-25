//
//  ImageParser.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 23/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

struct ImageModel {
    let image: UIImage
}

class ImageParser: IParser {
    typealias Model = ImageModel
    
    func parse(data: Data) -> ImageParser.Model? {
        if let image = UIImage(data: data) {
            return ImageModel(image: image)
        }
        return nil
    }
}
