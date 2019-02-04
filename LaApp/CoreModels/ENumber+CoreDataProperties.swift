//
//  ENumber+CoreDataProperties.swift
//  LaApp
//
//  Created by Miyo Alpízar on 2/3/19.
//  Copyright © 2019 Efrain Emigdio Navarrete Alpízar. All rights reserved.
//
//

import Foundation
import CoreData
import PromiseKit

extension ENumber {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ENumber> {
        return NSFetchRequest<ENumber>(entityName: "ENumber")
    }

    @NSManaged public var number: String
    @NSManaged public var contact: EContact
    
    static func insertNewNumbers(numbers: [String], contact: EContact) -> Promise<Void> {
        return Promise { seal in
            var enumbers = Set<ENumber>()
            numbers.forEach({ (number) in
                let enumber = NSEntityDescription.insertNewObject(forEntityName: "ENumber", into: CoreHelper.shared.context) as! ENumber
                enumber.number = number
                enumber.contact = contact
                enumbers.insert(enumber)
            })
            
            CoreHelper.shared.save()
            .done { () in
                contact.addToNumbers(enumbers as NSSet)
                seal.fulfill()
            }.catch { (error) in
                seal.reject(error)
            }
        }
    }
    
    static func addUpdateNumbers(numbers: [String], contact: EContact) -> Promise<[String]> {
        return Promise { seal in
            var enumbers = Set<ENumber>()
            var numbersToSend = [String]()
            numbers.forEach({ (number) in
                let condition = CoreConditions(field: "number", value: number.digits)
                CoreHelper.shared.fetch(ENumber.self, conditions: [condition])
                .done({ (results) in
                    if let n = results.first {
                        n.number = number.digits
                        n.contact = contact
                        enumbers.insert(n)
                        
                    }else {
                        let enumber = NSEntityDescription.insertNewObject(forEntityName: "ENumber", into: CoreHelper.shared.context) as! ENumber
                        enumber.number = number.digits
                        enumber.contact = contact
                        enumbers.insert(enumber)
                    }
                    numbersToSend.append(number.digits)
                }).catch({ (error) in
                    seal.reject(error)
                })
            })
            
            CoreHelper.shared.save()
                .done { () in
                    contact.addToNumbers(enumbers as NSSet)
                    seal.fulfill(numbersToSend)
                }.catch { (error) in
                    seal.reject(error)
            }
        }
    }
    

}
