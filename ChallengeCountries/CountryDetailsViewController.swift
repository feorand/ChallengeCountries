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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var continentLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var imageSelector: UIView!
    var country: Country!
    
    var countriesNavigationController: NavigationController? {
        return navigationController as? NavigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView(with: country)        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Photos" {
            if let destination = segue.destination as? ImageSelectionController {
                destination.photosUrls = country.photosUrls
                
                if let flagData = country.flag {
                    destination.flag = UIImage(data: flagData)
                }
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
        
        if  scrollView.contentOffset.y > imageSelector.frame.height + edgeOffset ||
            scrollView.contentOffset.y < edgeOffset {
            countriesNavigationController?.changeToBlack()
        } else {
            countriesNavigationController?.changeToWhite()
        }
    }
}
