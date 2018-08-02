//
//  ViewController.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 30.07.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

struct CountriesListConstants {
    static let FlagHeight:CGFloat = 34
    static let TopSpacing: CGFloat = 16
    
    static let MiddleSpacing: CGFloat = 11
    static let BottomSpacing: CGFloat = 16
    static let LeftSpacing: CGFloat = 15
    static let RightSpacing: CGFloat = 15
}

class CountriesListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
        
    let countriesRepo = CountriesRepo()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        countriesRepo.updateCountries(completionHandler: {
            self.hideActivityIndicator()
            self.tableView.reloadData()
        })
    }
    
    private func hideActivityIndicator() {
        self.activityIndicator.stopAnimating()
        self.tableView.separatorStyle = .singleLine
    }
}

extension CountriesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesRepo.countries.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Nothing to do when countries haven't loaded yet
        guard countriesRepo.countries.count > 0 else { return 0 }
        
        let country = countriesRepo.countries[indexPath.row]
        
        // Simplified height calculation for cells with no description
        if country.descriptionSmall.isEmpty {
            return CountriesListConstants.TopSpacing +
                CountriesListConstants.FlagHeight +
                CountriesListConstants.BottomSpacing
        }
        
        // Full height calculation
        
        let description = country.descriptionSmall as NSString
        
        let attributes = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15.0)]
        
        let descriptionWidth = view.bounds.width -
            CountriesListConstants.LeftSpacing -
            CountriesListConstants.RightSpacing
        
        let sizeLimits = CGSize(width: descriptionWidth, height: CGFloat.infinity)
        
        let boundingRect = description
            .boundingRect(with: sizeLimits,
                          options: .usesLineFragmentOrigin,
                          attributes: attributes,
                          context: nil)
        
        let descriptionHeight = boundingRect.height
        
        let cellHeight = CountriesListConstants.TopSpacing +
            CountriesListConstants.FlagHeight +
            CountriesListConstants.MiddleSpacing +
            descriptionHeight +
            CountriesListConstants.BottomSpacing
        
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Nothing to do when countries haven't loaded yet
        guard countriesRepo.countries.count > 0,
            let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell",
                                                     for: indexPath) as? CountryCell else {
            return UITableViewCell()
        }
        
        let country = countriesRepo.countries[indexPath.row]
        cell.country = country
                
        return cell
    }
}

