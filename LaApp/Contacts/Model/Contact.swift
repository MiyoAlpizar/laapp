//
//  Contact.swift
//  LaApp
//
//  Created by Miyo Alpízar on 2/2/19.
//  Copyright © 2019 Efrain Emigdio Navarrete Alpízar. All rights reserved.
//

import Foundation

struct Contact {
    let id: String
    let firstName: String
    let lastName: String
    let emails: [String]
    let numbers: [String]
    let image: Data?
    var detail: String
    var type: ContactType
    
    init(id: String,firstName: String, lastName: String,emails: [String], numbers: [String], image: Data?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.numbers = numbers
        self.image = image
        self.emails = emails
        self.detail = ""
        self.type = .notIntApp
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
            type = .notIntApp
        }else if hasName && !hasNumber {
            type = .noNumber
        }else if hasNumber && !hasName {
            type = .noName
        }else {
            type = .inApp
        }
        
    }
    
    /**
     Convert a Contact to a group to display in a TableView
     - Returns:
     Array of ContactProfileGroup
     */
    func toContactProfile() -> [ContactProfileGroup] {
        var profile = [ContactProfileGroup]()
        
        profile.append(ContactProfileGroup(title: nil, type: ContactProfileType.contact, data: nil))
        
        profile.append(ContactProfileGroup(title: numbers.count > 1 ? "TELÉFONOS" : "TELÉFONO", type: ContactProfileType.phones, data: numbers))
        
        if emails.count > 0 {
            profile.append(ContactProfileGroup(title: emails.count > 1 ? "EMAILS" : "EMAIL", type: ContactProfileType.emails, data: emails))
        }
        
        let action = type == .inApp ? "Actualizar datos": numbers.count > 1 ? "Registrar números" : "Registrar número"
        
        profile.append(ContactProfileGroup(title: "DESCRIPCIÓN", type: .description, data: detail))
        
        profile.append(ContactProfileGroup(title: nil, type: .save, data: action))
        
        return profile
    }
    
}

enum ContactType: Int {
    case inApp = 0, notIntApp = 2, noName = 3,  noNumber = 4
}

