//
//  ViewController.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 30.07.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

struct CountriesListConstants {
    static let FlagImageAspectRatio: CGFloat = 50.0 / 34.0
    static let FlagToViewWidthAspectRatio: CGFloat = 50.0 / 320.0
    
    static let FlagTopSpacing: CGFloat = 16.0
    static let FlagDescriptionSpacing: CGFloat = 11.0
    static let DescriptionBottomSpacing: CGFloat = 16.0
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
        guard countriesRepo.countries.count > 0 else { return 0 }
        
        let country = countriesRepo.countries[indexPath.row]
        let countryDescription = country.descriptionSmall as NSString
        
        let descriptionStringAttributes = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15.0)]
        let descriptionStringSize = CGSize(width: view.bounds.width, height: CGFloat.infinity)
        let descriptionBoundingRect = countryDescription
            .boundingRect(with: descriptionStringSize,
                          options: .usesLineFragmentOrigin,
                          attributes: descriptionStringAttributes,
                          context: nil)
        let descriptionHeight = descriptionBoundingRect.height
        
        let flagHeight = view.bounds.width *
            CountriesListConstants.FlagToViewWidthAspectRatio /
            CountriesListConstants.FlagImageAspectRatio
        
        let cellHeight = CountriesListConstants.FlagTopSpacing +
            flagHeight +
            CountriesListConstants.FlagDescriptionSpacing +
            descriptionHeight +
            CountriesListConstants.DescriptionBottomSpacing
        
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard countriesRepo.countries.count > 0,
            let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell",
                                                     for: indexPath) as? CountryCell else {
            return UITableViewCell()
        }
        
        let country = countriesRepo.countries[indexPath.row]
        
        if let flag = country.flag {
            cell.flagImageView.image = UIImage(data: flag)
        }
        
        cell.nameLabel.text = country.name
        cell.capitalLabel.text = country.capital
        cell.descriptionLabel.text = country.descriptionSmall
        
        return cell
    }
}

