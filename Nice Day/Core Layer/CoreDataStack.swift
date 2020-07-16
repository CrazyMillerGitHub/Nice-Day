//
//  CoreDataStack.swift
//  Nice Day
//
//  Created by Михаил Борисов on 21.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import CoreData
import Firebase

final class CoreDataManager {

    private init() {}
    static var shared = CoreDataStack()
}

final class CoreDataStack {

    internal enum Contexts {
        case main, `private`
    }

    internal enum MoodType: String {

        case neutral, good, bad

    }

    internal enum CoreDataErrorHandler: Error {

        case fetchDataError

        var localizedDescription: String {
            switch self {
            case .fetchDataError:
                return "Fetching data finished with error"
            }
        }
    }

    internal func context(on context: Contexts) -> NSManagedObjectContext {
        switch context {
        case .main:
            return mainContext
        case .private:
            return backgroundContext
        }
    }

    private lazy var backgroundContext: NSManagedObjectContext = persistentContainer.newBackgroundContext()

    private lazy var mainContext: NSManagedObjectContext = persistentContainer.viewContext

    private lazy var persistentContainer = NSPersistentContainer(name: "Nice_Day").with { container in
        container.loadPersistentStores { (_, err) in
            if let err = err {
                print(err.localizedDescription)
            }
        }
    }

    internal func saveContext(backgroundContext: NSManagedObjectContext? = nil) {

        let context = backgroundContext ?? persistentContainer.viewContext

            guard context.hasChanges else { return }
                context.perform {
                do {
                    try context.save()
                } catch(let err) {
                    print(err.localizedDescription)
                }
            }

    }

    internal func deleteData<T: NSManagedObject>(on model: T.Type, context: NSManagedObjectContext) {

        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: model))

        let fetchRequest: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try self.backgroundContext.execute(fetchRequest)
            // saveContext
            saveContext(backgroundContext: context)
        } catch let error {
            print(error.localizedDescription)
        }

    }

    internal func fetchData<T: NSManagedObject>(name: T.Type, context: NSManagedObjectContext,
                                                completion: @escaping (Result<[T], CoreDataErrorHandler>) -> Void) {
        let request = name.fetchRequest()

        do {
            guard let results = try context.fetch(request) as? [T] else {
                completion(.failure(.fetchDataError))
                return
            }
            completion(.success(results))
        } catch(let err) {
            print(err.localizedDescription)
        }
    }

    internal func createOrUpdateUser(context: NSManagedObjectContext,
                                     info: (firstName: String, lastName: String)) {

        fetchData(name: User.self, context: context) { result in

            if case let .success(users) = result {
                var currentUser: User
                switch users.first {
                case .some(let user):
                    currentUser = user
                case .none:
                    currentUser = User(context: context)
                }
                currentUser.firstName = info.firstName
                currentUser.lastName = info.lastName
                self.saveContext(backgroundContext: context)
            }
        }
    }

    internal func updateMood(on context: NSManagedObjectContext, moodType: MoodType) {

        fetchData(name: User.self, context: context) { (result) in
            if case let.success(users) = result, let user = users.first {
                let mood = Mood(context: context)
                mood.name = moodType.rawValue
                mood.count = 1
                user.addToMoods(mood)
                self.saveContext(backgroundContext: context)
            }
        }
    }

}
