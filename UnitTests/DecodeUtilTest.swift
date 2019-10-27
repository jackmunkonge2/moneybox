//
//  DecodeUtilTest.swift
//  UnitTests
//
//  Created by Jack Munkonge on 27/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import Foundation

import XCTest
@testable import Moneybox

class DecodeUtilTest: XCTestCase {
    let url = URL(string: "http://test.com")!
    let data = Data()
    let error = CustomError.failedToCreateRequest
    
    let loginPayload = Data("""
    {
      "Session" : {
          "BearerToken" : "AAAAAAAAAAAAAAAAAAAA"
      }
    }
    """.utf8)
    
    private let validationPayload = Data("""
    {
      "Name" : "Test name",
      "Message" : "Test message",
      "ValidationErrors" : [
        {
          "Name" : "Test error name",
          "Message" : "Test error message"
        }
      ]
    }
    """.utf8)
    
    private let authPayload = Data("""
    {
      "Name" : "Auth name",
      "Message" : "Test auth message",
      "ValidationErrors" : []
    }
    """.utf8)
    
    private let investorPayload = Data("""
    {
      "TotalPlanValue" : 4444.44,
      "ProductResponses" : [{
        "Id" : 1,
        "PlanValue" : 999.00,
        "Moneybox" : 500,
        "Product" : {
          "Id" : 2,
          "Type" : "ISA",
          "FriendlyName" : "Test Name"
        }
      }]
    }
    """.utf8)
    
    private let moneyboxPayload = Data("""
    {
      "Moneybox": 500
    }
    """.utf8)
    
    var response: HTTPURLResponse?
    var httpResponse: HttpResponse?
    var httpResults: HttpResults?
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testDecodeLoginResults_withNoResponse_shouldReturn() {
        httpResults = HttpResults(withData: data, response: nil, error: error)
        
        let decoded: StandardErrorMessage = DecodeUtil.decodeLoginResults(using: httpResults!)
        
        XCTAssertEqual(decoded.name, "No Response")
        XCTAssertEqual(decoded.message, "There was no response in the results")
        XCTAssertTrue(decoded.validationErrors.isEmpty)
    }
    
    func testDecodeLoginResults_withNoData_shouldReturn() {
        response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        httpResponse = HttpResponse(fromURLResponse: response)
        httpResults = HttpResults(withData: nil, response: httpResponse, error: error)
        
        let decoded: StandardErrorMessage = DecodeUtil.decodeLoginResults(using: httpResults!)
        
        XCTAssertEqual(decoded.name, "No Data")
        XCTAssertEqual(decoded.message, "There was no data in the results")
        XCTAssertTrue(decoded.validationErrors.isEmpty)
    }
    
    func testDecodeLoginResults_withStatusCode200_shouldReturn() {
        
        response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        httpResponse = HttpResponse(fromURLResponse: response)
        httpResults = HttpResults(withData: loginPayload, response: httpResponse, error: error)
        
        let decoded: LoginSuccess = DecodeUtil.decodeLoginResults(using: httpResults!)
        
        XCTAssertEqual(decoded.session.bearerToken, "AAAAAAAAAAAAAAAAAAAA")
    }
    
    func testDecodeLoginResults_withStatusCode400_shouldReturn() {
        
        response = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)!
        httpResponse = HttpResponse(fromURLResponse: response)
        httpResults = HttpResults(withData: validationPayload, response: httpResponse, error: error)
        
        let decoded: ValidationErrorMessage = DecodeUtil.decodeLoginResults(using: httpResults!)
        
