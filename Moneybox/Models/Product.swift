//
//  Product.swift
//  Moneybox
//
//  Created by Jack Munkonge on 16/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import Foundation

struct Product {
    var productName: String
    var planValue: String
    var moneybox: String
    
    init?(productName: String, planValue: String, moneybox: String){
        if productName == "" || planValue == "" || moneybox == "" {
            return nil
        }
        
        self.productName = productName
        self.planValue = planValue
        self.moneybox = moneybox
    }
}
