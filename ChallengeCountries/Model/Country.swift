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
    
    init(name: String, continent: String, capital: String, population: Int, descriptionSmall: String, description: String, flagUrl: String, photosUrls: [String]) {
        
        self.name = name
        self.continent = continent
        self.capital = capital
        self.population = population
        self.countryDescription = description
        self.countryDescriptionSmall = descriptionSmall
        self.flag = DownloadablePhoto(url: flagUrl)
        self.photos = photosUrls.map{ DownloadablePhoto(url: $0) }
    }
    
    convenience init(from data: CountryData?) {
        let flag = data!
            .storedImages?
            .compactMap{ $0 as? DownloadablePhotoData }
            .filter{ $0.isFlag }
            .first
        
        let photos = data!
            .storedImages?
            .compactMap{ $0 as? DownloadablePhotoData }
            .filter{ !$0.isFlag }
        
        let photosUrls = photos!.map{ $0.url! }
        
        let photosImages = photos!.map { $0.image }

        self.init(name: data!.name!,
                  continent: data!.continent!,
                  capital: data!.capital!,
                  population: Int(data!.population),
                  descriptionSmall: data!.countryDescriptionSmall!,
                  description: data!.countryDescription!,
                  flagUrl: flag!.url!,
                  photosUrls: photosUrls)
        
        self.flag.image = flag!.image
        
        for i in 0..<self.photos.count {
            self.photos[i].image = photosImages[i]
        }
    }
}
