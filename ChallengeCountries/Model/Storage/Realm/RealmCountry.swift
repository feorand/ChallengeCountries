//
//  RealmCountry.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 11.09.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class RealmCountry: Object {
    dynamic var name: String = ""
    dynamic var continent: String = ""
    dynamic var capital: String = ""
    dynamic var population: Int = 0
    dynamic var countryDescriptionSmall: String = ""
    dynamic var countryDescription: String = ""
    
    dynamic var flag:RealmDownloadablePhoto? = RealmDownloadablePhoto()
    let photos = List<RealmDownloadablePhoto>()
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
    convenience init(from country: Country) {
        self.init()
        name = country.name
        continent = country.continent
        capital = country.capital
        population = country.population
        countryDescription = country.countryDescription
        countryDescriptionSmall = country.countryDescriptionSmall
        flag = RealmDownloadablePhoto(from: country.flag)
        photos.append(objectsIn: country.photos.map(RealmDownloadablePhoto.init(from:)))
    }
}
