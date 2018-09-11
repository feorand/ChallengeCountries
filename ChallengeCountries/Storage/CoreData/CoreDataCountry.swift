//
//  CountryData.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 31.08.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation
import CoreData

class CoreDataCountry: NSManagedObject {
    
    class func numberOfCountries(in context: NSManagedObjectContext) throws -> Int {
        let fetchRequest:NSFetchRequest<CoreDataCountry> = CoreDataCountry.fetchRequest()
        let numberOfCountries = try context.count(for: fetchRequest)
        return numberOfCountries
    }
    
    class func clear(in context: NSManagedObjectContext) throws {
        let fetchRequest:NSFetchRequest<CoreDataCountry> = CoreDataCountry.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            _ = try context.execute(deleteRequest)
        } catch {
            throw error
        }
    }
    
    class func fetchAll(in context: NSManagedObjectContext) throws -> [CoreDataCountry] {
        let fetchRequest:NSFetchRequest<CoreDataCountry> = CoreDataCountry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let countries = try context.fetch(fetchRequest)
        return countries
    }

    class func insertIfAbsent(_ country: Country, in context: NSManagedObjectContext) throws {
        guard try fetchCountry(named: country.name, in: context) == nil else { return }
        
        let countryData = CoreDataCountry(context: context)
        countryData.name = country.name
        countryData.capital = country.capital
        countryData.continent = country.continent
        countryData.population = Int32(country.population)
        countryData.countryDescription = country.countryDescription
        countryData.countryDescriptionSmall = country.countryDescriptionSmall
        
        let flag = CoreDataDownloadablePhoto.from(country.flag, in: context)
        flag.isFlag = true
        countryData.addToStoredImages(flag)
        
        for photo in country.photos {
            let photoData = CoreDataDownloadablePhoto.from(photo, in: context)
            countryData.addToStoredImages(photoData)
        }
    }
        
    private class func fetchCountry(named name: String, in context: NSManagedObjectContext) throws -> CoreDataCountry? {
        let request: NSFetchRequest<CoreDataCountry> = CoreDataCountry.fetchRequest()
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
