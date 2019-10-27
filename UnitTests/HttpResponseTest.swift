//
//  HttpResponseTest.swift
//  UnitTests
//
//  Created by Jack Munkonge on 25/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import XCTest
@testable import Moneybox

class HttpResponseTest: XCTestCase {
    let url = URL(string: "http://test.com")!
    let headers = ["key1": "val1", "key2": "val2"]
    
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

    func testHttpResponse_urlResponseNil_shouldInitWithDefaults() {
        let httpResponse = HttpResponse(fromURLResponse: nil)
        XCTAssertNil(httpResponse.response)
        XCTAssertEqual(httpResponse.httpStatusCode, 0)
        XCTAssertEqual(httpResponse.headers.allValues(), [:])
    }
    
    func testHttpResponse_statusCodeNonNil_isValid() {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let httpResponse = HttpResponse(fromURLResponse: response)
        XCTAssertEqual(httpResponse.httpStatusCode, 200)
    }
    
    func testHttpResponse_containsHeaders_isValid() {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: headers)!
        let httpResponse = HttpResponse(fromURLResponse: response)
        XCTAssertEqual(httpResponse.headers.allValues(), headers)

    }
}
