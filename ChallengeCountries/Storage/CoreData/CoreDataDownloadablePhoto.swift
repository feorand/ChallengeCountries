//
//  DownloadablePhotoData.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 31.08.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation
import CoreData

class CoreDataDownloadablePhoto: NSManagedObject {
    class func from(_ photo: DownloadablePhoto, in context: NSManagedObjectContext) -> CoreDataDownloadablePhoto {
        let photoData = CoreDataDownloadablePhoto(context: context)
        photoData.url = photo.url
        photoData.image = photo.image
        
        return photoData
    }
    
    class func update(_ photo: DownloadablePhoto, in context: NSManagedObjectContext) throws {
        guard let photoData = try fetchPhoto(url: photo.url, in: context) else { return }
        photoData.image = photo.image
    }
    
    private class func fetchPhoto(url: String, in context: NSManagedObjectContext) throws -> CoreDataDownloadablePhoto? {
        let request: NSFetchRequest<CoreDataDownloadablePhoto> = CoreDataDownloadablePhoto.fetchRequest()
        request.predicate = NSPredicate(format: "url = %@", url)
        
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                assert(result.count == 1, "DownloadablePhotoData.fetchPhoto - multiple photos with same url found")
                return result.first!
            }
        } catch {
            throw error
        }
        
        return nil
    }
}
