//
//  CountryDetailsViewController.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 01.08.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

struct CountryDetailsConstants {
    static let ScrollViewOffset: CGFloat = -64
    static let ViewOffset: CGFloat = -64
}

class CountryDetailsViewController: UIViewController {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var continentLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var aboutLabel: UILabel!

    var country: Country!
    
    var countriesNavigationController: NavigationController? {
        return navigationController as? NavigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView(with: country)
        
        if let flagData = country.flag {
            self.photoView.image = UIImage(data: flagData)
            self.countriesNavigationController?.changeToWhite()
        }
        
        CountriesRepo.getPhoto(fromUrl: country.photosUrls[0]) { photoData in
            if let data = photoData {
                self.photoView.image = UIImage(data: data)
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func updateView(with Country: Country?) {
        guard let country = country else { return }
        
        nameLabel.text = country.name
        capitalLabel.text = country.capital
        populationLabel.text = "\(country.population)"
        continentLabel.text = country.continent
        descriptionLabel.text = country.description
    }
}

extension CountryDetailsViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Change style of Navigation bar depending on Scroll offset
        let edgeOffset = CountryDetailsConstants.ScrollViewOffset +
            CountryDetailsConstants.ViewOffset
        
        if  scrollView.contentOffset.y > photoView.frame.height + edgeOffset ||
            scrollView.contentOffset.y < edgeOffset {
            countriesNavigationController?.changeToBlack()
        } else {
            countriesNavigationController?.changeToWhite()
        }
    }
}
