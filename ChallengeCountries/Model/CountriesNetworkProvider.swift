//
//  CountriesNetworkProvider.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 04.09.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

class CountriesNetworkProvider: CountriesProvider {
    
    func getCountriesList(from urlString: String,
                                    completionHandler handler: @escaping ([Country], String) -> ()) {
        
        executeRequest(from: urlString) { data in
            var _countriesListData:([Country], String)
            do {
                _countriesListData = try CountriesJSONParser().countriesListData(from: data)
            } catch {
                print(error)
                return
            }
            
            self.getFlags(for: _countriesListData.0) { countries in
                handler(_countriesListData.0, _countriesListData.1)
            }
        }
    }
    
    private func getFlags(for countries: [Country],
                                completionHandler handler: @escaping ([Country])->()) {
        let countriesHandlersGroup = DispatchGroup()
        
        for country in countries {
            countriesHandlersGroup.enter()
            executeRequest(from: country.flag.url) { imageData in
                country.flag.image = imageData
                countriesHandlersGroup.leave()
            }
        }
        
        //Wait until all countries are updated
        countriesHandlersGroup.notify(queue: .main) {
            handler(countries)
        }
    }

    func executeRequest(from urlString: String,
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
