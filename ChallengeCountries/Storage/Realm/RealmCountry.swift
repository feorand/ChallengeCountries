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
    
    class func from(_ country: Country) -> RealmCountry {
        let realmCountry = RealmCountry()
        realmCountry.name = country.name
        realmCountry.continent = country.continent
        realmCountry.capital = country.capital
        realmCountry.population = country.population
        realmCountry.countryDescription = country.countryDescription
        realmCountry.countryDescriptionSmall = country.countryDescriptionSmall
        realmCountry.flag = RealmDownloadablePhoto.from(country.flag)
        realmCountry.photos.append(objectsIn: country.photos.map(RealmDownloadablePhoto.from))
        return realmCountry
    }
    
    class func country(_ realmCountry: RealmCountry) -> Country {
        let flag = RealmDownloadablePhoto.photo(from: realmCountry.flag!)
        let photos = realmCountry.photos.map(RealmDownloadablePhoto.photo)
        let country = Country(
            name: realmCountry.name,
            continent: realmCountry.continent,
            capital: realmCountry.capital,
            population: realmCountry.population,
            descriptionSmall: realmCountry.countryDescriptionSmall,
            description: realmCountry.description,
            flag: flag,
            photos: Array(photos)
        )
        return country
    }
}
