//
//  ChallengeCountriesUnitTests.swift
//  ChallengeCountriesUnitTests
//
//  Created by Pavel Prokofyev on 12/10/2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import XCTest
@testable import ChallengeCountries

class CountryTests: XCTestCase {
        
    func testInit() {
        let name = "Country1"
        let continent = "Cont1"
        let capital = "Cap1"
        let population = 1
        let descriptionSmall = "DescrSmall1"
        let description = "Descr1"
        let flag = DownloadablePhoto(url: "flag_url", image: Data(count: 3))
        let photos = [
            DownloadablePhoto(url: "photo_url_1", image: Data(count: 4)),
            DownloadablePhoto(url: "photo_url_2", image: Data(count: 5))
        ]
        
        let country = Country(
            name: name,
            continent: continent,
            capital: capital,
            population: population,
            descriptionSmall: descriptionSmall,
            description: description,
            flag: flag,
            photos: photos
        )
        
        XCTAssertEqual(name, country.name, "wrong name")
        XCTAssertEqual(continent, country.continent, "wrong continent")
        XCTAssertEqual(capital, country.capital, "wrong capital")
        XCTAssertEqual(population, country.population, "wrong population")
        XCTAssertEqual(descriptionSmall, country.countryDescriptionSmall, "wrong small description")
        XCTAssertEqual(description, country.countryDescription, "wrong description")
        XCTAssertEqual(flag.url, country.flag.url, "wrong flag URL")
        XCTAssertEqual(flag.image, country.flag.image, "wrong flag image")
        for (countryPhoto, photo) in zip(country.photos, photos) {
            XCTAssertEqual(photo.url, countryPhoto.url, "wrong photo url")
            XCTAssertEqual(photo.image, countryPhoto.image, "wrong photo image")
        }
    }
    
    func testConvenienceInit() {
        let name = "Country1"
        let continent = "Cont1"
        let capital = "Cap1"
        let population = 1
        let descriptionSmall = "DescrSmall1"
        let description = "Descr1"
        let flagUrl = "url"
        let photosUrls = ["url21", "url22"]
        
        let country = Country(
            name: name,
            continent: continent,
            capital: capital,
            population: population,
            descriptionSmall: descriptionSmall,
            description: description,
            flagUrl: flagUrl,
            photosUrls: photosUrls
        )
        
        XCTAssertEqual(name, country.name, "wrong name")
        XCTAssertEqual(continent, country.continent, "wrong continent")
        XCTAssertEqual(capital, country.capital, "wrong capital")
        XCTAssertEqual(population, country.population, "wrong population")
        XCTAssertEqual(descriptionSmall, country.countryDescriptionSmall, "wrong small description")
        XCTAssertEqual(description, country.countryDescription, "wrong description")
        XCTAssertEqual(flagUrl, country.flag.url, "wrong flag URL")
        XCTAssertNil(country.flag.image, "flag image isn't empty")
        XCTAssertTrue(country.photos.map{$0.url}.elementsEqual(photosUrls), "photos URLs don't match")
        for (countryPhoto, photoUrl) in zip(country.photos, photosUrls) {
            XCTAssertEqual(photoUrl, countryPhoto.url, "wrong photo url")
            XCTAssertNil(countryPhoto.image, "photo image isn't empty")
        }
    }
}
