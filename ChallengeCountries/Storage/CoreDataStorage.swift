//
//  CoreDataStorage.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 04.09.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStorage {
    
    private var container: NSPersistentContainer?
    
    init(container: NSPersistentContainer? = AppDelegate.sharedPersistenseContainer!) {
        self.container = container
    }
    
    func store(_ nextPageUrl: String) {
        storeInBackground{ context in
            try StateData.setNextPageUrl(value: nextPageUrl, in: context)
        }

    }
    
    func store(_ countries: [Country]) {
        storeInBackground{ context in
            for country in countries {
                try CountryData.insertIfAbsent(country, in: context)
            }
            
            if countries.isEmpty {
                self.clear()
            }
        }
    }
    
    func store(_ photo: DownloadablePhoto) {
        storeInBackground { context in
            try DownloadablePhotoData.update(photo, in: context)
        }
    }
    
    func widthrawNextPageUrl() -> String {
        if let context = container?.viewContext {
            let nextPageUrl = try? StateData.getNextPageUrl(in: context)
            return nextPageUrl ?? ""
        }
        
        return ""
    }
    
    func widthrawCountries() -> [Country] {
        let countriesDatas = widthrawInViewContext(handler: CountryData.fetchAll) ?? []
        let countries = countriesDatas.map{ Country(from: $0) }
        return countries
    }
    
    func numberOfCountries() -> Int {
        let possibleCount = widthrawInViewContext(handler: CountryData.numberOfCountries)
        return possibleCount ?? 0
    }
    
    private func clear() {
        storeInBackground{ context in
            try CountryData.clear(in: context)
        }
    }
    
    private func widthrawInViewContext<T>(handler: @escaping (NSManagedObjectContext) throws ->(T)) -> T? {
        if let context = container?.viewContext {
            //TODO: Actual error handling
            let result = try? handler(context)
            return result ?? nil
        }
        
        return nil
    }
    
    private func storeInBackground(handler: @escaping (NSManagedObjectContext) throws ->()) {
        container?.performBackgroundTask { context in
            //TODO: Actual error handling
            try? handler(context)
            try? context.save()
        }
    }
}
