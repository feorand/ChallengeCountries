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

class CountriesRepo {
    private var next: String = ""
    
    var countries: [Country] = []
    
    func updateCountries(handler: ()->Void) {
        request(RepoConstants.InitialUrl).responseJSON{ response in
            switch response.result {
            case .success(let value):
                do {
                    let parsedResult = try self.parseJSONResult(rawData: value)
                    self.next = parsedResult.next
                    self.countries = parsedResult.countries
                } catch {
                    
                }
                
            case .failure(let error):
                print(error)
            }
        }
        handler()
    }
    
    func getNextPage(handler: ()->Void) {
        //TODO: Actual get here
        
        handler()
    }
    
    private func parseJSONResult(rawData: Any) throws -> (next: String, countries: [Country]) {
        typealias JSONDictionary = [String:Any]
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
        
        func extractEntry<Type>(from dictionary: JSONDictionary,key: String, nodeName: String, index: Int = 0) throws -> Type {
            guard let result = dictionary[key] as? Type else { throw getError(name: nodeName, index: index) }
            return result
        }
        
        let initialDictionary: JSONDictionary = try extract(from: rawData, nodeName: "Main")
        
        let next:String = try extractEntry(from: initialDictionary, key: "next", nodeName: "Next")
        
        let countries:JSONArray = try extract(from: initialDictionary, nodeName: "Countries")
        
        for (index, countryRaw) in countries.enumerated() {
            let country: JSONDictionary = try extract(from: countryRaw, nodeName: "country", index: index)
        }
        
        return (next, [])
    }
}
