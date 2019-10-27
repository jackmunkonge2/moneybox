//
//  RestServiceTest.swift
//  UnitTests
//
//  Created by Jack Munkonge on 27/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import XCTest
import Mockingjay
@testable import Moneybox

class RestServiceTest: XCTestCase {
    
    let rest = RestService()
    let url = URL(string: "http://test.com/users/login")!
    let data = Data("""
    {
      "Moneybox": 500
    }
    """.utf8)
    
    var httpBody: Data?
    var requestHttpHeaders = RestEntity()
    var urlQueryParameters = RestEntity()
    var httpBodyParameters = RestEntity()
    
    override func setUp() {
        super.setUp()
        requestHttpHeaders.add(value: "foo", forKey: "Content-Type")
//        stub(http(.post, uri: "/users/login"), jsonData(data))
    }
    
    override func tearDown() {
        super.tearDown()
        removeAllStubs()
    }
    
    func testMakeRequest_login_isValid() {
        rest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            print("##################   \(results)    #####################")
            return
        }
    }
    
//    func httpResultsBuilder(request: URLRequest) -> HttpResults {
//      let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
//      return .success(response, .noContent)
//    }
}
