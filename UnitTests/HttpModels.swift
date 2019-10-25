//
//  HttpModels.swift
//  UnitTests
//
//  Created by Jack Munkonge on 25/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import XCTest
@testable import Moneybox

class HttpModels: XCTestCase {
    
    let baseUrl = URL(string: "http://test.com")!
    let url = URL(string: "/test", relativeTo: baseUrl) else {
        XCTFail("Couldn't create absolute test URL")
    }
    
    let urlResponse = URLResponse(url: url, mimeType: <#T##String?#>, expectedContentLength: <#T##Int#>, textEncodingName: <#T##String?#>)
    let httpResponse = HttpResponse(fromURLResponse: <#T##URLResponse?#>)
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testExample() {
        
    }
}
