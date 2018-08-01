//
//  ViewController.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 30.07.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class CountriesListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let countriesRepo = CountriesRepo()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        countriesRepo.updateCountries(completionHandler: {
            
        })
    }
}

extension CountriesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

