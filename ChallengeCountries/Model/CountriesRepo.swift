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
    
    var container: NSPersistentContainer? = AppDelegate.sharedPersistenseContainer
    var fetchedResultController: NSFetchedResultsController<CountryData>?

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
    
    init() {
        countriesListData = CountriesListData(countries: [], nextPageUrl: NetworkSettings.initialUrl)
    }
    
    func clearCountriesList() {
        countriesListData = CountriesListData(countries: [], nextPageUrl: NetworkSettings.initialUrl)
    }
    
    func getNextPageOfCurrentCountriesList(completionHandler handler: @escaping (Int) -> ()) {
        
        guard hasNextPage else { return }
        
        CountriesRepo.getCountries(from: self.countriesListData.nextPageUrl) { countriesListData in
            self.countriesListData.nextPageUrl = countriesListData.nextPageUrl
            self.countriesListData.countries += countriesListData.countries
            self.updateDatabase(with: self.countriesListData)
            
            handler(countriesListData.countries.count)
        }
    }
    
    func getPhotosForCountry(at indexPath: IndexPath?,
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
                CountriesRepo.executeRequest(from: photo.url) { data in
                    photo.image = data
                    self.updateDatabase(with: photo)
                    
                    completionHandler(data)
                }
            }
        }
    }
    
    private class func getCountries(from urlString: String,
                                    completionHandler handler: @escaping (CountriesListData) -> ()) {
        
        executeRequest(from: urlString) { data in
            var _countriesListData = CountriesListData([], "")
            
            do {
                _countriesListData = try CountriesJSONParser().countriesListData(from: data)
            } catch {
                print(error)
                return
            }
            
            self.getFlags(for: _countriesListData.countries) { countries in
                handler(_countriesListData)
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
