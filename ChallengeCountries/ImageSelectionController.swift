//
//  ImageSelectionController.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 06.08.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class ImageSelectionController: UIViewController {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var photosUrls: [String] = []
    var flag: UIImage? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updatePhotos()
    }
    
    private func updatePhotos() {
        photoView.image = flag
        
        CountriesRepo.getPhoto(fromUrl: photosUrls[0]) { photoData in
            if let data = photoData {
                self.photoView.image = UIImage(data: data)
                self.activityIndicator.stopAnimating()
            }
        }
    }
}
