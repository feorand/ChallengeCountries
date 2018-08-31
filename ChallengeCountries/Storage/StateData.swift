//
//  State.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 31.08.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation
import CoreData

class StateData: NSManagedObject {
    
    class func getNextPageUrl(in context: NSManagedObjectContext) throws -> String {
        let fetchedSetting = try fetchNextPageUrl(in: context)
        return fetchedSetting.value! // core data glitch
    }
    
    class func setNextPageUrl(value: String, in context: NSManagedObjectContext) throws {
        let fetchedSetting = try fetchNextPageUrl(in: context)
        fetchedSetting.value = value
    }
    
    private class func fetchNextPageUrl(in context: NSManagedObjectContext) throws -> StateData {
        let request: NSFetchRequest<StateData> = StateData.fetchRequest()
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
        
        let nextPageUrl = StateData(context: context)
        nextPageUrl.key = StorageSettings.nextPageUrlKey
        nextPageUrl.value = ""
        return nextPageUrl
    }
}
