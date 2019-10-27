//
//  RestEntity.swift
//  Moneybox
//
//  Created by Jack Munkonge on 23/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import Foundation

struct RestEntity {
    private var values: [String: String] = [:]
 
    mutating func add(value: String, forKey key: String) {
        values[key] = value
    }
    
    mutating func clear() {
        values = [:]
    }
 
    func value(forKey key: String) -> String? {
        return values[key]
    }
 
    func allValues() -> [String: String] {
        return values
    }
 
    func totalItems() -> Int {
        return values.count
    }
}

extension RestEntity: Equatable {
  static func ==(lhs: RestEntity, rhs: RestEntity) -> Bool {
    return lhs.values == rhs.values
  }
}
