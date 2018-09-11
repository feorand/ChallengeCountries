//
//  CountryCell.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 01.08.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // Accessory button is first of buttons in a cell subviews
    private var accessoryButton: UIButton? {
        return subviews.first(where: { $0 is UIButton }) as? UIButton
    }
    
    var country: Country? { didSet { updateCell(with: country )}}
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        accessoryButton?.center.y = flagImageView.center.y
    }
    
    private func updateCell(with country: Country?) {
        guard let country = country else { return }
    
        if let flagData = country.flag.image {
            flagImageView.image = UIImage(data: flagData)
        }
        
        nameLabel.text = country.name
        capitalLabel.text = country.capital
        descriptionLabel.text = country.countryDescriptionSmall
    }
}
