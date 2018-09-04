//
//  CountriesNetworkProvider.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 04.09.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

class CountriesNetworkProvider {
    
    func nextPageUrl(from url: String,
                     completionHandler: @escaping (String) -> ()) {
        
        executeRequest(from: url) { data in
            do {
                let nextPageUrl = try CountriesJSONParser().nextPageUrl(from: data)
                completionHandler(nextPageUrl)
            } catch {
                print(error)
                return
            }
        }
    }
    
    func countries(from urlString: String,
                     completionHandler: @escaping ([Country]) -> ()) {
        
        executeRequest(from: urlString) { data in
            var countries: [Country]
            
            do {
                countries = try CountriesJSONParser().countries(from: data)
            } catch {
                print(error)
                return
            }
            
            self.attachFlags(to: countries, completionHandler: completionHandler)
        }
    }
    
    func photo(from url:String, completionHandler: @escaping (Data)->()) {
        executeRequest(from: url) { data in
            completionHandler(data)
        }
    }
        
    private func attachFlags(to countries: [Country],
                                completionHandler handler: @escaping ([Country])->()) {
        let countriesHandlersGroup = DispatchGroup()
        
        for country in countries {
            countriesHandlersGroup.enter()
            attachFlag(to: country) {
                countriesHandlersGroup.leave()
            }
        }
        
        //Wait until all countries are updated
        countriesHandlersGroup.notify(queue: .main) {
            handler(countries)
        }
    }
    
    private func attachFlag(to country: Country,
                            completionHandler: @escaping ()->()) {
        executeRequest(from: country.flag.url) { imageData in
            country.flag.image = imageData
            completionHandler()
        }
    }

    private func executeRequest(from urlString: String,
                                      completionHandler handler: @escaping (Data) -> ()) {
        
        guard let url = URL(string: urlString) else { return }
        
        let urlRequest = URLRequest(url: url)
        
        let urlSession = URLSession.shared.dataTask(with: urlRequest) {
            (data, urlResponse, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else {
                print("Empty data received")
                return
            }
            
            DispatchQueue.main.async {
                handler(data)
            }
        }
        
        urlSession.resume()
    }
}
