//
//  FileManagerExtensionsTests.swift
//  ChallengeCountriesUnitTests
//
//  Created by Pavel Prokofyev on 12/10/2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import XCTest
@testable import ChallengeCountries

class FileManagerExtensionsTests: XCTestCase {

    func testDocumentsDirectory() {
        let directory = FileManager.DocumentsDirectory
        
        XCTAssertEqual("Documents", directory.lastPathComponent, "wrong directory")
    }
}
