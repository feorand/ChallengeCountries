//
//  CountriesJSONParser.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 31.07.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

class CountriesJSONParser: Parser {
    private struct CountriesFromJSON: Decodable {
        
        let next: String
        let countries: [CountryFromJSON]
        
        struct CountryFromJSON: Decodable {
            let name: String
            let continent: String
            let capital: String
            let population: Int
            let description_small: String
            let description: String
            let image: String
            let country_info: CountryInfoFromJSON
            
            struct CountryInfoFromJSON: Decodable {
                let images: [String]
                let flag: String
            }
        }
    }
    
    required init() {} //required for constructing with metatype value
    
    func page(from data: Data) throws -> (String, [Country]) {
        let countriesData = try JSONDecoder().decode(CountriesFromJSON.self, from: data)
        let countries = countriesData.countries.map(countryFromData)
        return (countriesData.next, countries)
    }
    
    private func countryFromData(_ data: CountriesFromJSON.CountryFromJSON) -> Country {
        let imagesUrls = data.country_info.images + [data.image]
        let nonEmptyImagesUrls = imagesUrls.filter{ !$0.isEmpty }

        let country = Country(
            name: data.name,
            continent: data.continent,
            capital: data.capital,
            population: data.population,
            descriptionSmall: data.description_small,
            description: data.description,
            flagUrl: data.country_info.flag,
            photosUrls: nonEmptyImagesUrls
        )

        return country
    }
}