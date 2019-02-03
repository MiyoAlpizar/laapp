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
    let emails: [String]
    let numbers: [String]
    let image: Data?
    var description: String
    
    init(firstName: String, lastName: String,emails: [String], numbers: [String], image: Data?) {
        self.firstName = firstName
        self.lastName = lastName
        self.numbers = numbers
        self.image = image
        self.emails = emails
        self.description = ""
        self.setComputedProperties()
    }
    
    //MARK:- Computed Read Only Properties
    var fullName: String {
        get {
            let name = "\(firstName.trim()) \(lastName.trim())"
            return name.trim().isEmpty ? "Sin nombre" : name
        }
    }
    var hasName: Bool {
        return !firstName.trim().isEmpty || !lastName.trim().isEmpty
    }
    var hasNumber: Bool {
        return !firstNumber.trim().isEmpty
    }
    
    
    private var _firstNumber = ""
    var firstNumber: String {
        get {
            return _firstNumber
        }
    }
    
    private var _initials = ""
    var initials: String {
        get {
            return _initials
        }
    }
    
    private var _thenPhoneNumber = ""
    var tenPhoneNumber: String {
        return _thenPhoneNumber
    }
    
    private var _type: ContactType = .inApp
    var type: ContactType {
        return _type
    }
    
    
    private mutating func setComputedProperties() {
        if let number = numbers.first {
            _firstNumber = number
        }
        let letters = "\(firstName.prefix(1).uppercased())\(lastName.prefix(1).uppercased())"
        _initials = letters.trim().isEmpty ? "?" : letters
        
        let digits = firstNumber.digits
        if (digits.count == 10) {
            _thenPhoneNumber = digits
        }else if digits.count > 10 {
            _thenPhoneNumber = digits.suffix(10).description
        }else {
            _thenPhoneNumber = digits
        }
        
        if hasName && hasNumber {
            _type = .notIntApp
        }else if hasName && !hasNumber {
            _type = .noNumber
        }else if hasNumber && !hasName {
            _type = .noName
        }else {
            _type = .inApp
        }
        
    }
    
    func toContactProfile() -> [ContactProfileGroup] {
        var profile = [ContactProfileGroup]()
        
        profile.append(ContactProfileGroup(type: ContactProfileType.contact, data: self))
        
        profile.append(ContactProfileGroup(type: ContactProfileType.phones, data: numbers))
        
        if emails.count > 0 {
            profile.append(ContactProfileGroup(type: ContactProfileType.emails, data: emails))
        }
        
        let action = type == .inApp ? "Actualizar datos": numbers.count > 1 ? "Registrar números" : "Registrar número"
        
        profile.append(ContactProfileGroup(type: .description, data: description))
        
        profile.append(ContactProfileGroup(type: .save, data: action))
        
        return profile
    }
    
}

enum ContactType: Int {
    case inApp = 0, notIntApp = 2, noName = 3,  noNumber = 4
}

