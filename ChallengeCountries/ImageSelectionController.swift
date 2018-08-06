//
//  ImageSelectionController.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 06.08.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class ImageSelectionController: UIViewController {
    
    @IBOutlet weak var photoView: DownloadingImageView!
    
    var photosUrls: [String] = []
    var flag: UIImage? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updatePhotos()
    }
    
    private func updatePhotos() {
        photoView.backgroundImage = flag
        
        CountriesRepo.getPhoto(fromUrl: photosUrls[0]) { photoData in
            if let data = photoData {
                self.photoView.image = UIImage(data: data)
            }
        }
    }
    
    @objc @IBAction private func swipe(gestureRecognizer: UISwipeGestureRecognizer) {
        switch gestureRecognizer.direction {
        case .left:
            print("Swipe - Left")
        case .right:
            print("Swipe - right")
        default:
            print("Image Selection: unknown swipe")
        }
    }
}
