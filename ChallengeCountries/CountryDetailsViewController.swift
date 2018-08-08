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
    
    @IBOutlet weak var imageSlider: ImageSliderView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var continentLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    
    var countriesNavigationController: NavigationController {
        guard let result = navigationController as? NavigationController else {
            fatalError("Missing View Controller - NavigationController")
        }
        return result
    }
    
    var country: Country!
    
    private var isImageDownloadComplete = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView(with: country)
        
        for url in country.photosUrls {
            CountriesRepo.getPhoto(fromUrl: url) { photoData in
                if let data = photoData, let image = UIImage(data: data) {
                    if !self.isImageDownloadComplete {
                        self.isImageDownloadComplete = true
                        self.countriesNavigationController.changeToWhite()
                    }
                    
                    self.imageSlider.images.append(image)
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
        
        if isImageDownloadComplete {
            if  scrollView.contentOffset.y > imageSlider.frame.height + edgeOffset ||
                scrollView.contentOffset.y < edgeOffset {
                countriesNavigationController.changeToBlack()
            } else {
                countriesNavigationController.changeToWhite()
            }
        }
    }
}
