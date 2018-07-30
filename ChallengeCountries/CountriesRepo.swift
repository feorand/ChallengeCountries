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


class CountriesRepo {
    private var next: String = ""
    
    var countries: [Country] = []
    
    func updateCountries(handler: ()->Void) {
        request(RepoConstants.InitialUrl).responseJSON{ response in
            switch response.result {
            case .success(let value):
                let parsedResult = self.parseJSONResult(rawData: value)!
                self.next = parsedResult.next
                self.countries = parsedResult.countries
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
    
    private func parseJSONResult(rawData: Any) -> (next: String, countries: [Country])? {
        //guard let initialDictionary = rawData as? [String: Any] else { return nil }
        
        return nil
    }
}
