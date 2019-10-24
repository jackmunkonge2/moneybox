//
//  Moneybox.swift
//  Moneybox
//
//  Created by Jack Munkonge on 23/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import Foundation

struct Moneybox: Codable {
    var moneybox: Double
    
    private enum CodingKeys: String, CodingKey {
        case moneybox = "Moneybox"
    }
}
