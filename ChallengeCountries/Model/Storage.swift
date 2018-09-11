//
//  Storage.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 05.09.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

protocol Storage {

    func store(_ nextPageUrl: String)
    func store(_ countries: [Country])
    func store(_ photo: DownloadablePhoto)
    
    func widthrawNextPageUrl() -> String?
    func widthrawCountries() -> [Country]
    
    func clear()
}
