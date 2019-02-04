//
//  ContactTests.swift
//  LaAppTests
//
//  Created by Miyo Alpízar on 2/4/19.
//  Copyright © 2019 Efrain Emigdio Navarrete Alpízar. All rights reserved.
//

import Foundation
import XCTest
@testable import LaApp
@testable import PromiseKit

class ContactTests: XCTestCase {
    
    func testAddContact() {
        var currentNumberOfContacts = 10
        var newNumberOfContacts = 0
        let contactID = "test01"
        var contactToTest: EContact?
        let expetation = self.expectation(description: "Save Contact")
        
        CoreHelper.shared.fetch(EContact.self)
        .then({ contacts -> Promise<EContact> in
            currentNumberOfContacts = contacts.count
            print("currentNumberOfContacts: ",currentNumberOfContacts)
            return EContact.addUpdateContact(id: contactID, desc: "this is a test")
        }).then({ contact -> Promise<[EContact]> in
            contactToTest = contact
            return CoreHelper.shared.fetch(EContact.self)
        }).done { (contacts) in
            newNumberOfContacts = contacts.count
            print("newNumberOfContacts: ",newNumberOfContacts)
        }.catch { (error) in
            print(error.localizedDescription)
        }.finally {
            if let contact = contactToTest {
                contact.deleteSilentContact()
            }
            expetation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(currentNumberOfContacts + 1 == newNumberOfContacts)
        
    }
    
    
    
}
