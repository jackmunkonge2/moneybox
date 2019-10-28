//
//  HttpResultsTest.swift
//  UnitTests
//
//  Created by Jack Munkonge on 27/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import Foundation

import XCTest
@testable import Moneybox

class HttpResultsTest: XCTestCase {
    let url = URL(string: "http://test.com")!
    let data = Data()
    let error = CustomError.failedToCreateRequest

    var response: HTTPURLResponse?
    var httpResponse: HttpResponse?
    
    override func setUp() {
        super.setUp()
        response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        httpResponse = HttpResponse(fromURLResponse: response)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testHttpResults_withData_isValid() {
        let results = HttpResults(withData: data, response: httpResponse, error: error)
        XCTAssertEqual(results.data, Data())
        XCTAssertEqual(results.response, httpResponse)
        XCTAssertTrue(results.error is CustomError)
    }
    
    func testHttpResults_withError_isValid() {
        let results = HttpResults(withError: error)
        XCTAssertNil(results.data)
        XCTAssertNil(results.response)
        XCTAssertTrue(results.error is CustomError)
    }
}
