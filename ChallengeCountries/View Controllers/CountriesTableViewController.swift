//
//  ViewController.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 30.07.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class CountriesTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let countriesRepo = CountriesRepo()
    
    private lazy var refreshControl: UIRefreshControl = {
        let _refreshControl = UIRefreshControl(frame: CGRect.zero)
        _refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return _refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        getInitialCountriesPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CountryDetails" {
            if let destination = segue.destination as? CountryViewController,
                let initiatorCell = sender as? CountryCell,
                let countryIndexPath = tableView.indexPath(for: initiatorCell) {
                
                destination.countriesRepo = countriesRepo
                destination.country = country(at: countryIndexPath)
            }
        }
    }
    
    private func getInitialCountriesPage() {
        countriesRepo.initialPage{ [weak self] numberOfCountries in
            self?.countriesLoaded()
            self?.tableView.reloadData()
            self?.updateCountryTableFooterView()
        }
    }
    
    private var defaultCountryCellHeight: CGFloat {
        return CountriesTableSettings.topSpacing +
            CountriesTableSettings.flagHeight +
            CountriesTableSettings.bottomSpacing
    }
    
    private var numberOfCountries: Int {
        return countriesRepo.countries.count
    }
    
    private var hasCountries: Bool {
        return numberOfCountries > 0
    }
    
    private func country(at indexPath: IndexPath) -> Country? {
        return countriesRepo.countries[indexPath.row]
    }
    
    private func countriesLoaded() {
        tableView.addSubview(self.refreshControl)
        activityIndicator.stopAnimating()
        tableView.separatorStyle = .singleLine
    }
    
    private func insertRows(numberOfNewCountries: Int) {
        let rowsCount = tableView.numberOfRows(inSection: 0)
        let indexPaths = (rowsCount ..< rowsCount + numberOfNewCountries)
            .map { IndexPath(row: $0, section: 0) }
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    private func updateCountryTableFooterView() {
        if countriesRepo.reachedEnd {
            hideCountryTableFooterView()
        } else {
            showCountryTableFooterView()
        }
    }
    
    private func showCountryTableFooterView() {
        let footerSpinner = UIActivityIndicatorView(style: .gray)
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
    
    @objc private func refresh() {
        countriesRepo.refresh{ [weak self] numberOfCountries in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
}

extension CountriesTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Nothing to do when countries haven't loaded yet
        guard hasCountries,
            let country = country(at: indexPath)
        else {
            return 0
        }
        
        if country.countryDescriptionSmall.isEmpty {
            return defaultCountryCellHeight
        } else {
            return heightForCountryWithSmallDescription(country: country)
        }
    }
    
    private func heightForCountryWithSmallDescription(country: Country) -> CGFloat {
        let description = country.countryDescriptionSmall as NSString
        
        let attributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: CountriesTableSettings.descriptionFontSize)]
        
        let descriptionWidth = view.bounds.width -
            CountriesTableSettings.leftSpacing -
            CountriesTableSettings.rightSpacing
        
        let sizeLimits = CGSize(width: descriptionWidth, height: CGFloat.infinity)
        
        let boundingRect = description
            .boundingRect(with: sizeLimits,
                          options: .usesLineFragmentOrigin,
                          attributes: attributes,
                          context: nil)
        
        let descriptionHeight = boundingRect.height
        
        let cellHeight = CountriesTableSettings.topSpacing +
            CountriesTableSettings.flagHeight +
            CountriesTableSettings.middleSpacing +
            descriptionHeight +
            CountriesTableSettings.bottomSpacing
        
        return cellHeight
    }
}

extension CountriesTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfCountries
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Nothing to do when countries haven't loaded yet
        guard hasCountries,
            let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell",
                                                     for: indexPath) as? CountryCell else {
                                                        return UITableViewCell()
        }
        
        if let country = country(at: indexPath) {
            cell.country = country
        }
        
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            countriesRepo.nextPage() { [weak self] numberOfCountries in
                self?.insertRows(numberOfNewCountries: numberOfCountries)
                self?.updateCountryTableFooterView()
            }
        }
        
        return cell
    }
}
