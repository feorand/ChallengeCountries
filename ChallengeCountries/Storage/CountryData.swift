//
//  CountryData.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 31.08.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation
import CoreData

class CountryData: NSManagedObject {
    
    class func numberOfCountries(in context: NSManagedObjectContext) throws -> Int {
        let fetchRequest:NSFetchRequest<CountryData> = CountryData.fetchRequest()
        let numberOfCountries = try context.count(for: fetchRequest)
        return numberOfCountries
    }
    
    class func insertIfAbsent(_ country: Country, in context: NSManagedObjectContext) throws {
        guard try fetchCountry(named: country.name, in: context) == nil else { return }
        
        let countryData = CountryData(context: context)
        countryData.name = country.name
        countryData.capital = country.capital
        countryData.continent = country.continent
        countryData.population = Int32(country.population)
        countryData.countryDescription = country.countryDescription
        countryData.countryDescriptionSmall = country.countryDescriptionSmall
        
        let flag = DownloadablePhotoData.from(photo: country.flag, in: context)
        flag.isFlag = true
        countryData.addToStoredImages(flag)
    }
        
    private class func fetchCountry(named name: String, in context: NSManagedObjectContext) throws -> CountryData? {
        let request: NSFetchRequest<CountryData> = CountryData.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", name)
        
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                assert(result.count == 1, "CountryData.fetchCountry - multiple countries with single name found")
                return result.first!
            }
        } catch {
            throw error
        }
        
        return nil
    }
}
