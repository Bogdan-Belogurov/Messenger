//
//  PhotoRequest.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 23/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

class PhotoRequest: IRequest {
    private let apiKey: String
    private var urlString: String {
        return "https://pixabay.com/api/?key=\(self.apiKey)&q=otters&image_type=photo&pretty=true&per_page=102"
    }
    var urlRequest: URLRequest? {
        get {
            if let url = URL(string: self.urlString) {
                return URLRequest(url: url)
            }
            return nil
        }
    }
    init(apiKey: String) {
        self.apiKey = apiKey
    }
}
