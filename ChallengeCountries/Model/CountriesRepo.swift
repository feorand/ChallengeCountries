//
//  CountriesList.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 30.07.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation
import CoreData

//TODO: Changle all prints to logs

class CountriesRepo {
    
    typealias CountriesListData = (countries: [Country], nextPageUrl: String)
    
    var provider: CountriesProvider
        
    var container: NSPersistentContainer? = AppDelegate.sharedPersistenseContainer
    
    var delegate: NSFetchedResultsControllerDelegate? {
        didSet {
            fetchedResultController?.delegate = delegate
            try? fetchedResultController?.performFetch()
        }
    }
    
    private var fetchedResultController: NSFetchedResultsController<CountryData>?

    private var countriesListData: CountriesListData
    
    var hasNextPage: Bool {
        return !countriesListData.nextPageUrl.isEmpty
    }
        
    func numberOfCountries(in section: Int = 0) -> Int {
        //return fetchedResultController?.sections?[section].numberOfObjects ?? 0
        return countriesListData.countries.count
    }
    
    func country(at indexPath: IndexPath) -> Country? {
        //return fetchedResultController?.object(at: indexPath)
        return countriesListData.countries[indexPath.row]
    }
    
    init(provider: CountriesProvider? = nil) {
        self.provider = provider ?? CountriesNetworkProvider()
        
        countriesListData = CountriesListData(countries: [], nextPageUrl: NetworkSettings.initialUrl)
        
        if let context = container?.viewContext {
            let request: NSFetchRequest<CountryData> = CountryData.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

            fetchedResultController = NSFetchedResultsController<CountryData>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
        }
    }
    
    func clearCountriesList() {
        countriesListData = CountriesListData(countries: [], nextPageUrl: NetworkSettings.initialUrl)
    }
    
    func nextPage(completionHandler: @escaping (Int) -> ()) {
        guard hasNextPage else { return }
                
        getCountries() { countries in
            self.countriesListData.countries += countries
            self.updateDatabase(with: self.countriesListData)
            
            completionHandler(countries.count)
        }
        
        provider.nextPageUrl(from: self.countriesListData.nextPageUrl) { nextPageUrl in
            self.countriesListData.nextPageUrl = nextPageUrl
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
    
    private func updateDatabase(with countriesListData: CountriesListData) {
        container?.performBackgroundTask{ context in
            //TODO: Actual error handling
            
            try? StateData.setNextPageUrl(value: countriesListData.nextPageUrl, in: context)
            
            for country in countriesListData.countries {
                try? CountryData.insertIfAbsent(country, in: context)
            }
            
            try? context.save()
        }
    }
    
    private func updateDatabase(with photo: DownloadablePhoto) {
        container?.performBackgroundTask{ context in
            //TODO: Actual error handling
            
            try? DownloadablePhotoData.update(photo, in: context)
            try? context.save()
        }
    }
}
