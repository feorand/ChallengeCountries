//
//  CountriesNetworkProvider.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 04.09.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

class CountriesNetworkProvider: CountriesProvider {
    
    private var nextPageUrl:String
    
    required init(_ nextPageUrl: String? = nil) {
        self.nextPageUrl = nextPageUrl ?? NetworkSettings.initialUrl
    }
    
    func firstPage(completionHandler: @escaping (String, [Country]) -> ()) {
        downloadPage(from: NetworkSettings.initialUrl) { nextPageUrl, countries in
            self.nextPageUrl = nextPageUrl
            self.attachFlags(to: countries) {
                completionHandler(nextPageUrl, countries)
            }
        }
    }
    
    func nextPage(completionHandler: @escaping (String, [Country]) -> ()) {
        downloadPage(from: nextPageUrl) { nextPageUrl, countries in
            self.nextPageUrl = nextPageUrl
            completionHandler(nextPageUrl, countries)
        }
    }
    
    var reachedEnd: Bool {
        return nextPageUrl.isEmpty
    }

    private func downloadPage(from url: String, completionHandler: @escaping (String, [Country]) -> ()) {
        executeRequest(from: url) { data in
            var result: (String, [Country])
            
            do {
                result = try CountriesJSONParser().page(from: data)
                completionHandler(result.0, result.1)
            } catch {
                print(error)
                return
            }
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
    
    private func attachFlags(to countries: [Country],
                             completionHandler handler: @escaping ()->()) {
        let countriesHandlersGroup = DispatchGroup()
        
        for country in countries {
            countriesHandlersGroup.enter()
            attachFlag(to: country) {
                countriesHandlersGroup.leave()
            }
        }
        
        //Wait until all countries are updated
        countriesHandlersGroup.notify(queue: .main) {
            handler()
        }
    }
    
    private func attachFlag(to country: Country,
                            completionHandler: @escaping ()->()) {
        photo(from: country.flag.url) { imageData in
            country.flag.image = imageData
            completionHandler()
        }
    }
    
    func photo(from url: String, completionHandler: @escaping (Data)->()) {
        executeRequest(from: url, completionHandler: completionHandler)
    }

}
