//
//  ErrorExtentions.swift
//  LaApp
//
//  Created by Miyo Alpízar on 2/3/19.
//  Copyright © 2019 Efrain Emigdio Navarrete Alpízar. All rights reserved.
//

import Foundation

enum LocalError {
    case localError(message: String)
}

enum AuthErrors: Error {
    case invalidUserPassword
}

extension LocalError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .localError(let message):
            return message
        }
    }
}
