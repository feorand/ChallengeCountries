//
//  CountriesNetworkProvider.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 04.09.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

class CountriesNetworkProvider: CountriesProvider {
    
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
                completionHandler(countries)
            } catch {
                print(error)
                return
            }
        }
    }
    
    func photo(from url:String, completionHandler: @escaping (Data)->()) {
        executeRequest(from: url) { data in
            completionHandler(data)
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
