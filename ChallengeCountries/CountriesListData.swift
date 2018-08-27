//
//  CountriesListData.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 27.08.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

struct CountriesListDataCoderConstants {
    static let Countries = "countries"
    static let NextPageURL = "next_page_url"
}

class CountriesListData: NSObject, NSCoding {
    var countries: [Country]
    var nextPageUrl: String
    
    init(countries: [Country] = [], nextPageUrl:String = "") {
        self.countries = countries
        self.nextPageUrl = nextPageUrl
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let countries = aDecoder.decodeObject(forKey: CountriesListDataCoderConstants.Countries) as? [Country],
            let nextPageUrl = aDecoder.decodeObject(forKey: CountriesListDataCoderConstants.NextPageURL) as? String else {

                return nil
        }
        
        self.init(countries: countries, nextPageUrl: nextPageUrl)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(countries, forKey: CountriesListDataCoderConstants.Countries)
        aCoder.encode(nextPageUrl, forKey: CountriesListDataCoderConstants.NextPageURL)
    }
}
