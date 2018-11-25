//
//  RequestsFactory.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 23/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

struct RequestsFactory {
    struct PhotoRequests {
        
        static func photosConfig() -> RequestConfig<PhotoParser> {
            let request = PhotoRequest(apiKey: "10764880-0edb1ba4d74caddedf20599bf")
            return RequestConfig<PhotoParser>(request:request, parser: PhotoParser())
        }
        
        static func imageConfig(urlString: String) -> RequestConfig<ImageParser> {
            let request = ImageRequest(urlString: urlString)
            return RequestConfig<ImageParser>(request: request, parser: ImageParser())
        }
    }
}
