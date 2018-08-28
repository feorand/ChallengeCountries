//
//  CountriesJSONParser.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 31.07.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

class CountriesJSONParser {
    private struct CountriesData: Decodable {
        let next: String
        let countries: [CountryData]
        
        struct CountryData: Decodable {
            let name: String
            let continent: String
            let capital: String
            let population: Int
            let description_small: String
            let description: String
            let image: String
            let country_info: CountryInfoData
            
            struct CountryInfoData: Decodable {
                let images: [String]
                let flag: String
            }
        }
    }
    
    func countriesListData(from data: Data) throws -> CountriesListData {
        let countriesData = try JSONDecoder().decode(CountriesData.self, from: data)
        
        let countriesListData = CountriesListData(nextPageUrl: countriesData.next)
        countriesListData.countries = countriesData.countries.map(countryFromData)
        
        return countriesListData
    }
    
    private func countryFromData(_ data: CountriesData.CountryData) -> Country {
        let imagesUrls = data.country_info.images + [data.image]
        let nonEmptyImagesUrls = imagesUrls.filter{ !$0.isEmpty }
        
        let country = Country(name: data.name,
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
