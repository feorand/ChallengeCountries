//
//  CountriesNetworkProvider.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 04.09.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

class CountriesNetworkProvider: CountriesProvider {
    
    var nextPageUrl: String
    
    var reachedEnd: Bool {
        return nextPageUrl.isEmpty
    }

    private var downloader: Downloader
    private var parser: Parser
    
    required init(downloader: Downloader = NetworkSettings.downloader.init(),
                  parser: Parser = NetworkSettings.parser.init()) {
        self.downloader = downloader
        self.parser = parser
        nextPageUrl = NetworkSettings.initialUrl
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
    
    func getImage(of photo:DownloadablePhoto, completionHandler: @escaping (Data)->()) {
        downloader.download(from: photo.url, completionHandler: completionHandler)
    }
    
    private func downloadPage(from url: String, completionHandler: @escaping (String, [Country]) -> ()) {
        downloader.download(from: url) { data in
            var result: (String, [Country])
            
            do {
                result = try self.parser.page(from: data)
                completionHandler(result.0, result.1)
            } catch {
                print(error)
                return
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
        getImage(of: country.flag) { imageData in
            country.flag.image = imageData
            completionHandler()
        }
    }
}
