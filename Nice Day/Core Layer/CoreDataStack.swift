//
//  CoreDataStack.swift
//  Nice Day
//
//  Created by Михаил Борисов on 21.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import CoreData

class CoreDataStack: NSObject {
    var storeURL: URL {
           guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
               fatalError(#function)
           }
           return documentsUrl.appendingPathComponent("MyStore.sqlite")
       }
    weak var delegate: CoreDataManager?
    
    let dataModelName = "Nice_Day"
    
    let dataModelExtension = "momd"
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.dataModelName, withExtension: self.dataModelExtension) else { fatalError("Error when trying to find Core Data file") }
        guard let object = NSManagedObjectModel(contentsOf: modelURL) else { fatalError("object is nill") }
        return object
    }()
    
     lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
           let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
           do {
               try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeURL, options: nil)
           } catch {
               assert(false, "Error adding store: \(error)")
           }
           return coordinator
       }()
    
    lazy var masterContext: NSManagedObjectContext = {
         var masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
         masterContext.persistentStoreCoordinator = self.persistentStoreCoordinator
         masterContext.mergePolicy = NSOverwriteMergePolicy
         return masterContext
     }()
     
     lazy var mainContext: NSManagedObjectContext = {
         var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
         mainContext.parent = self.masterContext
         mainContext.mergePolicy = NSOverwriteMergePolicy
         return mainContext
     }()
     
     lazy var saveContext: NSManagedObjectContext = {
         var mainContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
         mainContext.parent = self.mainContext
         mainContext.mergePolicy = NSOverwriteMergePolicy
         return mainContext
     }()
    
    func performSave() {
        saveContext.performAndWait {
            do {
                try self.saveContext.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            mainContext.performAndWait {
                do {
                    try self.mainContext.save()
                    self.masterContext.performAndWait {
                        do {
                            try self.masterContext.save()
                        } catch {
                            fatalError("Failure to save context: \(error)")
                        }
                    }
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
        }
    }
}
