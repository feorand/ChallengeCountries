//
//  Parser.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 18/10/2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

protocol Parser {
    func page(from data: Data) throws -> (String, [Country]) 
}
