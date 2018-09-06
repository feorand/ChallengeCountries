//
//  Settings.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 31.08.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

struct NetworkSettings {
    static let initialUrl = "https://rawgit.com/NikitaAsabin/799e4502c9fc3e0ea7af439b2dfd88fa/raw/7f5c6c66358501f72fada21e04d75f64474a7888/page1.json"
}

struct StorageSettings {
    static let nextPageUrlKey = "next_page_url"
    static let container = AppDelegate.sharedPersistenseContainer
}

struct RepoSettings {
    static let provider = CountriesNetworkProvider.self
    static let storage = CoreDataStorage.self
}

struct CountriesTableSettings {
    static let flagHeight:CGFloat = 34
    static let topSpacing: CGFloat = 16
    
    static let middleSpacing: CGFloat = 11
    static let bottomSpacing: CGFloat = 16
    static let leftSpacing: CGFloat = 15
    static let rightSpacing: CGFloat = 15
    
    static let descriptionFontSize: CGFloat = 15
}

struct CountryDetailsSettings {
    static let topInset: CGFloat = -64
    static let descriptionOffset: CGFloat = 46
}

struct ImageSliderSettings {
    static let dotsSize: CGFloat = 6
    static let dotsBottomOffset: CGFloat = 8
    static let dotsSpacing: CGFloat = 5
}

