//
//  Country+Extension.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 05.09.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

extension Country {
    convenience init(from data: CountryData?) {
        let flag = data!
            .storedImages?
            .compactMap{ $0 as? DownloadablePhotoData }
            .filter{ $0.isFlag }
            .first
        
        let photos = data!
            .storedImages?
            .compactMap{ $0 as? DownloadablePhotoData }
            .filter{ !$0.isFlag }
        
        let photosUrls = photos!.map{ $0.url! }
        
        let photosImages = photos!.map { $0.image }
        
        self.init(name: data!.name!,
                  continent: data!.continent!,
                  capital: data!.capital!,
                  population: Int(data!.population),
                  descriptionSmall: data!.countryDescriptionSmall!,
                  description: data!.countryDescription!,
                  flagUrl: flag!.url!,
                  photosUrls: photosUrls)
        
        self.flag.image = flag!.image
        
        for i in 0..<self.photos.count {
            self.photos[i].image = photosImages[i]
        }
    }
}
