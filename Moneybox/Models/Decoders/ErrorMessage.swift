//
//  ErrorMessage.swift
//  Moneybox
//
//  Created by Jack Munkonge on 14/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import Foundation


struct StandardErrorMessage: Codable {
    var name: String
    var message: String
    var validationErrors: [String]
    
    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case message = "Message"
        case validationErrors = "ValidationErrors"
    }
    
    init(_ name: String, _ message: String) {
        self.name = name
        self.message = message
        self.validationErrors = []
    }
}

struct ValidationErrorMessage: Codable {
    var name: String
    var message: String
    var validationErrors: [ValidationError]
    
    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case message = "Message"
        case validationErrors = "ValidationErrors"
    }
}

struct ValidationError: Codable {
    var name: String
    var message: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case message = "Message"
    }
}

struct AuthErrorMessage: Codable {
    var name: String
    var message: String
    var validationErrors: [String]
    
    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case message = "Message"
        case validationErrors = "ValidationErrors"
    }
}
