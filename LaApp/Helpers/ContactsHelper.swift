//
//  ContactsHelper.swift
//  LaApp
//
//  Created by Miyo Alpízar on 2/2/19.
//  Copyright © 2019 Efrain Emigdio Navarrete Alpízar. All rights reserved.
//

import Contacts
import PromiseKit

protocol ContactsDelegate:class {
    func addressBookChanged()
}

class ContactsHelper {
    
    private static let _shared = ContactsHelper()
    weak var delegate: ContactsDelegate?
    
    static var shared: ContactsHelper {
        return _shared
    }
    
    private let contactsStore = CNContactStore()
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(onAddressBookchanged), name: NSNotification.Name.CNContactStoreDidChange, object: nil)
    }
    
    func getContacts() -> Promise<[Contact]> {
        return Promise { seal in
            contactsStore.requestAccess(for: CNEntityType.contacts) { (success, error) in
                if let error = error {
                    seal.reject(error)
                }else if success {
                    
                    let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey ,CNContactPhoneNumbersKey, CNContactImageDataKey] as [CNKeyDescriptor]
                    let request = CNContactFetchRequest(keysToFetch: keys)
                    do {
                        var contacts = [Contact]()
                        try self.contactsStore.enumerateContacts(with: request, usingBlock: { (contact, pointerStop) in
                            var numbers = [String]()
                            var emails = [String]()
                            
                            contact.emailAddresses.forEach({ (email) in
                                emails.append(email.value.description)
                            })
                            
                            contact.phoneNumbers.forEach({ (number) in
                                numbers.append(number.value.stringValue)
                            })
                            contacts.append(Contact(firstName: contact.givenName.trim(), lastName: contact.familyName.trim(), emails: emails, numbers: numbers, image: contact.imageData))
                        })
                        seal.fulfill(contacts)
                    }catch let error {
                        seal.reject(error)
                    }
                }
            }
        }
        
    }
    
    func groupContacts(contacts: [Contact]) -> [[Contact]] {
        return contacts
            .sorted(by: {$0.fullName < $1.fullName})
            .group(by: {$0.type } )
            .sorted(by: {$0[0].type.rawValue < $1[0].type.rawValue})
    }
    
   
    
}

//MARK: - Private Functions
extension ContactsHelper {
    
    @objc private func onAddressBookchanged() {
        guard let delegate = delegate else {
            return
        }
        delegate.addressBookChanged()
    }
    
}
