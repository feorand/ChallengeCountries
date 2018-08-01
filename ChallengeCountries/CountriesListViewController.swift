//
//  ViewController.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 30.07.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if countriesRepo.countries.count != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
            let country = countriesRepo.countries[indexPath.row]
            cell.textLabel?.text = country.name
            cell.detailTextLabel?.text = country.descriptionSmall
            cell.imageView?.image = UIImage(data: country.flag!)
            return cell
        }
        
        return UITableViewCell()
    }
}

