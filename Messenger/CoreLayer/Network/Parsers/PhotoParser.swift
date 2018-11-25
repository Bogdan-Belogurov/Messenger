//
//  PhotoParser.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 23/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

struct PhotoModel: Codable {
    let webformatURL: String
    let previewURL: String
    
    enum CodingKeys: String, CodingKey {
        case webformatURL = "webformatURL"
        case previewURL = "previewURL"
    }
}

struct Response: Codable {
    let hits: [PhotoModel]
}

class PhotoParser: IParser {
    typealias Model = [PhotoModel]
    
    func parse(data: Data) -> PhotoParser.Model? {
        do {
            return try JSONDecoder().decode(Response.self, from: data).hits
        } catch {
            print("error JSON")
            return nil
        }
    }
}
