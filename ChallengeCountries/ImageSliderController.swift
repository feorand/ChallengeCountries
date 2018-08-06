//
//  ImageSelectionController.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 06.08.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class ImageSliderController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var images: [UIImage] = [] {
        didSet {
            imageView.image = images[0]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
