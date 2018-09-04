//
//  CountriesProvider.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 04.09.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

protocol CountriesProvider {
    func nextPageUrl(from url: String,
                     completionHandler: @escaping (String) -> ())
    
    func countries(from url: String,
                   completionHandler: @escaping ([Country]) -> ()) 
    
    func photo(from url:String,
               completionHandler: @escaping (Data)->())
}
