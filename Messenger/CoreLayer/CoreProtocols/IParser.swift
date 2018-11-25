//
//  IParser.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 23/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

protocol IParser {
    associatedtype Model
    func parse(data: Data) -> Model?
}
