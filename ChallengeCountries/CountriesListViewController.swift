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
    
    static let DescriptionFontSize: CGFloat = 15
}

class CountriesListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private let countriesRepo = CountriesRepo()
    
    private var defaultCountryCellHeight: CGFloat {
        return CountriesListConstants.TopSpacing +
            CountriesListConstants.FlagHeight +
            CountriesListConstants.BottomSpacing
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        countriesRepo.getNextPageOfCountriesList(completionHandler: updateTable)
    }
    
    private func updateTable(numberOfNewCountries: Int) {
        spinner.stopAnimating()
        tableView.separatorStyle = .singleLine
        
        let rowsCount = tableView.numberOfRows(inSection: 0)
        let indexPaths = (rowsCount ..< rowsCount + numberOfNewCountries)
            .map { IndexPath(row: $0, section: 0) }
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        updateCountryTableFooterView()
    }
    
    private func updateCountryTableFooterView() {
        if countriesRepo.hasNextPage {
            showCountryTableFooterView()
        } else {
            hideCountryTableFooterView()
        }
    }
    
    private func showCountryTableFooterView() {
        let footerSpinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        footerSpinner.hidesWhenStopped = true
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0,
            width: tableView.frame.width, height: defaultCountryCellHeight))
        footerView.addSubview(footerSpinner)
        
        footerSpinner.center = footerSpinner.superview!.center
        footerSpinner.startAnimating()
        
        tableView.tableFooterView = footerView
    }
    
    private func hideCountryTableFooterView() {
        tableView.tableFooterView = nil
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
        
        if country.descriptionSmall.isEmpty {
            return defaultCountryCellHeight
        } else {
            return heightForCountryWithSmallDescription(country: country)
        }
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
        
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
                countriesRepo.getNextPageOfCountriesList(completionHandler: updateTable)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CountryDetails" {
            if let destination = segue.destination as? CountryDetailsViewController,
                let initiatorCell = sender as? CountryCell,
                let countryIndex = tableView.indexPath(for: initiatorCell)?.row {
                
                let country = countriesRepo.countries[countryIndex]
                destination.country = country
            }
        }
    }
    
    private func heightForCountryWithSmallDescription(country: Country) -> CGFloat {
        let description = country.descriptionSmall as NSString
        
        let attributes = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: CountriesListConstants.DescriptionFontSize)]
        
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
}

