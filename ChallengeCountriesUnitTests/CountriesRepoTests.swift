//
//  CountriesRepoTests.swift
//  ChallengeCountriesUnitTests
//
//  Created by Pavel Prokofyev on 18/10/2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import XCTest
@testable import ChallengeCountries

class CountriesRepoTests: XCTestCase {

    class StorageMock: Storage {
        
        var storeCountriesCallCount: Int = 0
        var storeNextPageUrlCallCount: Int = 0
        var storePhotoCallCount: Int = 0
        var widthrawCountiresCallCount: Int = 0
        var widthrawNextPageUrlCallCount: Int = 0
        var clearCallCount: Int = 0
        
        var countries: [Country] = []
        var nextPageUrl: String? = nil
        
        func store(_ nextPageUrl: String) {
            storeNextPageUrlCallCount += 1
        }
        
        func store(_ countries: [Country]) {
            storeCountriesCallCount += 1
        }
        
        func store(_ photo: DownloadablePhoto) {
            storePhotoCallCount += 1
        }
        
        func widthrawNextPageUrl() -> String? {
            widthrawNextPageUrlCallCount += 1
            return nextPageUrl
        }
        
        func widthrawCountries() -> [Country] {
            widthrawCountiresCallCount += 1
            return countries
        }
        
        func clear() {
            clearCallCount += 1
        }
    }
    
    class ProviderMock: CountriesProvider {
        var nextPageUrl: String = "next_page_url"
        
        var reachedEnd: Bool = false
        
        var countries: [Country] = []
        var photoData: Data = Data()
        
        var firstPageCallCount: Int = 0
        var nextPageCallCount: Int = 0
        var getImageCallCount: Int = 0
        
        func firstPage(completionHandler: @escaping (String, [Country]) -> ()) {
            firstPageCallCount += 1
            completionHandler("next_page_url_2", countries)
        }
        
        func nextPage(completionHandler: @escaping (String, [Country]) -> ()) {
            nextPageCallCount += 1
            completionHandler("next_page_url_3", countries)
        }
        
        func getImage(of photo: DownloadablePhoto, completionHandler: @escaping (Data) -> ()) {
            getImageCallCount += 1
            completionHandler(photoData)
        }
    }
    
    var storage: StorageMock!
    var provider: ProviderMock!
    
    override func setUp() {
        super.setUp()
        storage = StorageMock()
        provider = ProviderMock()
    }

    override func tearDown() {
        storage = nil
        provider = nil
        super.tearDown()
    }

    func testInit() {
        _ = CountriesRepo(provider: provider, storage: storage)
        XCTAssertEqual(1, storage.widthrawCountiresCallCount, "widthrawCountries was called wrong number of times")
    }
    
    func testInitialPage_new() {
        provider.countries = [Country(name: "name", continent: "continent", capital: "capital", population: 100, descriptionSmall: "description_small", description: "description", flagUrl: "flag_url", photosUrls: [])]
        let sut = CountriesRepo(provider: provider, storage: storage)
        
        sut.initialPage() {numberOfCountries in
            XCTAssertEqual(1, self.provider.firstPageCallCount, "incorrect firstPage call count")
            XCTAssertEqual(0, self.storage.widthrawNextPageUrlCallCount, "incorrect widthrawNextPageUrl call count")
            XCTAssertEqual(1, numberOfCountries, "incorrect number of countries")
        }
    }
    
    func testInitialPage_cached() {
        storage.countries = [Country(name: "name", continent: "continent", capital: "capital", population: 100, descriptionSmall: "description_small", description: "description", flagUrl: "flag_url", photosUrls: [])]
        let sut = CountriesRepo(provider: provider, storage: storage) // reload storage countries
        
        sut.initialPage() {numberOfCountries in
            XCTAssertEqual(0, self.provider.firstPageCallCount, "incorrect firstPage call count")
            XCTAssertEqual(1, self.storage.widthrawNextPageUrlCallCount, "incorrect widthrawNextPageUrl call count")
            XCTAssertEqual(1, numberOfCountries, "incorrect number of countries")
        }
    }
    
