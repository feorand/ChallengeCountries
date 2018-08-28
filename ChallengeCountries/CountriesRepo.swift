//
//  CountriesList.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 30.07.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

struct RepoConstants {
    static let InitialUrl = "https://rawgit.com/NikitaAsabin/799e4502c9fc3e0ea7af439b2dfd88fa/raw/7f5c6c66358501f72fada21e04d75f64474a7888/page1.json"
    static let PathToLocalCountriesStorage = FileManager.DocumentsDirectory.appendingPathComponent("Countries").path
}

//TODO: Changle all prints to logs

class CountriesRepo {
    
    private var countriesListData: CountriesListData
    
    var hasNextPage: Bool {
        return !countriesListData.nextPageUrl.isEmpty
    }
    
    var countries: [Country] {
        return countriesListData.countries
    }
    
    init() {
        if let storedData = CountriesRepo.getStoredData() {
            countriesListData = storedData
        } else {
            countriesListData = CountriesListData(nextPageUrl: RepoConstants.InitialUrl)
        }
    }
    
    func clearCountriesList() {
        countriesListData = CountriesListData(nextPageUrl: RepoConstants.InitialUrl)
    }
    
    func getNextPageOfCurrentCountriesList(completionHandler handler: @escaping (Int) -> ()) {
        
        guard hasNextPage else { return }
        
        CountriesRepo.getCountries(from: self.countriesListData.nextPageUrl) { nextPageUrl, countries in
            self.countriesListData.nextPageUrl = nextPageUrl
            self.countriesListData.countries += countries
            
            CountriesRepo.store(data: self.countriesListData)
            
            handler(countries.count)
        }
    }
    
    func getPhotosForCountry(index: Int?,
                             eachCompletionHandler completionHandler: @escaping (Data?) -> ()) {
        
        guard let index = index,
            index >= 0,
            index < countries.count else {
                
            return
        }
        
        let country = countries[index]
        
        for photo in country.photos {
            if let imageData = photo.image {
                completionHandler(imageData)
            } else {
                CountriesRepo.executeRequest(from: photo.url) { data in
                    photo.image = data
                    CountriesRepo.store(data: self.countriesListData)
                    
                    completionHandler(data)
                }
            }
        }
    }
    
    private class func store(data: CountriesListData) {
        NSKeyedArchiver.archiveRootObject(data, toFile: RepoConstants.PathToLocalCountriesStorage)
    }
    
    private class func getStoredData() -> CountriesListData? {
        return NSKeyedUnarchiver
            .unarchiveObject(withFile: RepoConstants.PathToLocalCountriesStorage)
            as? CountriesListData
    }
    
    private class func getCountries(from urlString: String,
                                    completionHandler handler: @escaping (String, [Country]) -> ()) {
        
        executeRequest(from: urlString) { data in
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
    
    private class func executeRequest(from urlString: String,
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
    
    private class func getFlags(for countries: [Country],
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
}
