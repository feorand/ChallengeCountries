//
//  CountriesList.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 30.07.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

struct RepoConstants {
    static let InitialUrl = "https://rawgit.com/NikitaAsabin/799e4502c9fc3e0ea7af439b2dfd88fa/raw/7f5c6c66358501f72fada21e04d75f64474a7888/page1.json"
}

class CountriesRepo {
    private var next: String = ""
    
    var countries: [Country] = []
    
    func updateCountries(handler: ()->Void) {
        //TODO: Actual update here
        
        handler()
    }
    
    func getNextPage(handler: ()->Void) {
        //TODO: Actual get here
        
        handler()
    }
}
