//
//  Country+RealmExtension.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 11.09.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation
import RealmSwift

extension Country {
    convenience init(from data: RealmCountry) {
        let flag = DownloadablePhoto(from: data.flag!)
        let photos = data.photos.map(DownloadablePhoto.init(from:))
        
        self.init(
            name: data.name,
            continent: data.continent,
            capital: data.capital,
            population: data.population,
            descriptionSmall: data.countryDescriptionSmall,
            description: data.description,
            flag: flag,
            photos: Array(photos)
        )
    }
}
