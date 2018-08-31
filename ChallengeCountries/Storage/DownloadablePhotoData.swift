//
//  DownloadablePhotoData.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 31.08.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation
import CoreData

class DownloadablePhotoData: NSManagedObject {
    class func from(photo: DownloadablePhoto, in context: NSManagedObjectContext) -> DownloadablePhotoData {
        let photoData = DownloadablePhotoData(context: context)
        photoData.url = photo.url
        photoData.image = photo.image
        
        return photoData
    }
}
