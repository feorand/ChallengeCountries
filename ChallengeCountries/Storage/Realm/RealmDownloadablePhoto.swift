//
//  RealmDownloadablePhoto.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 11.09.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

@objcMembers
class RealmDownloadablePhoto: Object {
    dynamic var url: String = ""
    dynamic var image: Data?
    
    override static func primaryKey() -> String? {
        return "url"
    }
    
    convenience init(from downloadablePhoto: DownloadablePhoto) {
        self.init()
        url = downloadablePhoto.url
        image = downloadablePhoto.image
    }
}
