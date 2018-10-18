//
//  RealmStorage.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 11.09.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation
import RealmSwift

class RealmStorage: Storage {
    
    private let realm: Realm
    
    required init() {
        //TODO: change to actual error handling
        realm = try! Realm()
    }
    
    func store(_ nextPageUrl: String) {
        let state = RealmState()
        state.stateKey = StorageSettings.nextPageUrlKey
        state.value = nextPageUrl
        
        try! realm.write {
            realm.add(state, update: true)
        }
    }
    
    func store(_ countries: [Country]) {
        let realmCountries = countries.map(RealmCountry.init(from:))
        try! realm.write {
            realm.add(realmCountries, update: true)
        }
    }
    
    func store(_ photo: DownloadablePhoto) {
        let realmPhoto = RealmDownloadablePhoto(from: photo)
        try! realm.write {
            realm.add(realmPhoto, update: true)
        }
    }
    
    func widthrawNextPageUrl() -> String? {
        return realm
            .objects(RealmState.self)
            .filter("stateKey = %@", StorageSettings.nextPageUrlKey)
            .first?
            .value
    }
    
    func widthrawCountries() -> [Country] {
        let realmCountries = realm.objects(RealmCountry.self)
        return realmCountries.map(Country.init(from:))
    }
    
    
    func clear() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}
