//
//  CountriesProvider.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 04.09.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

protocol CountriesProvider {
    //TODO: Return protocol usage
    
    func getCountriesList(from urlString: String,
                          completionHandler handler: @escaping ([Country], String) -> ())
    
    func executeRequest(from urlString: String,
                        completionHandler handler: @escaping (Data) -> ())
}
