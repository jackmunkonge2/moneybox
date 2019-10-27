//
//  RestEntityTest.swift
//  UnitTests
//
//  Created by Jack Munkonge on 27/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import Foundation

import XCTest
@testable import Moneybox

class RestEntityTest: XCTestCase {
    let emptyRestEntity = RestEntity()
    var filledRestEntity = RestEntity()
    
    override func setUp() {
        super.setUp()
        filledRestEntity.add(value: "val1", forKey: "key1")
        filledRestEntity.add(value: "val2", forKey: "key2")
    }

    override func tearDown() {
        super.tearDown()
    }

    func testRestEntity_whenCleared_shouldBeEmpty() {
        var sut = filledRestEntity
        sut.clear()
        XCTAssertEqual(sut, emptyRestEntity)
    }
    
    func testRestEntity_whenGetValue_shouldReturn() {
        let value = filledRestEntity.value(forKey: "key1")
        XCTAssertEqual(value, "val1")
    }
    
    func testRestEntity_whenGetAllValues_shouldReturn() {
        let values = filledRestEntity.allValues()
        XCTAssertEqual(values, ["key1": "val1", "key2": "val2"])
    }
    
    func testRestEntity_whenGetItemCount_shouldReturn() {
        let count = filledRestEntity.totalItems()
        XCTAssertEqual(count, 2)
    }
}
