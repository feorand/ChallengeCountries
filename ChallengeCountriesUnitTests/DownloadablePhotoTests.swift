//
//  DownloadablePhotoTests.swift
//  ChallengeCountriesUnitTests
//
//  Created by Pavel Prokofyev on 12/10/2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import XCTest
@testable import ChallengeCountries

class DownloadablePhotoTests: XCTestCase {
    
    func testInit() {
        let url = "Url"
        let data = Data(count: 3)
        
        let photo = DownloadablePhoto(url: url, image: data)
        
        XCTAssertEqual(url, photo.url, "wrong url")
        XCTAssertEqual(data, photo.image, "wrong image")
    }
    
    func testConvenienceInit() {
        let url = "Url"
        
        let photo = DownloadablePhoto(url: url)
        
        XCTAssertEqual(url, photo.url, "wrong url")
        XCTAssertNil(photo.image, "image is not empty")
    }
}
