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
    let descriptionSmall: String
    let description: String
    let flagUrl: String
    
    private let photosUrls: [String]?
    
    init(name: String, continent: String, capital: String, population: Int, descriptionSmall: String, description: String, flagUrl: String, photosUrls: [String]?) {
        self.name = name
        self.continent = continent
        self.capital = capital
        self.population = population
        self.descriptionSmall = descriptionSmall
        self.description = description
        self.flagUrl = flagUrl
        self.photosUrls = photosUrls
    }
    
    var infoPhotosUrls: [String] {
        return photosUrls ?? [flagUrl]
    }
}
