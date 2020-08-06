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
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let err = err {
                print(err.localizedDescription)
            }
        }
    }

    internal func saveContext(backgroundContext: NSManagedObjectContext? = nil) {

        let context = backgroundContext ?? persistentContainer.viewContext

        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch(let err) {
            print(err.localizedDescription)
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

    internal func fetchData<T: NSManagedObject>(name: T.Type, context: NSManagedObjectContext) -> [T]? {
        do {
            guard let results = try context.fetch(name.fetchRequest()) as? [T] else {
                return nil
            }
            return results
        } catch(let err) {
//            Helper.shared.debugPrint(err)
           return nil
        }
    }

    internal func currentUser(_ context: NSManagedObjectContext) -> User {

        guard let users = fetchData(name: User.self, context: context), let user = users.first else {
            let user = createOrUpdateUser(context: context, info: (firstName: "", lastName: ""))
            return user
        }

        return user
    }

    @discardableResult internal func createOrUpdateUser(context: NSManagedObjectContext,
                                                        info: (firstName: String, lastName: String)?) -> User {

        var currentUser: User

        if let user = fetchData(name: User.self, context: context)?.first {
            currentUser = user
        } else {
            currentUser = User(context: context)
            context.performAndWait {
                createEmptryMoods(on: context, user: currentUser)
            }
        }
        currentUser.firstName = info?.firstName
        currentUser.lastName = info?.lastName
        saveContext(backgroundContext: context)

        return currentUser
    }

    internal func createEmptryMoods(on context: NSManagedObjectContext, user: User) {

        let goodMood = Mood(context: context)
        let badMood = Mood(context: context)
        let neutralMood = Mood(context: context)

        goodMood.name = MoodType.good.rawValue
        goodMood.count = 0

        user.addToMoods(goodMood)

        badMood.name = MoodType.bad.rawValue
        badMood.count = 0

        user.addToMoods(badMood)

        neutralMood.name = MoodType.neutral.rawValue
        neutralMood.count = 0

        user.addToMoods(neutralMood)

    }

    private func fetchEmptyMood(on context: NSManagedObjectContext, name: String, user: User) -> Mood {
        let mood = Mood(context: context)
        mood.name = name
        mood.count = 0
        return mood
    }

    internal func insertActivity(on context: NSManagedObjectContext, activity: [String: Any]) {
        guard let cost = activity["cost"] as? Int,
            let total = activity["total"] as? Int,
            let timeStart = (activity["timeStart"] as? Timestamp)?.dateValue(),
            let timeEnd = (activity["timeEnd"] as? Timestamp)?.dateValue() else {
//                Helper.shared.debugPrint("!Error saving to coredata!")
                return
        }

        let usage = Usage(context: context)
        usage.endTime = timeEnd
        usage.startTime = timeStart
        usage.total = Int32(total)
        usage.cost = Int16(cost)

        let user = currentUser(context)
        user.addToUsages(usage)
        saveContext(backgroundContext: context)
    }

    internal func fetchActivityForLast7Days(on context: NSManagedObjectContext) -> [Double: [Usage]]? {

        let request: NSFetchRequest<Usage> = Usage.fetchRequest()
        let startTime = NSDate()
        guard let sevenDaysAgo = NSCalendar.current.date(byAdding: .day, value: -7, to: Date()) else { return nil }
        let endTime = NSCalendar.current.startOfDay(for: sevenDaysAgo) as NSDate
        request.predicate = NSPredicate(format:"(endTime >= %@) AND (endTime < %@)", endTime, startTime)

        do {
            let items = try context.fetch(request)
            let dict = Dictionary(grouping: items) { (element) -> Double in
                return Double(Calendar.current.component(.weekday, from: element.endTime!)) + 10
                    * (Double(Calendar.current.component(.year, from: element.endTime!)) - 2019)
                    * (Double(Calendar.current.component(.weekOfYear, from: element.endTime!)))
            }
            return dict
        } catch(let err) {
//            Helper.shared.debugPrint(err.localizedDescription)
            return nil
        }
    }

    internal func incrementMood(on context: NSManagedObjectContext, with moodType: MoodType) {
        let user = currentUser(context)
        if let moods = user.moods?.allObjects as? [Mood] {
            if let mood = moods.first(where: { mood -> Bool in mood.name == moodType.rawValue }) {
                mood.count += 1
                saveContext(backgroundContext: context)
            }
        }
    }
}
