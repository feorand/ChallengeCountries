//
//  State.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 31.08.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation
import CoreData

class CoreDataState: NSManagedObject {
    
    class func getNextPageUrl(in context: NSManagedObjectContext) throws -> String {
        let fetchedSetting = try fetchNextPageUrl(in: context)
        return fetchedSetting.value!
    }
    
    class func setNextPageUrl(value: String, in context: NSManagedObjectContext) throws {
        let fetchedSetting = try fetchNextPageUrl(in: context)
        fetchedSetting.value = value
    }
    
    private class func fetchNextPageUrl(in context: NSManagedObjectContext) throws -> CoreDataState {
        let request: NSFetchRequest<CoreDataState> = CoreDataState.fetchRequest()
        request.predicate = NSPredicate(format: "key = %@", StorageSettings.nextPageUrlKey)
        
        do {
            let fetchedSettings = try context.fetch(request)
            if fetchedSettings.count > 0 {
                assert(fetchedSettings.count == 1, "StateData.fetchNextPageUrl produces multiple urls")
                return fetchedSettings.first!
            }
        } catch {
            throw error
        }
        
        let nextPageUrl = CoreDataState(context: context)
        nextPageUrl.key = StorageSettings.nextPageUrlKey
        nextPageUrl.value = ""
        return nextPageUrl
    }
}
