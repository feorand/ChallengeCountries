//
//  CountriesJSONParser.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 31.07.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

enum JSONParsingError: Error {
    case CannotExtractNode(name: String)
    case CannotExtractCountryNode(name: String, index: Int)
}

class CountriesJSONParser {
    private typealias JSONDictionary = [String: Any]
    private typealias JSONArray = [Any]
    
    private class func getError(name: String, index: Int) -> JSONParsingError {
        return (index == 0) ?
            .CannotExtractNode(name: name) :
            .CannotExtractCountryNode(name: name, index: index)
    }
    
    private class func extract<Type>(from data: Any, nodeName: String, index: Int = 0) throws -> Type {
        guard let result = data as? Type else { throw getError(name: nodeName, index: index) }
        return result
    }
    
    private class func extractEntry<Type>(from dictionary: JSONDictionary,key: String, index: Int = 0) throws -> Type {
        guard let result = dictionary[key] as? Type else { throw getError(name: key, index: index) }
        return result
    }
    
    private class func parseCountry(countryRaw: Any, index: Int) throws -> Country{
        let country: JSONDictionary = try extract(from: countryRaw, nodeName: "country", index: index)
        
        let name: String = try extractEntry(from: country, key: "name", index: index)
        let capital: String = try extractEntry(from: country, key: "capital", index: index)
        let continent: String = try extractEntry(from: country, key: "continent", index: index)
        let population: Int = try extractEntry(from: country, key: "population", index: index)
        let descriptionSmall: String = try extractEntry(from: country, key: "description_small",index: index)
        let description: String = try extractEntry(from: country, key: "description", index: index)
        let imageUrl: String = try extractEntry(from: country, key: "image", index: index)
        
        let countryInfo: JSONDictionary = try extractEntry(from: country, key: "country_info", index: index)
        let imagesUrls: [String] = try extractEntry(from: countryInfo, key: "images", index: index)
        let flagUrl: String = try extractEntry(from: countryInfo, key: "flag", index: index)
        
        let resultImagesUrls = imageUrl.isEmpty ? imagesUrls : [imageUrl]
        return Country(name: name, continent: continent, capital: capital, population: population, descriptionSmall: descriptionSmall, description: description, flagUrl: flagUrl, photosUrls: resultImagesUrls)
    }
    
    class func GetCountries(from data: Any) throws -> [Country] {
        let initialDictionary: JSONDictionary = try extract(from: data, nodeName: "main")
        let countriesRaw: JSONArray = try extractEntry(from: initialDictionary, key: "countries")
        let countries = try countriesRaw.enumerated().map { try parseCountry(countryRaw: $0.element, index: $0.offset) }
        return countries
    }
    
    class func GetNextPageUrl(from data: Any) throws -> String {
        let initialDictionary: JSONDictionary = try extract(from: data, nodeName: "main")
        let nextPageUrl: String = try extractEntry(from: initialDictionary, key: "next")
        return nextPageUrl
    }
}
