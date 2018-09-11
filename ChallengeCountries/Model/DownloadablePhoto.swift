//
//  DownloadablePhoto.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 27.08.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

class DownloadablePhoto {
    let url: String
    var image: Data?
    
    convenience init(url: String) {
        self.init(url: url, image: nil)
    }
    
    init(url: String, image: Data?) {
        self.url = url
        self.image = image
    }
}
