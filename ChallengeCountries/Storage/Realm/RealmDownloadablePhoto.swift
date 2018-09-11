//
//  RealmDownloadablePhoto.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 11.09.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class RealmDownloadablePhoto: Object {
    dynamic var url: String = ""
    dynamic var image: Data?
    
    override static func primaryKey() -> String? {
        return "url"
    }
    
    class func from(_ downloadablePhoto: DownloadablePhoto) -> RealmDownloadablePhoto {
        let realmPhoto = RealmDownloadablePhoto()
        realmPhoto.url = downloadablePhoto.url
        realmPhoto.image = downloadablePhoto.image
        return realmPhoto
    }
    
    class func photo (from realmDownloadablePhoto: RealmDownloadablePhoto) -> DownloadablePhoto {
        let photo = DownloadablePhoto(
            url: realmDownloadablePhoto.url,
            image: realmDownloadablePhoto.image
        )
        return photo
    }
}
