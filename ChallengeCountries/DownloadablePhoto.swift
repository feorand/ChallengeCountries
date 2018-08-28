//
//  DownloadablePhoto.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 27.08.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

class DownloadablePhoto: Codable {
    let url: String
    var image: Data?
    
    init(url: String) {
        self.url = url
    }
}
