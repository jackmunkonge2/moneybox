//
//  Structures.swift
//  Moneybox
//
//  Created by Jack Munkonge on 14/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import Foundation

struct NoAuthorization: Codable {
    var name: String
    var message: String
    var validationErrors: [String]
    
    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case message = "Message"
        case validationErrors = "ValidationErrors"
    }
}

struct InvalidCredentials: Codable {
    var name: String
    var message: String
    var validationErrors: [ValidationError]
    
    struct ValidationError: Codable {
        var name: String
        var message: String
        
        private enum CodingKeys: String, CodingKey {
            case name = "Name"
            case message = "Message"
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case message = "Message"
        case validationErrors = "ValidationErrors"
    }
}

struct LoginSuccess: Codable {
    var session: Session
    
    struct Session: Codable {
        var bearerToken: String
        
        private enum CodingKeys: String, CodingKey {
            case bearerToken = "BearerToken"
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case session = "Session"
    }
}
