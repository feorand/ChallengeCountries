//
//  CountriesList.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 30.07.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation
import Alamofire

struct RepoConstants {
    static let InitialUrl = "https://rawgit.com/NikitaAsabin/799e4502c9fc3e0ea7af439b2dfd88fa/raw/7f5c6c66358501f72fada21e04d75f64474a7888/page1.json"
}

enum CountriesRepoError: Error {
    case JSONCannotExtractNode(name: String)
    case JSONCannotExtractCountryNode(name: String, index: Int)
}

//TODO: Logging

class CountriesRepo {
    private var next: String = ""
    
    private(set) var countries: [Country] = []
    
    func updateCountries(handler: @escaping ()->()) {
        request(RepoConstants.InitialUrl).responseJSON{ response in
            switch response.result {
            case .success(let value):
                do {
                    let parsedResult = try self.parseJSONResult(rawData: value)
                    
                    let countriesHandlersGroup = DispatchGroup()
                    
                    for country in parsedResult.countries {
                        countriesHandlersGroup.enter()
                        
                        self.getImage(fromUrl: country.flagUrl) { imageData in
                            country.flag = imageData
                            countriesHandlersGroup.leave()
                        }
                    }
                    
                    countriesHandlersGroup.notify(queue: .main) {
                        self.next = parsedResult.next
                        self.countries = parsedResult.countries

                        handler()
                    }
                } catch {
                    print(error)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getNextPage(handler: ()->Void) {
        //TODO: Actual get here
        
        handler()
    }
    
    private func getImage(fromUrl url: String, completionHandler: @escaping (_ imageData: Data?) -> ()) {
        request(url).responseData{ response in
            switch response.result {
            case .success(let value):
                completionHandler(value)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func parseJSONResult(rawData: Any) throws -> (next: String, countries: [Country]) {
        typealias JSONDictionary = [String: Any]
        typealias JSONArray = [Any]

        func getError(name: String, index: Int) -> CountriesRepoError {
            return (index == 0) ?
                .JSONCannotExtractNode(name: name) :
                .JSONCannotExtractCountryNode(name: name, index: index)
        }
        
        func extract<Type>(from data: Any, nodeName: String, index: Int = 0) throws -> Type {
            guard let result = data as? Type else { throw getError(name: nodeName, index: index) }
            return result
        }
        
        func extractEntry<Type>(from dictionary: JSONDictionary,key: String, index: Int = 0) throws -> Type {
            guard let result = dictionary[key] as? Type else { throw getError(name: key, index: index) }
            return result
        }
        
        func parseCountry(countryRaw: Any, index: Int) throws -> Country{
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
        
        let initialDictionary: JSONDictionary = try extract(from: rawData, nodeName: "main")
        
        let next:String = try extractEntry(from: initialDictionary, key: "next")
        
        let countriesRaw:JSONArray = try extractEntry(from: initialDictionary, key: "countries")
        
        let countries = try countriesRaw.enumerated().map { try parseCountry(countryRaw: $0.element, index: $0.offset) }
        
        return (next,countries)
    }
}
