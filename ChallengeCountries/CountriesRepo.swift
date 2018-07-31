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
    
    func updateCountries(completionHandler handler: @escaping () -> ()) {
        getCountries(from: RepoConstants.InitialUrl) { nextPageUrl, countries in
            self.nextPageUrl = nextPageUrl
            self.countries = countries
            handler()
        }
    }
    
    private func getCountries(from url: String,
                              completionHandler handler: @escaping (String, [Country]) -> ()) {
        
        // Pack into closure with appropriate signature
        let countryListDownloadedHandler: (Any) -> () = { data in
            var nextPageUrl = ""
            var countries: [Country] = []
            
            do {
                nextPageUrl = try CountriesJSONParser.GetNextPageUrl(from: data)
                countries = try CountriesJSONParser.GetCountries(from: data)
            } catch {
                print(error)
                return
            }
            
            //Pack into closure with appropriate signature
            let getFlagsCompletionHandler: ([Country]) -> () = { countries in
                handler(nextPageUrl, countries)
            }
            
            //Dowaload and fill flags for countries
            self.getFlags(for: countries, completionHandler: getFlagsCompletionHandler)
        }

        request(url).responseJSON{ response in
            self.executeIfSuccess(response: response, handler: countryListDownloadedHandler)
        }
    }
    
    // Executes handler if response state is Success
    private func executeIfSuccess<T>(response: DataResponse<T>, handler: (T) -> ()) {
        switch response.result {
        case .success(let value):
            handler(value)
        case .failure(let error):
            print(error)
        }
    }
    
    private func getImage(fromUrl url: String, completionHandler: @escaping (Data?) -> ()) {
        request(url).responseData{ response in
            self.executeIfSuccess(response: response, handler: completionHandler)
        }
    }
    
    private func getFlags(for countries: [Country],
                          completionHandler handler: @escaping ([Country])->()) {
        let countriesHandlersGroup = DispatchGroup()
        
        for country in countries {
            countriesHandlersGroup.enter()
            
            self.getImage(fromUrl: country.flagUrl) { imageData in
                country.flag = imageData
                countriesHandlersGroup.leave()
            }
        }
        
        countriesHandlersGroup.notify(queue: .main) {
            handler(countries)
        }
    }
}
