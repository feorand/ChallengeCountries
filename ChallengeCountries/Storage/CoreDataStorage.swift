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
        container?.performBackgroundTask{ context in
            //TODO: Actual error handling
            
            try? StateData.setNextPageUrl(value: nextPageUrl, in: context)
            try? context.save()
        }
    }
    
    func store(_ countries: [Country]) {
        container?.performBackgroundTask{ context in
            //TODO: Actual error handling
            
            for country in countries {
                try? CountryData.insertIfAbsent(country, in: context)
            }
            
            try? context.save()
        }
    }
    
    func store(_ photo: DownloadablePhoto) {
        container?.performBackgroundTask{ context in
            //TODO: Actual error handling
            
            try? DownloadablePhotoData.update(photo, in: context)
            try? context.save()
        }
    }
}
