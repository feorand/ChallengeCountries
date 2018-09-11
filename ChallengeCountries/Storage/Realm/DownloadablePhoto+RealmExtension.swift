//
//  DownloadablePhoto+extension.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 11.09.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

extension DownloadablePhoto {
    convenience init(from data:RealmDownloadablePhoto) {
        self.init(url: data.url, image: data.image)
    }
}
