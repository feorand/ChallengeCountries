//
//  CountriesListData.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 27.08.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

class CountriesListData: Codable {
    var nextPageUrl: String
    var countries: [Country] = []
    
    init(nextPageUrl:String = "") {
        self.nextPageUrl = nextPageUrl
    }
}
