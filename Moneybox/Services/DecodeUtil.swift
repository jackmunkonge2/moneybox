//
//  DecodeUtil.swift
//  Moneybox
//
//  Created by Jack Munkonge on 25/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import Foundation

struct DecodeUtil {
    static func decodeLoginResults<T>(using results: HttpResults) -> T {
        let decoder = JSONDecoder()
        
        guard let response = results.response else { return StandardErrorMessage("No Response", "There was no response in the results") as! T }
        guard let data = results.data else { return StandardErrorMessage("No Data", "There was no data in the results") as! T }
        
        switch response.httpStatusCode {
        case 200:
            guard let loginSuccess = try? decoder.decode(LoginSuccess.self, from: data) else { break }
            return loginSuccess as! T
        case 400:
            guard let invalidCredentials = try? decoder.decode(ValidationErrorMessage.self, from: data) else { break }
            return invalidCredentials as! T
        case 401:
            guard let authTimeout = try? decoder.decode(AuthErrorMessage.self, from: data) else { break }
            return authTimeout as! T
        default:
            break
        }
        return StandardErrorMessage("Decoding Failure", "Could not decode login data") as! T
    }
    
    static func decodeInvestorResults<T>(using results: HttpResults) -> T {
        let decoder = JSONDecoder()
        
        guard let response = results.response else { return StandardErrorMessage("No Response", "There was no response in the results") as! T }
        guard let data = results.data else { return StandardErrorMessage("No Data", "There was no data in the results") as! T }
        
        switch response.httpStatusCode {
        case 200:
            guard let investorProductData = try? decoder.decode(InvestorProducts.self, from: data) else { break }
            return investorProductData as! T
        case 401:
            guard let authTimeout = try? decoder.decode(AuthErrorMessage.self, from: data) else { break }
            return authTimeout as! T
        default:
            break
        }
        return StandardErrorMessage("Decoding Failure", "Could not decode investor data") as! T
    }
    
    static func decodeMoneyboxResults<T>(using results: HttpResults) -> T {
        let decoder = JSONDecoder()
        
        guard let response = results.response else { return StandardErrorMessage("No Response", "There was no response in the results") as! T }
        guard let data = results.data else { return StandardErrorMessage("No Data", "There was no data in the results") as! T }
        
        switch response.httpStatusCode {
        case 200:
            guard let moneyboxData = try? decoder.decode(Moneybox.self, from: data) else { break }
            return moneyboxData as! T
        case 401:
            guard let authTimeout = try? decoder.decode(AuthErrorMessage.self, from: data) else { break }
            return authTimeout as! T
        default:
            break
        }
        return StandardErrorMessage("Decoding Failure", "Could not decode investor data") as! T
    }
}

