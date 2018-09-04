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
    
    var hasNextPage: Bool {
        return !countriesListData.nextPageUrl.isEmpty
    }
        
    func numberOfCountries(in section: Int = 0) -> Int {
        return storage.fetchedResultController?.sections?[section].numberOfObjects ?? 0
        //return countriesListData.countries.count
    }
    
    func country(at indexPath: IndexPath) -> Country? {
        return Country(from: storage.fetchedResultController?.object(at: indexPath))
        //return countriesListData.countries[indexPath.row]
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
    
    func nextPage(completionHandler: @escaping (Int) -> ()) {
        guard hasNextPage else { return }
                
        getCountries() { countries in
            self.countriesListData.countries += countries
            self.storage.store(countries)
            
            completionHandler(countries.count)
        }
        
        provider.nextPageUrl(from: self.countriesListData.nextPageUrl) { nextPageUrl in
            self.countriesListData.nextPageUrl = nextPageUrl
            self.storage.store(nextPageUrl)
        }
    }
    
    func photosForCountry(at indexPath: IndexPath?,
                          eachCompletionHandler completionHandler: @escaping (Data?) -> ()) {
        guard let indexPath = indexPath,
            let country = country(at: indexPath)
            else {
                return
        }
        
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

    private func getCountries(completionHandler: @escaping ([Country]) -> ()) {
        guard hasNextPage else { return }
        
        provider.countries(from: self.countriesListData.nextPageUrl) { [weak self] countries in
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
