//
//  CountryDetailsViewController.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 01.08.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class CountryViewController: UIViewController {
    
    @IBOutlet weak var imageSlider: ImageSliderView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var continentLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    
    var countriesRepo: CountriesRepo?
    //var countryIndex: Int?
    var countryIndexPath: IndexPath?
    
    var country: Country? {
        if let indexPath = countryIndexPath {
            return countriesRepo?.country(at: indexPath)
        } else {
            return nil
        }
    }
    
    private var atLeastOneImageLoaded = false
    
    override var navigationController: CountriesNavigationController? {
        return super.navigationController as? CountriesNavigationController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView(with: country)
        countriesRepo?.getPhotosForCountry(at: countryIndexPath, eachCompletionHandler: showPhotoFromData)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !atLeastOneImageLoaded{
            navigationController?.setStyle(to: .opaque)
        }
    }
    
    private func updateView(with country: Country?) {
        nameLabel.text = country?.name
        capitalLabel.text = country?.capital
        populationLabel.text = "\(country?.population ?? 0)"
        continentLabel.text = country?.continent
        descriptionLabel.text = country?.countryDescription
    }
    
    private func image(from data: Data?) -> UIImage? {
        if let data = data, let image = UIImage(data: data) {
            return image
        } else {
            return nil
        }
    }
    
    private func showPhotoFromData(data: Data?) {
        if let image = image(from: data) {
            if !atLeastOneImageLoaded {
                atLeastOneImageLoaded = true
                navigationController?.setStyle(to: .transparent)
            }
            
            imageSlider.images.append(image)
        }
    }
}

extension CountryViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setStyle(dependingOn: scrollView)
    }
    
    private func setStyle(dependingOn scrollView: UIScrollView) {
        //Nothing to inspect while no image loaded
        guard atLeastOneImageLoaded else { return }
        
        // Change style of Navigation bar depending on Scroll offset
        let edgeOffset = CountryDetailsSettings.scrollViewOffset +
            CountryDetailsSettings.viewOffset
        
        if  scrollView.contentOffset.y > imageSlider.frame.height + edgeOffset ||
            scrollView.contentOffset.y < edgeOffset {
            navigationController?.setStyle(to: .opaque)
        } else {
            navigationController?.setStyle(to: .transparent)
        }
    }
}
