//
//  IRequestSender.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 23/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

struct RequestConfig<Parser> where Parser: IParser {
    let request: IRequest
    let parser: Parser
}

enum Result<Model> {
    case success(Model)
    case error(String)
}

protocol IRequestSender {
    func send<Parser>(requestConfig: RequestConfig<Parser>,
                      completionHandler: @escaping(Result<Parser.Model>) -> Void)
}
