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
    var accessoryButton: UIButton? {
        return subviews.first(where: { $0 is UIButton }) as? UIButton
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        accessoryButton?.center.y = flagImageView.center.y
    }
}
