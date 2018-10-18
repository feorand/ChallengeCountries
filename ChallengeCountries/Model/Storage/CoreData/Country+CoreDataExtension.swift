//
//  Country+Extension.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 05.09.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

extension Country {
    convenience init(from data: CoreDataCountry?) {
        let flag = data!
            .storedImages!
            .compactMap{ $0 as? CoreDataDownloadablePhoto }
            .filter{ $0.isFlag }
            .first!
        
        let photos = data!
            .storedImages?
            .compactMap{ $0 as? CoreDataDownloadablePhoto }
            .filter{ !$0.isFlag }
        
        self.init(
            name: data!.name!,
            continent: data!.continent!,
            capital: data!.capital!,
            population: Int(data!.population),
            descriptionSmall: data!.countryDescriptionSmall!,
            description: data!.countryDescription!,
            flag: DownloadablePhoto(from: flag),
            photos: photos!.map(DownloadablePhoto.init(from:))
        )
    }
}
