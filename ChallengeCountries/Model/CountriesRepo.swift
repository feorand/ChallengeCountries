//
//  CountriesList.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 30.07.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

//TODO: Changle all prints to logs

class CountriesRepo {
    
    typealias CountriesListData = (countries: [Country], nextPageUrl: String)
    
    var provider: CountriesProvider
    var storage: CoreDataStorage
    
    private var countriesListData: CountriesListData
    
    private var nextPageUrl: String {
        get { return storage.widthrawNextPageUrl() ?? "" }
        set { storage.store(newValue) }
    }
    
    var hasNextPage: Bool {
        return !nextPageUrl.isEmpty
    }
    
    var numberOfCountries: Int {
        return storage.numberOfCountries()
    }
            
    init(provider: CountriesProvider = CountriesNetworkProvider(),
         storage: CoreDataStorage = CoreDataStorage()) {
        self.provider = provider
        self.storage = storage
        
        countriesListData = CountriesListData(countries: [], nextPageUrl: NetworkSettings.initialUrl)        
    }
    
    func clearCountriesList() {
        countriesListData = CountriesListData(countries: [], nextPageUrl: NetworkSettings.initialUrl)
    }
    
    func firstPage(completionHandler: @escaping (Int) -> ()) {
        getCountries(from: NetworkSettings.initialUrl) { countries in
            self.countriesListData.countries = countries
            self.storage.store(countries)
            
            completionHandler(countries.count)
        }
        
        provider.nextPageUrl(from: nextPageUrl) { nextPageUrl in
            self.nextPageUrl = nextPageUrl
        }
    }
    
    func nextPage(completionHandler: @escaping (Int) -> ()) {
        guard hasNextPage else { return }
                
        getCountries(from: nextPageUrl) { countries in
            self.countriesListData.countries += countries
            self.storage.store(countries)
            
            completionHandler(countries.count)
        }
        
        provider.nextPageUrl(from: nextPageUrl) { nextPageUrl in
            self.nextPageUrl = nextPageUrl
        }
    }

    func photos(for country: Country,
                eachCompletionHandler completionHandler: @escaping (Data?) -> ()) {        
        for photo in country.photos {
            if let imageData = photo.image {
                completionHandler(imageData)
            } else {
                provider.photo(from: photo.url) { imageData in
                    photo.image = imageData
                    self.storage.store(photo)
                    completionHandler(imageData)
                }
            }
        }
    }

    private func getCountries(from url: String, completionHandler: @escaping ([Country]) -> ()) {
        provider.countries(from: url) { [weak self] countries in
            self?.attachFlags(to: countries) {
                completionHandler(countries)
            }
        }
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
        provider.photo(from: country.flag.url) { imageData in
            country.flag.image = imageData
            completionHandler()
        }
    }
}
