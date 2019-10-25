//
//  DecoderTests.swift
//  DecoderTests
//
//  Created by Jack Munkonge on 25/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import XCTest
@testable import Moneybox

class DecoderTests: XCTestCase {
    
    let standardErrorMessage = StandardErrorMessage("Test name", "Test message")
    
    private let standardPayload = Data("""
    {
      "Name" : "Test name",
      "Message" : "Test message",
      "ValidationErrors" : []
    }
    """.utf8)

    private let standardPayloadMissingName = Data("""
    {
      "Message" : "Test message",
      "ValidationErrors" : []
    }
    """.utf8)

    private let standardPayloadMissingMessage = Data("""
    {
      "Name" : "Test name",
      "ValidationErrors" : []
    }
    """.utf8)
    
    private let standardPayloadMissingValidationErrors = Data("""
    {
      "Name" : "Test name",
      "Message" : "Test message"
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
    
    private let validationPayloadMissingName = Data("""
    {
      "Message" : "Test message",
      "ValidationErrors" : [
        {
          "Name" : "Test error name",
          "Message" : "Test error message"
        }
      ]
    }
    """.utf8)
    
    private let validationPayloadMissingMessage = Data("""
    {
      "Name" : "Test name",
      "ValidationErrors" : [
        {
          "Name" : "Test error name",
          "Message" : "Test error message"
        }
      ]
    }
    """.utf8)
    
    private let loginPayload = Data("""
    {
      "Session" : {
          "BearerToken" : "AAAAAAAAAAAAAAAAAAAA"
      }
    }
    """.utf8)
    
    private let loginPayloadNoBearerToken = Data("""
    {
      "Session" : {
      }
    }
    """.utf8)
    
    private let loginPayloadNoSession = Data("""
    {
      "Foo" : "foo",
      "Bar" : "bar"
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
    
    private let investorPayloadNoTotalPlanValue = Data("""
    {
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
    
    private let investorPayloadNoProductResponses = Data("""
    {
      "TotalPlanValue" : 4444.44
    }
    """.utf8)
    
    private let investorPayloadNoProductId = Data("""
    {
      "TotalPlanValue" : 4444.44,
      "ProductResponses" : [{
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
    
    private let investorPayloadNoPlanValue = Data("""
    {
      "TotalPlanValue" : 4444.44,
      "ProductResponses" : [{
        "Id" : 1,
        "Moneybox" : 500,
        "Product" : {
          "Id" : 2,
          "Type" : "ISA",
          "FriendlyName" : "Test Name"
        }
      }]
    }
    """.utf8)
    
    private let investorPayloadNoMoneybox = Data("""
    {
      "TotalPlanValue" : 4444.44,
      "ProductResponses" : [{
        "Id" : 1,
        "PlanValue" : 999.00,
        "Product" : {
          "Id" : 2,
          "Type" : "ISA",
          "FriendlyName" : "Test Name"
        }
      }]
    }
    """.utf8)
    
    private let investorPayloadNoProduct = Data("""
    {
      "TotalPlanValue" : 4444.44,
      "ProductResponses" : [{
        "Id" : 1,
        "PlanValue" : 999.00,
        "Moneybox" : 500
      }]
    }
    """.utf8)
    
    private let investorPayloadNoMetaId = Data("""
    {
      "TotalPlanValue" : 4444.44,
      "ProductResponses" : [{
        "Id" : 1,
        "PlanValue" : 999.00,
        "Moneybox" : 500,
        "Product" : {
          "Type" : "ISA",
          "FriendlyName" : "Test Name"
        }
      }]
    }
    """.utf8)
    
    private let investorPayloadNoType = Data("""
    {
      "TotalPlanValue" : 4444.44,
      "ProductResponses" : [{
        "Id" : 1,
        "PlanValue" : 999.00,
        "Moneybox" : 500,
        "Product" : {
          "Id" : 2,
          "FriendlyName" : "Test Name"
        }
      }]
    }
    """.utf8)
    
    private let investorPayloadNoFriendlyName = Data("""
    {
      "TotalPlanValue" : 4444.44,
      "ProductResponses" : [{
        "Id" : 1,
        "PlanValue" : 999.00,
        "Moneybox" : 500,
        "Product" : {
          "Id" : 2,
          "Type" : "ISA"
        }
      }]
    }
    """.utf8)
    
    override func setUp() {
        super.setUp()
        
    }

    override func tearDown() {
        super.tearDown()
        
    }
    

    func testAny_whenMissingName_shouldThrow() {
        XCTAssertThrowsError(try JSONDecoder().decode(StandardErrorMessage.self, from: standardPayloadMissingName)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual("Name", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
        
        XCTAssertThrowsError(try JSONDecoder().decode(ValidationErrorMessage.self, from: validationPayloadMissingName)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual("Name", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
    }
    
    func testAny_whenMissingMessage_shouldThrow() {
        XCTAssertThrowsError(try JSONDecoder().decode(StandardErrorMessage.self, from: standardPayloadMissingMessage)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual("Message", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
        
        XCTAssertThrowsError(try JSONDecoder().decode(ValidationErrorMessage.self, from: validationPayloadMissingMessage)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual("Message", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
    }
    
    func testStandardError_init_isValid() {
        XCTAssertTrue(standardErrorMessage.validationErrors.isEmpty)
        XCTAssertNotNil(standardErrorMessage.name)
        XCTAssertNotNil(standardErrorMessage.message)
    }

    func testStandardError_whenMissingValidationErrors_shouldThrow() {
        XCTAssertThrowsError(try JSONDecoder().decode(StandardErrorMessage.self, from: standardPayloadMissingValidationErrors)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual("ValidationErrors", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
    }
    
    func testStandardError_whenContainsValidationErrors_shouldThrow() {
        XCTAssertThrowsError(try JSONDecoder().decode(StandardErrorMessage.self, from: validationPayload)) { error in
            if case .typeMismatch(let type, _)? = error as? DecodingError {
                XCTAssertTrue(type == String.self)
            } else {
                XCTFail("Expected '.typeMismatch' but got \(error)")
            }
        }
    }
    
    func testStandardError_whenValidationErrorsIsEmpty_isValid() {
        XCTAssertNoThrow(try JSONDecoder().decode(StandardErrorMessage.self, from: standardPayload))
    }
    
    func testValidationError_whenMissingValidationErrors_shouldThrow() {
        XCTAssertThrowsError(try JSONDecoder().decode(ValidationErrorMessage.self, from: standardPayloadMissingValidationErrors)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual("ValidationErrors", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
    }
    
    func testValidationError_whenContainsValidationErrors_isValid() {
        XCTAssertNoThrow(try JSONDecoder().decode(ValidationErrorMessage.self, from: validationPayload))
    }
    
    func testAuthError_whenMissingValidationErrors_shouldThrow() {
        XCTAssertThrowsError(try JSONDecoder().decode(AuthErrorMessage.self, from: standardPayloadMissingValidationErrors)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual("ValidationErrors", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
    }
    
    func testAuthError_whenContainsValidationErrors_shouldThrow() {
        XCTAssertThrowsError(try JSONDecoder().decode(AuthErrorMessage.self, from: validationPayload)) { error in
            if case .typeMismatch(let type, _)? = error as? DecodingError {
                XCTAssertTrue(type == String.self)
            } else {
                XCTFail("Expected '.typeMismatch' but got \(error)")
            }
        }
    }
    
    func testAuthError_whenValidationErrorsIsEmpty_isValid() {
        XCTAssertNoThrow(try JSONDecoder().decode(AuthErrorMessage.self, from: standardPayload))
    }
    
    func testLoginSuccess_whenContainsBearerToken_isValid() {
        XCTAssertNoThrow(try JSONDecoder().decode(LoginSuccess.self, from: loginPayload))
    }
    
    func testLoginSuccess_whenNoSession_shouldThrow() {
        XCTAssertThrowsError(try JSONDecoder().decode(LoginSuccess.self, from: loginPayloadNoSession)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual("Session", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
    }
    
    func testLoginSuccess_whenNoBearerToken_shouldThrow() {
        XCTAssertThrowsError(try JSONDecoder().decode(LoginSuccess.self, from: loginPayloadNoBearerToken)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual("BearerToken", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
    }
    
    func testInvestorProducts_isValid() {
        XCTAssertNoThrow(try JSONDecoder().decode(InvestorProducts.self, from: investorPayload))
    }
    
    func testInvestorProducts_whenNoTotalPlanValue_shouldThrow() {
        XCTAssertThrowsError(try JSONDecoder().decode(InvestorProducts.self, from: investorPayloadNoTotalPlanValue)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual("TotalPlanValue", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
    }
    
    func testInvestorProducts_whenNoProductResponses_shouldThrow() {
        XCTAssertThrowsError(try JSONDecoder().decode(InvestorProducts.self, from: investorPayloadNoProductResponses)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual("ProductResponses", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
    }
    
    func testInvestorProducts_whenNoProductId_shouldThrow() {
        XCTAssertThrowsError(try JSONDecoder().decode(InvestorProducts.self, from: investorPayloadNoProductId)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual("Id", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
    }
    
    func testInvestorProducts_whenNoPlanValue_shouldThrow() {
        XCTAssertThrowsError(try JSONDecoder().decode(InvestorProducts.self, from: investorPayloadNoPlanValue)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual("PlanValue", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
    }
    
    func testInvestorProducts_whenNoMoneybox_shouldThrow() {
        XCTAssertThrowsError(try JSONDecoder().decode(InvestorProducts.self, from: investorPayloadNoMoneybox)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual("Moneybox", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
    }
    
    func testInvestorProducts_whenNoProduct_shouldThrow() {
        XCTAssertThrowsError(try JSONDecoder().decode(InvestorProducts.self, from: investorPayloadNoProduct)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual("Product", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
    }

    func testInvestorProducts_whenNoMetaId_shouldThrow() {
        XCTAssertThrowsError(try JSONDecoder().decode(InvestorProducts.self, from: investorPayloadNoMetaId)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual("Id", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
    }
    
    func testInvestorProducts_whenNoType_shouldThrow() {
        XCTAssertThrowsError(try JSONDecoder().decode(InvestorProducts.self, from: investorPayloadNoType)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual("Type", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
    }
    
    func testInvestorProducts_whenNoFriendlyName_shouldThrow() {
        XCTAssertThrowsError(try JSONDecoder().decode(InvestorProducts.self, from: investorPayloadNoFriendlyName)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual("FriendlyName", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
    }
}
