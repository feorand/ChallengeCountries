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
    
    private var provider: CountriesProvider
    private var storage: Storage
    
    private(set) var countries: [Country] {
        didSet {
            storage.store(countries)
        }
    }
    
    var reachedEnd: Bool {
        return provider.reachedEnd
    }
    
    init(provider: CountriesProvider = RepoSettings.provider.init(),
         storage: Storage = RepoSettings.storage.init()) {
        self.storage = storage
        self.provider = provider
        
        countries = storage.widthrawCountries()
    }
    
    func initialPage(completionHandler: @escaping (Int) -> ()) {
        if countries.isEmpty{
            provider.firstPage() { nextPageUrl, countries in
                self.countries = countries
                self.storage.store(nextPageUrl)
                completionHandler(countries.count)
            }
            
            return 
        }
        
        provider.nextPageUrl = storage.widthrawNextPageUrl() ?? ""
        
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
    
    func photos(for country: Country, eachCompletionHandler: @escaping (Data?) -> ()) {
        for photo in country.photos {
            if let imageData = photo.image {
                eachCompletionHandler(imageData)
            } else {
                provider.getImage(of: photo) { imageData in
                    photo.image = imageData
                    self.storage.store(photo)
                    eachCompletionHandler(imageData)
                }
            }
        }
    }
}
