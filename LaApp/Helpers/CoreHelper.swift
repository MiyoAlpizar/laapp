//
//  CoreHelper.swift
//  LaApp
//
//  Created by Miyo Alpízar on 2/3/19.
//  Copyright © 2019 Efrain Emigdio Navarrete Alpízar. All rights reserved.
//

import Foundation
import CoreData
import PromiseKit

/**
 Struct to generate conditions on fetching
 - Parameters:
 - field: name of the column entity
 - value: value to compare
 */
struct CoreConditions {
    let field: String
    let value: String
}



class CoreHelper {
    
    private static let _shared = CoreHelper()
    static var shared: CoreHelper {
        return _shared
    }
    
    lazy var context = persistentContainer.viewContext
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LaApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func save() -> Promise<Void> {
        return Promise { seal in
            guard context.hasChanges else {
                seal.fulfill()
                return
            }
            do {
                try context.save()
                seal.fulfill()
            }catch let error {
                seal.reject(error)
            }
        }
    }
    
}

extension CoreHelper {
    
    /**
     Generic Function for fetching array of any kind of Entity
     - Parameters:
     - Type
     - Returns:
     Array of the entity
     */
    func fetch<T: NSManagedObject>(_ type: T.Type) -> Promise<[T]> {
        return Promise { seal in
            let enityName = String(describing: type)
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: enityName)
            do {
                let objects = try context.fetch(fetchRequest) as? [T]
                seal.fulfill(objects ?? [T]())
            }
            catch let error {
                seal.reject(error)
            }
        }
        
    }
    /**
     Generic Function for fetching array of any kind of Entity with conditions
     - Parameters:
     - Type: NSManagedObject
     - Conditions: Array of conditions
     - Returns:
     Array of the entity
     */
    func fetch<T: NSManagedObject>(_ type: T.Type, conditions: [CoreConditions]) -> Promise<[T]> {
        return Promise { seal in
            let enityName = String(describing: type)
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: enityName)
            var predicates = [NSPredicate]()
            conditions.forEach({ (condition) in
                let predicate = NSPredicate(format: "\(condition.field) == %@", condition.value)
                predicates.append(predicate)
            })
            if predicates.count > 0 {
                let computedPredicates = NSCompoundPredicate.init(type: .and, subpredicates: predicates)
                fetchRequest.predicate = computedPredicates
            }
            
            do {
                let objects = try context.fetch(fetchRequest) as? [T]
                seal.fulfill(objects ?? [T]())
            }
            catch let error {
                seal.reject(error)
            }
        }
    }
    
    func removeAll() {
        fetch(EContact.self)
            .done { (contacts) in
                contacts.forEach({ (contact) in
                    self.context.delete(contact)
                })
                self.saveContext()
            }.catch { (error) in
                print(error.localizedDescription)
        }
        fetch(ENumber.self)
            .done { (numbers) in
                numbers.forEach({ (number) in
                    self.context.delete(number)
                })
                self.saveContext()
            }.catch { (error) in
                print(error.localizedDescription)
        }
    }
    
}
