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
    private var nextPageUrl: String = RepoConstants.InitialUrl
    
    private(set) var countries: [Country] = []
    
    func getNextPageOfCountriesList(completionHandler handler: @escaping () -> ()) {
        guard !nextPageUrl.isEmpty else { return }
        
        CountriesRepo.getCountries(from: self.nextPageUrl) { nextPageUrl, countries in
            self.nextPageUrl = nextPageUrl
            self.countries = countries
            handler()
        }
    }
    
    private class func getCountries(from url: String,
        completionHandler handler: @escaping (String, [Country]) -> ()) {
        
        request(url).responseJSON{ response in
            self.executeIfSuccess(response: response) { data in
                var _nextPageUrl = ""
                var _countries: [Country] = []
                
                do {
                    _nextPageUrl = try CountriesJSONParser.GetNextPageUrl(from: data)
                    _countries = try CountriesJSONParser.GetCountries(from: data)
                } catch {
                    print(error)
                    return
                }
                
                self.getFlags(for: _countries) { countries in
                    handler(_nextPageUrl, countries)
                }
            }
        }
    }
    
    // Executes handler if response state is Success
    private class func executeIfSuccess<T>(response: DataResponse<T>, handler: (T) -> ()) {
        switch response.result {
        case .success(let value):
            handler(value)
        case .failure(let error):
            print(error)
        }
    }
    
    private class func getImage(fromUrl url: String, completionHandler handler: @escaping (Data?) -> ()) {
        request(url).responseData{ response in
            self.executeIfSuccess(response: response, handler: handler)
        }
    }
    
    private class func getFlags(for countries: [Country],
                          completionHandler handler: @escaping ([Country])->()) {
        let countriesHandlersGroup = DispatchGroup()
        
        for country in countries {
            countriesHandlersGroup.enter()
            self.getImage(fromUrl: country.flagUrl) { imageData in
                country.flag = imageData
                countriesHandlersGroup.leave()
            }
        }
        
        //Wait until all countries are updated
        countriesHandlersGroup.notify(queue: .main) {
            handler(countries)
        }
    }
    
    class func getPhoto(fromUrl url: String, completionHandler handler: @escaping (Data?) -> ()) {
        getImage(fromUrl: url, completionHandler: handler)
    }
}
