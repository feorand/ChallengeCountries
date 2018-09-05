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
    
    var provider: CountriesProvider
    var storage: CoreDataStorage
    
    private(set) var countries: [Country] {
        didSet {
            storage.store(countries)
        }
    }
    
    var reachedEnd: Bool {
        return provider.reachedEnd
    }
    
    init() {
        self.storage = CoreDataStorage()
        
        let nextPageUrl = storage.widthrawNextPageUrl()
        
        self.provider = CountriesNetworkProvider(nextPageUrl)
        
        countries = storage.widthrawCountries()
    }
    
    private func clear() {
        countries = []
    }
    
    func initialPage(completionHandler: @escaping (Int) -> ()) {
        let storedCountries = storage.widthrawCountries()
        
        if storedCountries.isEmpty{
            provider.firstPage() { nextPageUrl, countries in
                self.countries = countries
                self.storage.store(nextPageUrl)
                completionHandler(countries.count)
            }
            
            return 
        }
        
        countries = storedCountries
        completionHandler(countries.count)
    }
    
    func nextPage(completionHandler: @escaping (Int) -> ()) {
        provider.nextPage() { nextPageUrl, countries in
            self.countries += countries
            self.storage.store(nextPageUrl)
            completionHandler(countries.count)
        }
    }
    
    func refresh(completionHandler: @escaping (Int) -> ()) {
        provider.firstPage() { nextPageUrl, countries in
            self.storage.clear()
            self.countries = countries
            self.storage.store(nextPageUrl)
            completionHandler(countries.count)
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
}
