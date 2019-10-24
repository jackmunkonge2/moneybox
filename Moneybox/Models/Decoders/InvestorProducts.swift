//
//  InvestorProducts.swift
//  Moneybox
//
//  Created by Jack Munkonge on 23/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import Foundation

struct InvestorProducts: Codable {
    var totalPlanValue: Double
    var productResponses: [ProductData]
    
    private enum CodingKeys: String, CodingKey {
        case totalPlanValue = "TotalPlanValue"
        case productResponses = "ProductResponses"
    }
}

struct ProductData: Codable {
    var id: Int
    var planValue: Double
    var moneybox: Int
    var product: ProductMetadata
    
    private enum CodingKeys: String, CodingKey {
        case id = "Id"
        case planValue = "PlanValue"
        case moneybox = "Moneybox"
        case product = "Product"
    }
}

struct ProductMetadata: Codable {
    var id: Int
    var type: String
    var friendlyName: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "Id"
        case type = "Type"
        case friendlyName = "FriendlyName"
    }
}
