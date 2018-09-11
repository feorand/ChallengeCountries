//
//  CountriesProvider.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 04.09.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

protocol CountriesProvider {
    
    var nextPageUrl: String { get set }
    var reachedEnd: Bool { get }
    func firstPage(completionHandler: @escaping (String, [Country]) -> ())
    func nextPage(completionHandler: @escaping (String, [Country]) -> ())
    func getImage(of photo:DownloadablePhoto, completionHandler: @escaping (Data)->())
}
