//
//  DownloadablePhoto.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 27.08.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation
import CoreData

class DownloadablePhoto {
    let url: String
    var image: Data?
    
    init(url: String) {
        self.url = url
    }
}
