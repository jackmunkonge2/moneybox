//
//  HttpResults.swift
//  Moneybox
//
//  Created by Jack Munkonge on 23/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import Foundation

struct HttpResults {
    var data: Data?
    var response: HttpResponse?
    var error: Error?
    
    init(withData data: Data?, response: HttpResponse?, error: Error?) {
       self.data = data
       self.response = response
       self.error = error
    }
    
    init(withError error: Error) {
       self.error = error
    }
}
