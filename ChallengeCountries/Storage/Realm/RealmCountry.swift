//
//  RealmCountry.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 11.09.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation
import RealmSwift

class RealmCountry: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var continent: String = ""
    @objc dynamic var capital: String = ""
    @objc dynamic var population: Int = 0
    @objc dynamic var countryDescriptionSmall: String = ""
    @objc dynamic var countryDescription: String = ""
    
    @objc dynamic var flag = RealmDownloadablePhoto()
    let photos = List<RealmDownloadablePhoto>()
}
