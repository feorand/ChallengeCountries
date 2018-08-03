//
//  NavigationControllerDelegate.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 02.08.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is CountriesListViewController {
            changeToBlack()
        }
    }
    
    func changeToWhite() {
        navigationBar.barStyle = .black
        navigationBar.tintColor = .white
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }

    func changeToBlack() {
        navigationBar.barStyle = .default
        navigationBar.tintColor = nil
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        navigationBar.shadowImage = nil
    }
}
