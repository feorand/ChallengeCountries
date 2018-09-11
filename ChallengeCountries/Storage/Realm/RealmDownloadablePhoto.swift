//
//  RealmDownloadablePhoto.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 11.09.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDownloadablePhoto: Object {
    @objc dynamic var url: String = ""
    @objc dynamic var image: Data?
}
