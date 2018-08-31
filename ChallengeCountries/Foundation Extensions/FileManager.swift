//
//  FileManager+Extension.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 27.08.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

extension FileManager {
    static var DocumentsDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
