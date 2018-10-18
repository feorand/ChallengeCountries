//
//  RealmState.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 11.09.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class RealmState: Object {
    dynamic var stateKey: String = ""
    dynamic var value: String = ""
    
    override static func primaryKey() -> String? {
        return "stateKey"
    }
}
