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
    
    
    //MARK:- Read Only properties
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
    
    
}