        XCTAssertEqual(decoded.name, "Test name")
        XCTAssertEqual(decoded.message, "Test message")
        XCTAssertEqual(decoded.validationErrors[0].name, "Test error name")
        XCTAssertEqual(decoded.validationErrors[0].message, "Test error message")
    }
    
    func testDecodeLoginResults_withStatusCode401_shouldReturn() {
        
        response = HTTPURLResponse(url: url, statusCode: 401, httpVersion: nil, headerFields: nil)!
        httpResponse = HttpResponse(fromURLResponse: response)
        httpResults = HttpResults(withData: authPayload, response: httpResponse, error: error)
        
        let decoded: AuthErrorMessage = DecodeUtil.decodeLoginResults(using: httpResults!)
        
        XCTAssertEqual(decoded.name, "Auth name")
        XCTAssertEqual(decoded.message, "Test auth message")
        XCTAssertTrue(decoded.validationErrors.isEmpty)
    }
    
    func testDecodeLoginResults_withStatusCode0_shouldReturn() {
        
        response = HTTPURLResponse(url: url, statusCode: 0, httpVersion: nil, headerFields: nil)!
        httpResponse = HttpResponse(fromURLResponse: response)
        httpResults = HttpResults(withData: loginPayload, response: httpResponse, error: error)
        
        let decoded: StandardErrorMessage = DecodeUtil.decodeLoginResults(using: httpResults!)
        
        XCTAssertEqual(decoded.name, "Decoding Failure")
        XCTAssertEqual(decoded.message, "Could not decode login data")
        XCTAssertTrue(decoded.validationErrors.isEmpty)
    }
    
    
    func testDecodeInvestorResults_withNoResponse_shouldReturn() {
        httpResults = HttpResults(withData: data, response: nil, error: error)
        
        let decoded: StandardErrorMessage = DecodeUtil.decodeInvestorResults(using: httpResults!)
        
        XCTAssertEqual(decoded.name, "No Response")
        XCTAssertEqual(decoded.message, "There was no response in the results")
        XCTAssertTrue(decoded.validationErrors.isEmpty)
    }
    
    func testDecodeInvestorResults_withNoData_shouldReturn() {
        response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        httpResponse = HttpResponse(fromURLResponse: response)
        httpResults = HttpResults(withData: nil, response: httpResponse, error: error)
        
        let decoded: StandardErrorMessage = DecodeUtil.decodeInvestorResults(using: httpResults!)
        
        XCTAssertEqual(decoded.name, "No Data")
        XCTAssertEqual(decoded.message, "There was no data in the results")
        XCTAssertTrue(decoded.validationErrors.isEmpty)
    }
    
    func testDecodeInvestorResults_withStatusCode200_shouldReturn() {
        
        response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        httpResponse = HttpResponse(fromURLResponse: response)
        httpResults = HttpResults(withData: investorPayload, response: httpResponse, error: error)
        
        let decoded: InvestorProducts = DecodeUtil.decodeInvestorResults(using: httpResults!)
        
        XCTAssertEqual(decoded.totalPlanValue, 4444.44)
        XCTAssertEqual(decoded.productResponses[0].id, 1)
        XCTAssertEqual(decoded.productResponses[0].planValue, 999.00)
        XCTAssertEqual(decoded.productResponses[0].moneybox, 500)
        XCTAssertEqual(decoded.productResponses[0].product.id, 2)
        XCTAssertEqual(decoded.productResponses[0].product.type, "ISA")
        XCTAssertEqual(decoded.productResponses[0].product.friendlyName, "Test Name")
    }
    
    func testDecodeInvestorResults_withStatusCode401_shouldReturn() {
        
        response = HTTPURLResponse(url: url, statusCode: 401, httpVersion: nil, headerFields: nil)!
        httpResponse = HttpResponse(fromURLResponse: response)
        httpResults = HttpResults(withData: authPayload, response: httpResponse, error: error)
        
        let decoded: AuthErrorMessage = DecodeUtil.decodeInvestorResults(using: httpResults!)
        
        XCTAssertEqual(decoded.name, "Auth name")
        XCTAssertEqual(decoded.message, "Test auth message")
        XCTAssertTrue(decoded.validationErrors.isEmpty)
    }
    
    func testDecodeInvestorResults_withStatusCode0_shouldReturn() {
        
        response = HTTPURLResponse(url: url, statusCode: 0, httpVersion: nil, headerFields: nil)!
        httpResponse = HttpResponse(fromURLResponse: response)
        httpResults = HttpResults(withData: investorPayload, response: httpResponse, error: error)
        
        let decoded: StandardErrorMessage = DecodeUtil.decodeInvestorResults(using: httpResults!)
        
        XCTAssertEqual(decoded.name, "Decoding Failure")
        XCTAssertEqual(decoded.message, "Could not decode investor data")
        XCTAssertTrue(decoded.validationErrors.isEmpty)
    }
    
    func testDecodeMoneyboxResults_withNoResponse_shouldReturn() {
        httpResults = HttpResults(withData: data, response: nil, error: error)
        
        let decoded: StandardErrorMessage = DecodeUtil.decodeMoneyboxResults(using: httpResults!)
        
        XCTAssertEqual(decoded.name, "No Response")
        XCTAssertEqual(decoded.message, "There was no response in the results")
        XCTAssertTrue(decoded.validationErrors.isEmpty)
    }
    
    func testDecodeMoneyboxResults_withNoData_shouldReturn() {
        response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        httpResponse = HttpResponse(fromURLResponse: response)
        httpResults = HttpResults(withData: nil, response: httpResponse, error: error)
        
        let decoded: StandardErrorMessage = DecodeUtil.decodeMoneyboxResults(using: httpResults!)
        
        XCTAssertEqual(decoded.name, "No Data")
        XCTAssertEqual(decoded.message, "There was no data in the results")
        XCTAssertTrue(decoded.validationErrors.isEmpty)
    }
    
    func testDecodeMoneyboxResults_withStatusCode200_shouldReturn() {
        
        response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        httpResponse = HttpResponse(fromURLResponse: response)
        httpResults = HttpResults(withData: moneyboxPayload, response: httpResponse, error: error)
        
        let decoded: Moneybox = DecodeUtil.decodeMoneyboxResults(using: httpResults!)
        
        XCTAssertEqual(decoded.moneybox, 500)
    }
    
    func testDecodeMoneyboxResults_withStatusCode401_shouldReturn() {
        
        response = HTTPURLResponse(url: url, statusCode: 401, httpVersion: nil, headerFields: nil)!
        httpResponse = HttpResponse(fromURLResponse: response)
        httpResults = HttpResults(withData: authPayload, response: httpResponse, error: error)
        
        let decoded: AuthErrorMessage = DecodeUtil.decodeMoneyboxResults(using: httpResults!)
        
        XCTAssertEqual(decoded.name, "Auth name")
        XCTAssertEqual(decoded.message, "Test auth message")
        XCTAssertTrue(decoded.validationErrors.isEmpty)
    }
    
    func testDecodeMoneyboxResults_withStatusCode0_shouldReturn() {
        
        response = HTTPURLResponse(url: url, statusCode: 0, httpVersion: nil, headerFields: nil)!
        httpResponse = HttpResponse(fromURLResponse: response)
        httpResults = HttpResults(withData: moneyboxPayload, response: httpResponse, error: error)
        
        let decoded: StandardErrorMessage = DecodeUtil.decodeMoneyboxResults(using: httpResults!)
        
        XCTAssertEqual(decoded.name, "Decoding Failure")
        XCTAssertEqual(decoded.message, "Could not decode investor data")
        XCTAssertTrue(decoded.validationErrors.isEmpty)
    }
}
