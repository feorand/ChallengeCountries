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
    let photosUrls: [String]

    // fields for storing actual downloaded images
    var flag: Data?
    var photos: [Data] = []
    
    init(name: String, continent: String, capital: String, population: Int, descriptionSmall: String, description: String, flagUrl: String, photosUrls: [String]) {
        self.name = name
        self.continent = continent
        self.capital = capital
        self.population = population
        self.description = description
        self.descriptionSmall = descriptionSmall
        self.flagUrl = flagUrl
        self.photosUrls = photosUrls
    }
}
