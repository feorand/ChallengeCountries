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



//TODO: Changle all prints to logs

class CountriesRepo {
    private var nextPageUrl: String = ""
    
    private(set) var countries: [Country] = []
    
    func updateCountries(completionHandler handler: @escaping ()->()) {
        getCountries(fromUrl: RepoConstants.InitialUrl) { nextPageUrl, countries in
            self.nextPageUrl = nextPageUrl
            self.countries = countries
            
            handler()
        }
        
    }
    
    private func getCountries(fromUrl url: String,
                              completionHandler handler: @escaping (_ nextPageUrl: String, _ countries: [Country])->()) {
        
        request(url).responseJSON{ response in
            switch response.result {
            case .success(let value):
                var parseResult: (String, [Country])?
                do {
                    parseResult = try CountriesJSONParser.Parse(data: value)
                } catch {
                    print(error)
                }
                
                guard let (nextPageUrl, countries) = parseResult else {
                    return
                }
                
                let countriesHandlersGroup = DispatchGroup()
                
                for country in countries {
                    countriesHandlersGroup.enter()
                    
                    self.getImage(fromUrl: country.flagUrl) { imageData in
                        country.flag = imageData
                        countriesHandlersGroup.leave()
                    }
                }
                
                countriesHandlersGroup.notify(queue: .main) {
                    handler(nextPageUrl, countries)
                }
            case .failure(let error):
                print(error)
            }
        }
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
}
