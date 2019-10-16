//
//  Decoders.swift
//  Moneybox
//
//  Created by Jack Munkonge on 14/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import Foundation

struct StandardErrorResponse: Codable {
    var name: String
    var message: String
    var validationErrors: [String]
    
    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case message = "Message"
        case validationErrors = "ValidationErrors"
    }
}

struct ValidationErrorResponse: Codable {
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

struct InvestorProducts: Codable {
    var totalPlanValue: Double
    var productResponses: [InvestorProductResponse]
    
    private enum CodingKeys: String, CodingKey {
        case totalPlanValue = "TotalPlanValue"
        case productResponses = "ProductResponses"
    }
}

struct InvestorProductResponse: Codable {
    var id: Int
    var planValue: Double
    var moneybox: Int
    var product: InvestorProduct
    
    private enum CodingKeys: String, CodingKey {
        case id = "Id"
        case planValue = "PlanValue"
        case moneybox = "Moneybox"
        case product = "Product"
    }
}

struct InvestorProduct: Codable {
    var id: Int
    var type: String
    var friendlyName: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "Id"
        case type = "Type"
        case friendlyName = "FriendlyName"
    }
}
