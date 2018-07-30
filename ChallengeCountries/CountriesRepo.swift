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
    case JSONCannotExtractMainDictionary
    case JSONCannotExtractNextNode
    case JSONCannotConvertNextToString
    case JSONCannotExtractCountriesNode
    case JSONCannotConvertCountriesToArray
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
        guard let initialDictionary = rawData as? [String: Any] else { throw CountriesRepoError.JSONCannotExtractMainDictionary }
        
        guard let nextRaw = initialDictionary["next"] else { throw CountriesRepoError.JSONCannotExtractNextNode }
        guard let next = nextRaw as? String else { throw CountriesRepoError.JSONCannotConvertNextToString }

        guard let countriesRaw = initialDictionary["countries"] else { throw CountriesRepoError.JSONCannotExtractCountriesNode }
        guard let countries = countriesRaw as? [[String: Any]] else { throw CountriesRepoError.JSONCannotConvertCountriesToArray }
        
        return (next, [])
    }
}
