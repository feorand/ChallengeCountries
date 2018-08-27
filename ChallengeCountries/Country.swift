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
    static let Photos = "photos"
    static let Flag = "flag"
}

class Country: NSObject, NSCoding {
    let name: String
    let continent: String
    let capital: String
    let population: Int
    let countryDescriptionSmall: String
    let countryDescription: String
    let flag: DownloadablePhoto
    let photos: [DownloadablePhoto]
    
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
    
    convenience init(name: String, continent: String, capital: String, population: Int, descriptionSmall: String, description: String, flagUrl: String, photosUrls: [String]) {
        
        self.init(name: name,
                  continent: continent,
                  capital: capital,
                  population: population,
                  descriptionSmall: descriptionSmall,
                  description: description,
                  flag: DownloadablePhoto(url: flagUrl),
                  photos: photosUrls.map{ DownloadablePhoto(url: $0) }
        )
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: CountryCoderConstants.Name) as? String,
            let continent = aDecoder.decodeObject(forKey: CountryCoderConstants.Continent) as? String,
            let capital = aDecoder.decodeObject(forKey: CountryCoderConstants.Capital) as? String,
            let description = aDecoder.decodeObject(forKey: CountryCoderConstants.Description) as? String,
            let descriptionSmall = aDecoder.decodeObject(forKey: CountryCoderConstants.DescriptionSmall) as? String,
            let flag = aDecoder.decodeObject(forKey: CountryCoderConstants.Flag) as? DownloadablePhoto,
            let photos = aDecoder.decodeObject(forKey: CountryCoderConstants.Photos) as? [DownloadablePhoto] else {
            
            return nil
        }
        
        self.init(name: name,
                  continent: continent,
                  capital: capital,
                  population: aDecoder.decodeInteger(forKey: CountryCoderConstants.Population),
                  descriptionSmall: descriptionSmall,
                  description: description,
                  flag: flag,
                  photos: photos)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: CountryCoderConstants.Name)
        aCoder.encode(continent, forKey: CountryCoderConstants.Continent)
        aCoder.encode(capital, forKey: CountryCoderConstants.Capital)
        aCoder.encode(population, forKey: CountryCoderConstants.Population)
        aCoder.encode(countryDescription, forKey: CountryCoderConstants.Description)
        aCoder.encode(countryDescriptionSmall, forKey: CountryCoderConstants.DescriptionSmall)
        aCoder.encode(flag, forKey: CountryCoderConstants.Flag)
        aCoder.encode(photos, forKey: CountryCoderConstants.Photos)
    }
}
