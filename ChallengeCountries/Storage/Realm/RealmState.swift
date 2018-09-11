//
//  RealmState.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 11.09.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation
import RealmSwift

class RealmState: Object {
    @objc dynamic var key: String = ""
    @objc dynamic var value: String = ""
}
