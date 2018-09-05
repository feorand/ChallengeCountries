//
//  CountriesProvider.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 04.09.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

protocol CountriesProvider {
    
    init(_ nextPageUrl: String?)

    var reachedEnd: Bool { get }
    func firstPage(completionHandler: @escaping (String, [Country]) -> ())
    func nextPage(completionHandler: @escaping (String, [Country]) -> ())
    func photo(from url: String, completionHandler: @escaping (Data)->())
}
