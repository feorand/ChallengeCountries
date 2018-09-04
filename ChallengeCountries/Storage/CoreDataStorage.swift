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
    
    private var fetchedResultController: NSFetchedResultsController<CountryData>?
    
    var delegate: NSFetchedResultsControllerDelegate? {
        didSet {
            fetchedResultController?.delegate = delegate
            try? fetchedResultController?.performFetch()
        }
    }

    init(container: NSPersistentContainer? = AppDelegate.sharedPersistenseContainer!) {
        self.container = container
        
        if let context = container?.viewContext {
            let request: NSFetchRequest<CountryData> = CountryData.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            
            fetchedResultController = NSFetchedResultsController<CountryData>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
        }
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
        }
    }
    
    func store(_ photo: DownloadablePhoto) {
        storeInBackground { context in
            try DownloadablePhotoData.update(photo, in: context)
        }
    }
    
    private func storeInBackground(handler: @escaping (NSManagedObjectContext) throws ->()) {
        container?.performBackgroundTask { context in
            //TODO: Actual error handling
            try? handler(context)
            try? context.save()
        }
    }
}
