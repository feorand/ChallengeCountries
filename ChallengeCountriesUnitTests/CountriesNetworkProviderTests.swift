//
//  CountriesNetworkProviderTests.swift
//  ChallengeCountriesUnitTests
//
//  Created by Pavel Prokofyev on 18/10/2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import XCTest
@testable import ChallengeCountries

class CountriesNetworkProviderTests: XCTestCase {
    
    class MockDownloader: Downloader {
        
        var downloadCallCount = 0
        var downloadLastCallUrl: String = ""
        
        var downloadedData = Data()
        
        func download(from urlString: String, completionHandler handler: @escaping (Data) -> ()) {
            downloadCallCount += 1
            downloadLastCallUrl = urlString
            handler(downloadedData)
        }
    }
    
    class MockParser: Parser {
        
        var pageCallCount = 0
        var nextPageUrl = "next_page_url"
        var countries: [Country] = []
        
        func page(from data: Data) throws -> (String, [Country]) {
            pageCallCount += 1
            return (nextPageUrl, countries)
        }
    }
    
    class ErrorMockParser: Parser {
        func page(from data: Data) throws -> (String, [Country]) {
            throw NSError(domain: "1", code: 1, userInfo: [:])
        }
    }
    
    var downloader: MockDownloader!
    var parser: MockParser!
    var sut: CountriesNetworkProvider!

    override func setUp() {
        super.setUp()
        downloader = MockDownloader()
        parser = MockParser()
        sut = CountriesNetworkProvider(downloader: downloader, parser: parser)
    }

    override func tearDown() {
        sut = nil
        downloader = nil
        parser = nil
        super.tearDown()
    }
    
    func testFirstPage() {
        let photo = DownloadablePhoto(url: "1", image: Data(count: 3))
        downloader.downloadedData = photo.image!
        parser.countries = [Country(name: "name", continent: "cont", capital: "cap", population: 10, descriptionSmall: "desc", description: "desc", flag: photo, photos: [photo, photo])]
        
        let promise = expectation(description: "Invoke completion handler")
        var next: String? = nil
        var countriesList: [Country] = []
        
        sut.firstPage() {nextPageUrl, countries in
            next = nextPageUrl
            countriesList = countries
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 0.01, handler: nil)
        
        XCTAssertEqual(parser.nextPageUrl, sut.nextPageUrl,"Incorrect next page url")
        XCTAssertEqual(parser.nextPageUrl, next, "Incorrect next page url returned")
        XCTAssertEqual(downloader.downloadedData, countriesList.first!.flag.image, "Incorrect flag image")
    }
    
    func testFirstPage_error() {
        sut = CountriesNetworkProvider(downloader: downloader, parser: ErrorMockParser())
        let promise = expectation(description: "Invoke completion handler")
        promise.isInverted = true
        var gotNext: String? = nil
        var gotCountries: [Country]? = nil
        
        sut.firstPage() { nextPageUrl, countries in
            gotNext = nextPageUrl
            gotCountries = countries
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 0.01, handler: nil)
        
        XCTAssertNil(gotNext)
        XCTAssertNil(gotCountries)
    }
    
    func testNextPage() {
        let promise = expectation(description: "Invoke completion handler")
        let nextPageUrl = "url_url"
        var gotNext: String? = nil
        sut.nextPageUrl = nextPageUrl
        sut.nextPage() { nextPageUrl, _ in
            gotNext = nextPageUrl
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 0.01, handler: nil)
        
        XCTAssertEqual(nextPageUrl, downloader.downloadLastCallUrl, "Incorrect nextPageUrl in call")
        XCTAssertEqual(parser.nextPageUrl, sut.nextPageUrl, "Incorrect nextPageUrl in instance")
        XCTAssertEqual(parser.nextPageUrl, gotNext, "Incorrect nextPageUrl in closure")
    }
    
    func testGetImage() {
        let data = Data(count: 5)
        let photo = DownloadablePhoto(url: "photo_url")
        downloader.downloadedData = data
        
        let promise = expectation(description: "Invoke completion handler")
        var closureImage: Data? = nil
        
        sut.getImage(of: photo) { image in
            closureImage = image
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 0.01, handler: nil)
        
        XCTAssertEqual(data, closureImage, "Incorrect photo data")
        XCTAssertEqual(1, downloader.downloadCallCount, "Incorrect download call count")
    }
}
