//
//  DownloadablePhoto.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 27.08.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

struct PhotoCoderConstants {
    static let Url = "url"
    static let Image = "image"
}

class DownloadablePhoto: NSObject, NSCoding {
    let url: String
    var image: Data?
    
    init(url: String) {
        self.url = url
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let photoUrl = aDecoder.decodeObject(forKey: PhotoCoderConstants.Url) as? String else {
            return nil
        }
        
        self.init(url: photoUrl)
        
        image = aDecoder.decodeObject(forKey: PhotoCoderConstants.Image) as? Data
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(url, forKey: PhotoCoderConstants.Url)
        aCoder.encode(image, forKey: PhotoCoderConstants.Image)
    }
}
