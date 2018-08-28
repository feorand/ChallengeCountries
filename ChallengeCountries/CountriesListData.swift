//
//  CountriesListData.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 27.08.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

class CountriesListData: Codable {
    var countries: [Country]
    var nextPageUrl: String
    
    init(countries: [Country] = [], nextPageUrl:String = "") {
        self.countries = countries
        self.nextPageUrl = nextPageUrl
    }
}
