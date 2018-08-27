//
//  Country.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 30.07.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

struct CountryCoderConstants {
    static let Name = "name"
    static let Continent = "continent"
    static let Capital = "capital"
    static let Population = "population"
    static let DescriptionSmall = "description_small"
    static let Description = "description"
    static let FlagURL = "flag_url"
    static let PhotosURLs = "photos_urls"
    static let Flag = "flag"
}

class Country: NSCoding {
    let name: String
    let continent: String
    let capital: String
    let population: Int
    let descriptionSmall: String
    let description: String
    let flagUrl: String
    let photosUrls: [String]

    // Stores actual downloaded flag image
    var flag: Data?
    
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
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: CountryCoderConstants.Name) as? String,
            let continent = aDecoder.decodeObject(forKey: CountryCoderConstants.Continent) as? String,
            let capital = aDecoder.decodeObject(forKey: CountryCoderConstants.Capital) as? String,
            let description = aDecoder.decodeObject(forKey: CountryCoderConstants.Description) as? String,
            let descriptionSmall = aDecoder.decodeObject(forKey: CountryCoderConstants.DescriptionSmall) as? String,
            let flagUrl = aDecoder.decodeObject(forKey: CountryCoderConstants.FlagURL) as? String,
            let photosUrls = aDecoder.decodeObject(forKey: CountryCoderConstants.PhotosURLs) as? [String] else {
            
            return nil
        }
        
        self.init(name: name,
                  continent: continent,
                  capital: capital,
                  population: aDecoder.decodeInteger(forKey: CountryCoderConstants.Population),
                  descriptionSmall: descriptionSmall,
                  description: description,
                  flagUrl: flagUrl,
                  photosUrls: photosUrls)
        
        self.flag = aDecoder.decodeObject(forKey: CountryCoderConstants.Flag) as? Data
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: CountryCoderConstants.Name)
        aCoder.encode(continent, forKey: CountryCoderConstants.Continent)
        aCoder.encode(capital, forKey: CountryCoderConstants.Capital)
        aCoder.encode(population, forKey: CountryCoderConstants.Population)
        aCoder.encode(description, forKey: CountryCoderConstants.Description)
        aCoder.encode(descriptionSmall, forKey: CountryCoderConstants.DescriptionSmall)
        aCoder.encode(flagUrl, forKey: CountryCoderConstants.FlagURL)
        aCoder.encode(photosUrls, forKey: CountryCoderConstants.PhotosURLs)
    }
}
