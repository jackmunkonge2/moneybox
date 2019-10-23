//
//  CustomError.swift
//  Moneybox
//
//  Created by Jack Munkonge on 23/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import Foundation

enum CustomError: LocalizedError {
    case failedToCreateRequest
}

extension CustomError {
    public var localizedDescription: String {
        switch self {
            case .failedToCreateRequest: return NSLocalizedString("Unable to create the URLRequest object", comment: "")
        }
    }
}
