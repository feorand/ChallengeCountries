//
//  CoreDataStorage.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 04.09.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStorage: Storage {
    
    private var container: NSPersistentContainer?
    
    required init(container: NSPersistentContainer? = StorageSettings.container) {
        self.container = container
    }
    
    func store(_ nextPageUrl: String) {
        storeInBackground{ context in
            try CoreDataState.setNextPageUrl(value: nextPageUrl, in: context)
        }
    }
    
    func store(_ countries: [Country]) {
        storeInBackground{ context in
            for country in countries {
                try CoreDataCountry.insertIfAbsent(country, in: context)
            }
            print("After inserting: \(try! CoreDataCountry.numberOfCountries(in: context)) countries")
        }
    }
    
    func store(_ photo: DownloadablePhoto) {
        storeInBackground { context in
            try CoreDataDownloadablePhoto.update(photo, in: context)
        }
    }
    
    func widthrawNextPageUrl() -> String? {
        if let context = container?.viewContext {
            let nextPageUrl = try? CoreDataState.getNextPageUrl(in: context)
            return nextPageUrl
        }
        
        return nil
    }
    
    func widthrawCountries() -> [Country] {
        let countriesDatas = widthrawInViewContext(handler: CoreDataCountry.fetchAll) ?? []
        let countries = countriesDatas.map{ Country(from: $0) }
        return countries
    }
    
    func clear() {
        storeInBackground{ context in
            try CoreDataCountry.clear(in: context)
            print("After clear: \(try! CoreDataCountry.numberOfCountries(in: context)) countries")
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
