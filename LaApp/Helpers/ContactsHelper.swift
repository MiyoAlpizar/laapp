//
//  ContactsHelper.swift
//  LaApp
//
//  Created by Miyo Alpízar on 2/2/19.
//  Copyright © 2019 Efrain Emigdio Navarrete Alpízar. All rights reserved.
//

import Contacts
import PromiseKit

class ContactsHelper {
    
    private static let _shared = ContactsHelper()
    
    static var shared: ContactsHelper {
        return _shared
    }
    
    private let contactsStore = CNContactStore()
    
    func getContacts() -> Promise<[Contact]> {
        return Promise { seal in
            contactsStore.requestAccess(for: CNEntityType.contacts) { (success, error) in
                if let error = error {
                    seal.reject(error)
                }else if success {
                    
                    let keys = [CNContactGivenNameKey, CNContactFamilyNameKey,CNContactPhoneNumbersKey, CNContactImageDataKey] as [CNKeyDescriptor]
                    let request = CNContactFetchRequest(keysToFetch: keys)
                    do {
                        var contacts = [Contact]()
                        try self.contactsStore.enumerateContacts(with: request, usingBlock: { (contact, pointerStop) in
                            var numbers = [String]()
                            
                            contact.phoneNumbers.forEach({ (number) in
                                numbers.append(number.value.stringValue)
                            })
                            contacts.append(Contact(firstName: contact.givenName, lastName: contact.familyName, numbers: numbers, image: contact.imageData))
                        })
                        seal.fulfill(contacts)
                    }catch let error {
                        seal.reject(error)
                    }
                }
            }
        }
        
    }
    
}
