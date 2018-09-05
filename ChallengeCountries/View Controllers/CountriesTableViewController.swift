//
//  ViewController.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 30.07.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit
import CoreData

class CountriesTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private let countriesRepo = CountriesRepo()
    
    private var container: NSPersistentContainer? = AppDelegate.sharedPersistenseContainer {
        didSet {
            updateUI()
        }
    }

    var fetchedResultController: NSFetchedResultsController<CountryData>?
    
    var delegate: NSFetchedResultsControllerDelegate? {
        didSet {
            fetchedResultController?.delegate = delegate
            try? fetchedResultController?.performFetch()
        }
    }
    
    private var defaultCountryCellHeight: CGFloat {
        return CountriesTableSettings.topSpacing +
            CountriesTableSettings.flagHeight +
            CountriesTableSettings.bottomSpacing
    }
    
    private func updateUI() {
        if let context = container?.viewContext {
            let request: NSFetchRequest<CountryData> = CountryData.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            
            fetchedResultController = NSFetchedResultsController<CountryData>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            
            fetchedResultController?.delegate = self
            try? fetchedResultController?.performFetch()
            tableView.reloadData()
        }

    }
    
//    func numberOfCountries(in section: Int = 0) -> Int {
//        //return fetchedResultController?.sections?[section].numberOfObjects ?? 0
//        return countriesListData.countries.count
//    }
    
    func country(at indexPath: IndexPath) -> Country? {
        return Country(from: fetchedResultController?.object(at: indexPath))
        //return countriesListData.countries[indexPath.row]
    }

    private lazy var refreshControl: UIRefreshControl = {
        let _refreshControl = UIRefreshControl(frame: CGRect.zero)
        _refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return _refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if countriesRepo.numberOfCountries > 0 {
            countriesListDownloadingComplete()
        } else {
            countriesRepo.firstPage{ [weak self] numberOfCountries in
                self?.countriesListDownloadingComplete()
                self?.insertRows(numberOfNewCountries: numberOfCountries)
                self?.updateUI()
            }
        }
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
    
    private func countriesListDownloadingComplete() {
        tableView.addSubview(self.refreshControl)
        spinner.stopAnimating()
        tableView.separatorStyle = .singleLine
    }
    
    private func insertRows(numberOfNewCountries: Int) {
//        let rowsCount = tableView.numberOfRows(inSection: 0)
//        let indexPaths = (rowsCount ..< rowsCount + numberOfNewCountries)
//            .map { IndexPath(row: $0, section: 0) }
//        tableView.insertRows(at: indexPaths, with: .automatic)
        
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
    
    @objc private func refresh() {
        countriesRepo.clearCountriesList()
        countriesRepo.firstPage{ [weak self] numberOfCountries in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
}

extension CountriesTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Nothing to do when countries haven't loaded yet
        guard countriesRepo.numberOfCountries > 0,
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
        
        let attributes = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: CountriesTableSettings.descriptionFontSize)]
        
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
        return countriesRepo.numberOfCountries
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Nothing to do when countries haven't loaded yet
        guard countriesRepo.numberOfCountries > 0,
            let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell",
                                                     for: indexPath) as? CountryCell else {
                                                        return UITableViewCell()
        }
        
        if let country = country(at: indexPath) {
            cell.country = country
        }
        
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            countriesRepo.nextPage(completionHandler: insertRows)
        }
        
        return cell
    }
}

extension CountriesTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

