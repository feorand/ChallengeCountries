//
//  NavigationControllerDelegate.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 02.08.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class CountriesNavigationController: UINavigationController, UINavigationControllerDelegate {
    enum CountriesNavigationControllerStyle {
        case opaque, transparent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is CountriesListViewController {
            setStyle(to: .opaque)
        } else if viewController is CountryDetailsViewController {
            setStyle(to: .transparent)
        }
    }
    
    func setStyle(to style: CountriesNavigationControllerStyle) {
        switch style {
        case .opaque:
            setStyleOpaque()
        case .transparent:
            setStyleTransparent()
        }
    }
    
    private func setStyleOpaque() {
        navigationBar.barStyle = .default
        navigationBar.tintColor = nil
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        navigationBar.setBackgroundImage(nil, for: .default)
        navigationBar.shadowImage = nil
    }
    
    private func setStyleTransparent() {
        navigationBar.barStyle = .black
        navigationBar.tintColor = .white
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }

}
