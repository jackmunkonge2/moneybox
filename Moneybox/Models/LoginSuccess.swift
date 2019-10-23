//
//  LoginSuccess.swift
//  Moneybox
//
//  Created by Jack Munkonge on 23/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import Foundation

struct LoginSuccess: Codable {
    var session: Session
    
    private enum CodingKeys: String, CodingKey {
        case session = "Session"
    }
}

struct Session: Codable {
    var bearerToken: String
    
    private enum CodingKeys: String, CodingKey {
        case bearerToken = "BearerToken"
    }
}
