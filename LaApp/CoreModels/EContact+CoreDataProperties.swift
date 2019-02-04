//
//  EContact+CoreDataProperties.swift
//  LaApp
//
//  Created by Miyo Alpízar on 2/3/19.
//  Copyright © 2019 Efrain Emigdio Navarrete Alpízar. All rights reserved.
//
//

import Foundation
import CoreData
import PromiseKit

extension EContact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EContact> {
        return NSFetchRequest<EContact>(entityName: "EContact")
    }

    @NSManaged public var id: String
    @NSManaged public var desc: String
    @NSManaged public var numbers: NSSet?

}

// MARK: Generated accessors for numbers
extension EContact {

    @objc(addNumbersObject:)
    @NSManaged public func addToNumbers(_ value: ENumber)

    @objc(removeNumbersObject:)
    @NSManaged public func removeFromNumbers(_ value: ENumber)

    @objc(addNumbers:)
    @NSManaged public func addToNumbers(_ values: NSSet)

    @objc(removeNumbers:)
    @NSManaged public func removeFromNumbers(_ values: NSSet)
    
    
    func deleteContact() -> Promise<Void> {
        return Promise { seal in
            self.numbers?.allObjects.forEach({ (number) in
                if let number = number as? ENumber {
                    CoreHelper.shared.context.delete(number)
                }
            })
            CoreHelper.shared.context.delete(self)
            CoreHelper.shared.save()
            .done({ () in
                print("Contact deleted")
                seal.fulfill()
            }).catch({ (error) in
                seal.reject(error)
            })
        }
    }
    
    func deleteSilentContact() {
        self.numbers?.allObjects.forEach({ (number) in
            if let number = number as? ENumber {
                CoreHelper.shared.context.delete(number)
            }
        })
        CoreHelper.shared.context.delete(self)
        CoreHelper.shared.save()
            .done({ () in
                print("Contact deleted")
            }).catch({ (error) in
                print("Error deleting contact: ",error.localizedDescription)
            })
    }
    
    static func addUpdateContact(id: String, desc: String) -> Promise<EContact> {
        return Promise { seal in
            var contactToSend: EContact!
            let condition = CoreConditions(field: "id", value: id)
            CoreHelper.shared.fetch(EContact.self, conditions: [condition])
            .then({contacts -> Promise<Void> in
                if let contacto = contacts.first {
                    contacto.desc = desc
                    contactToSend = contacto
                }else {
                    let contact = NSEntityDescription.insertNewObject(forEntityName: "EContact", into: CoreHelper.shared.context) as! EContact
                    contact.id = id
                    contact.desc = desc
                    contactToSend = contact
                }
                return CoreHelper.shared.save()
            }).done {
                seal.fulfill(contactToSend)
            }.catch({ (error) in
                seal.reject(error)
            })
        }
    }
    
    func getNumbers() -> [String] {
        var _numbers = [String]()
        numbers?.allObjects.forEach({ (number) in
            if let n = number as? ENumber {
                _numbers.append(n.number)
            }
        })
        return _numbers
    }

}
