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
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(onAddressBookchanged), name: NSNotification.Name.CNContactStoreDidChange, object: nil)
    }
    
    /**
     Gets The Contact List from the BookAddress and Searchs for the users in the App by their phones
     - Returns:
     A Promise whith Array of Contacts
     */
    func getContacts() -> Promise<[Contact]> {
        var bookContacts = [Contact]()
        return Promise { seal in
            getBookContacts()
                .then( { results -> Promise<[EContact]> in
                    bookContacts = results
                    return CoreHelper.shared.fetch(EContact.self)
                }).done({ (contacts) in
                    seal.fulfill(self.mergeContacts(bookContacts: bookContacts, appContacts: contacts))
                }).catch({ (error) in
                    seal.reject(error)
                })
        }
    }
    
    func fetchContacts() {
        CoreHelper.shared.fetch(EContact.self)
            .done { (contacts) in
                contacts.forEach({ (contact) in
                    print(contact.id)
                    print(contact.desc)
                    print(contact.getNumbers())
                })
            }.catch { (error) in
                print(error.localizedDescription)
        }
    }
    
    func fetchNumbers() {
        CoreHelper.shared.fetch(ENumber.self)
            .done { (numbers) in
                numbers.forEach({ (number) in
                    print(number.number)
                })
                
            }.catch { (error) in
                print(error.localizedDescription)
        }
    }
    
    /**
     Makes a group of Contacts by type and sorts
     - Parameters:
     - contacts: Array of contacts
     - Returns:
     - Bidimensional Contact Array
     */
    func groupContacts(contacts: [Contact]) -> [[Contact]] {
        return contacts
            .sorted(by: {$0.fullName < $1.fullName})
            .group(by: {$0.type } )
            .sorted(by: {$0[0].type.rawValue < $1[0].type.rawValue})
    }
    
    /**
    Saves the contact in the App
     - Parameters:
     - contact: type of Contact
     - Returns:
     - Promise Void
     */
    func saveContact(contact: Contact) -> Promise<Void> {
        return Promise { seal in
            UIApplication.shared.beginIgnoringInteractionEvents()
            EContact.addUpdateContact(id: contact.id, desc: contact.detail)
                .then({ econtact -> Promise<[String]> in
                    return ENumber.addUpdateNumbers(numbers: contact.numbers, contact: econtact)
                }).done {  (numbers) in
                    self.onAddressBookchanged()
                    seal.fulfill()
                }.catch {  (error) in
                    seal.reject(error)
                }.finally {
                    UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
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
    
    private func mergeContacts(bookContacts:[Contact], appContacts: [EContact]) -> [Contact] {
        var contacts = bookContacts
        for i in 0...contacts.count-1 {
            appContacts.forEach { (econtact) in
                if econtact.id == contacts[i].id {
                    contacts[i].detail = econtact.desc
                    contacts[i].numbers.forEach({ (number) in
                        econtact.getNumbers().forEach({ (enumber) in
                            if number.digits == enumber.digits {
                                contacts[i].type = .inApp
                                return
                            }
                        })
                    })
                    return
                }
            }
        }
        return contacts
    }
    
    private func getBookContacts() -> Promise<[Contact]> {
        return Promise { seal in
            contactsStore.requestAccess(for: CNEntityType.contacts) { (success, error) in
                if let error = error {
                    seal.reject(error)
                }else if success {
                    
                    let keys = [CNContactGivenNameKey, CNContactIdentifierKey , CNContactFamilyNameKey, CNContactEmailAddressesKey ,CNContactPhoneNumbersKey, CNContactImageDataKey] as [CNKeyDescriptor]
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
                            
                            contacts.append(Contact(id: contact.identifier, firstName: contact.givenName.trim(), lastName: contact.familyName.trim(), emails: emails, numbers: numbers, image: contact.imageData))
                        })
                        seal.fulfill(contacts)
                    }catch let error {
                        seal.reject(error)
                    }
                }else {
                    seal.reject(LocalError.localError(message: "Error al obtener contactos"))
                }
            }
        }
    }
    
}
