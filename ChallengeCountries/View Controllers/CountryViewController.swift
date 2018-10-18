//
//  CountryDetailsViewController.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 01.08.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class CountryViewController: UITableViewController {
    
    @IBOutlet weak var imageSlider: ImageSliderView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var continentLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var countriesRepo: CountriesRepo?
    var country: Country?
        
    private var atLeastOneImageLoaded: Bool {
        return !imageSlider.images.isEmpty
    }
    
    override var navigationController: CountriesNavigationController? {
        return super.navigationController as? CountriesNavigationController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        moveTableToTop()
        hideLastSeparator()
        
        if let country = country {
            updateView(with: country)
            countriesRepo?.photos(for: country, eachCompletionHandler: showPhoto)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !atLeastOneImageLoaded{
            navigationController?.setStyle(to: .opaque)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0, _):
            return imageSlider.frame.height
        case (1, 0):
            return 58
        case (1, _):
            return 45
        case (2, 0):
            descriptionLabel.sizeToFit()
            return descriptionLabel.frame.height + CountryDetailsSettings.descriptionOffset
        default:
            return 0
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setStyle(dependingOn: scrollView)
    }
    
    private func moveTableToTop() {
        tableView.contentInset = UIEdgeInsets(top: CountryDetailsSettings.topInset, left: 0, bottom: 0, right: 0)
    }
    
    private func hideLastSeparator() {
        tableView.tableFooterView = UIView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: tableView.frame.size.width,
                                                         height: 1))
    }
    
    private func setStyle(dependingOn scrollView: UIScrollView) {
        //Nothing to inspect while no image loaded
        guard atLeastOneImageLoaded else { return }
        
        // Change style of Navigation bar depending on Scroll offset
        let edgeOffset = CountryDetailsSettings.topInset
        
        if  scrollView.contentOffset.y > imageSlider.frame.height + edgeOffset ||
            scrollView.contentOffset.y < edgeOffset {
            navigationController?.setStyle(to: .opaque)
        } else {
            navigationController?.setStyle(to: .transparent)
        }
    }

    private func updateView(with country: Country?) {
        nameLabel?.text = country?.name
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
    
    private func showPhoto(_ photo: DownloadablePhoto) {
        if let image = image(from: photo.image) {
            if !atLeastOneImageLoaded {
                navigationController?.setStyle(to: .transparent)
            }
            
            imageSlider.images.append(image)
        }
    }
}
