//
//  HttpResponse.swift
//  Moneybox
//
//  Created by Jack Munkonge on 23/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import Foundation

struct HttpResponse {
    
    var response: URLResponse?
    var httpStatusCode: Int = 0
    var headers = RestEntity()
    
    init(fromURLResponse response: URLResponse?) {
        guard let response = response else { return }
        self.response = response
        httpStatusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

        if let headerFields = (response as? HTTPURLResponse)?.allHeaderFields {
           for (key, value) in headerFields {
               headers.add(value: "\(value)", forKey: "\(key)")
           }
        }
    }
}
