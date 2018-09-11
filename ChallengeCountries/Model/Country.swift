//
//  Country.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 30.07.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

class Country {
    let name: String
    let continent: String
    let capital: String
    let population: Int
    let countryDescriptionSmall: String
    let countryDescription: String
    
    let flag: DownloadablePhoto
    let photos: [DownloadablePhoto]
    
    convenience init(name: String, continent: String, capital: String, population: Int, descriptionSmall: String, description: String, flagUrl: String, photosUrls: [String]) {
        let flag = DownloadablePhoto(url: flagUrl)
        let photos = photosUrls.map{ DownloadablePhoto(url: $0) }
        
        self.init(
            name: name,
            continent: continent,
            capital: capital,
            population: population,
            descriptionSmall: descriptionSmall,
            description: description,
            flag: flag,
            photos: photos
        )
    }
    
    init(name: String, continent: String, capital: String, population: Int, descriptionSmall: String, description: String, flag: DownloadablePhoto, photos: [DownloadablePhoto]) {
        self.name = name
        self.continent = continent
        self.capital = capital
        self.population = population
        self.countryDescription = description
        self.countryDescriptionSmall = descriptionSmall
        self.flag = flag
        self.photos = photos
    }
}