    func testNextPage() {
        provider.countries = [Country(name: "name", continent: "continent", capital: "capital", population: 100, descriptionSmall: "description_small", description: "description", flagUrl: "flag_url", photosUrls: [])]
        storage.countries = [Country(name: "name", continent: "continent", capital: "capital", population: 100, descriptionSmall: "description_small", description: "description", flagUrl: "flag_url", photosUrls: [])]
        let sut = CountriesRepo(provider: provider, storage: storage)
        
        sut.nextPage() {numberOfCountries in
            XCTAssertEqual(1, numberOfCountries, "incorrect number of countries received")
            XCTAssertEqual(2, sut.countries.count, "incorrect number of countries total")
            XCTAssertEqual(1, self.provider.nextPageCallCount, "Incorrect nextPage call count")
            XCTAssertEqual(1, self.storage.storeNextPageUrlCallCount, "Incorrect storeNextPageUrl call count")
            XCTAssertEqual(1, self.storage.storeCountriesCallCount, "Incorrect storeCountries call count")
            
        }
    }
    
    func testRefresh_clear() {
        storage.countries = [Country(name: "name", continent: "continent", capital: "capital", population: 100, descriptionSmall: "description_small", description: "description", flagUrl: "flag_url", photosUrls: [])]
        let sut = CountriesRepo(provider: provider, storage: storage)

        sut.refresh() {numberOfCountries in
            XCTAssertEqual(0, sut.countries.count, "Incorrect number of countries after refresh")
            XCTAssertEqual(1, self.storage.clearCallCount, "Incorrect clear call count")
            XCTAssertEqual(0, numberOfCountries, "Incorrect number of countries")
        }
    }
    
    func testRefresh_newCountries() {
        provider.countries = [Country(name: "name", continent: "continent", capital: "capital", population: 100, descriptionSmall: "description_small", description: "description", flagUrl: "flag_url", photosUrls: [])]
        let sut = CountriesRepo(provider: provider, storage: storage)

        sut.refresh() { numberOfCountries in
            XCTAssertEqual(1, numberOfCountries, "Incorrect number of countries")
            XCTAssertEqual(1, self.provider.firstPageCallCount, "Incorrect firstPage call count")
            XCTAssertEqual(0, self.provider.nextPageCallCount, "Incorrect nextPage call count")
            XCTAssertEqual(1, self.storage.storeCountriesCallCount, "Incorrect storeCountries call count")
            XCTAssertEqual(1, self.storage.storeNextPageUrlCallCount, "Incorrect storeNextPageUrl call count")
        }
    }
    
    func testPhotos_new() {
        let photoData = Data(count: 4)
        provider.photoData = photoData
        storage.countries = [Country(name: "name", continent: "continent", capital: "capital", population: 100, descriptionSmall: "description_small", description: "description", flagUrl: "flag_url", photosUrls: ["1", "2", "3"])]
        let sut = CountriesRepo(provider: provider, storage: storage)
        
        sut.photos(for: sut.countries.first!) {photo in
            XCTAssertEqual(photoData, photo.image, "Incorrect photo data")
            XCTAssertGreaterThan(self.provider.getImageCallCount, 0, "Incorrect getImage call count")
            XCTAssertGreaterThan(self.storage.storePhotoCallCount, 0, "Incorrect storePhoto call count")
        }
    }
    
    func testPhotos_cached() {
        let photo = DownloadablePhoto(url: "1", image: Data(count: 3))
        storage.countries = [Country(name: "name", continent: "cont", capital: "cap", population: 10, descriptionSmall: "desc", description: "desc", flag: photo, photos: [photo, photo])]
        let sut = CountriesRepo(provider: provider, storage: storage)
        
        sut.photos(for: sut.countries.first!) {downloadedPhoto in
            XCTAssertEqual(0, self.provider.getImageCallCount,"Incorrect getImage call count")
            XCTAssertEqual(photo.image, downloadedPhoto.image, "Incorrect photo image")
        }
    }
}
