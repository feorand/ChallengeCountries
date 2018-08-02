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
        switch viewController {
        case is CountriesListViewController:
            changeToBlack()
        case is CountryDetailsViewController:
            changeToWhite()
        default:
            print("Error: NavagationController - unknown ViewController type pushed: \(type(of: viewController))")
        }
    }
    
    private func changeToWhite() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.tintColor = .white
        navigationBar.barStyle = .black
    }

    private func changeToBlack() {
        navigationBar.barStyle = .default
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
    }
}
