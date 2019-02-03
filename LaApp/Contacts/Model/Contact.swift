//
//  Contact.swift
//  LaApp
//
//  Created by Miyo Alpízar on 2/2/19.
//  Copyright © 2019 Efrain Emigdio Navarrete Alpízar. All rights reserved.
//

import Foundation

struct Contact {
    let firstName: String
    let lastName: String
    let numbers: [String]
    let image: Data?
    
    
    //MARK:- Computed Read Only properties
    var fullName: String {
        get {
            return "\(firstName) \(lastName)"
        }
    }
    
    var firstNumber: String {
        get {
            if let number = numbers.first {
                return number
            }
            return ""
        }
    }
    
    var initials: String {
        get {
            return "\(firstName.prefix(1).uppercased())\(lastName.prefix(1).uppercased())"
        }
    }
    
    var hasName: Bool {
        return !fullName.trim().isEmpty
    }
    
    var tenPhoneNumber: String {
        let digits = firstNumber.digits
        if (digits.count == 10) {
            return digits
        }else if digits.count > 10 {
            return digits.suffix(10).description
        }
        return digits
    }
    
    
}
