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
            if imageView.image == nil && currentImageIndex == 0 {
                imageView.image = images[0]
            }
        }
    }
    
    private var currentImageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    @objc @IBAction private func swipe(gestureRecognizer: UISwipeGestureRecognizer) {
        switch gestureRecognizer.direction {
        case .left:
            showNextImage()
        case .right:
            showPreviousImage()
        default:
            print("Image Selection: unknown swipe")
        }
    }
    
    private func showNextImage() {
        guard currentImageIndex < images.count - 1  else { return }
        
        let backgroundImageView = UIImageView(frame: imageView.frame)
        backgroundImageView.image = imageView.image
        view.addSubview(backgroundImageView)
        view.sendSubview(toBack: backgroundImageView)
        
        imageView.frame.origin.x += imageView.frame.width
        
        currentImageIndex += 1
        imageView.image = images[currentImageIndex]
        
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.frame.origin.x -= self.imageView.frame.width
        }, completion: { completed in
            backgroundImageView.removeFromSuperview()
        })
    }
    
    private func showPreviousImage() {
        guard currentImageIndex > 0  else { return }
        
        let foregroundImageView = UIImageView(frame: imageView.frame)
        foregroundImageView.image = imageView.image
        view.addSubview(foregroundImageView)
        view.bringSubview(toFront: foregroundImageView)
        
        currentImageIndex -= 1
        imageView.image = images[currentImageIndex]
        
        UIView.animate(withDuration: 0.5, animations: {
            foregroundImageView.frame.origin.x += foregroundImageView.frame.width
        }, completion: { completed in
            foregroundImageView.removeFromSuperview()
        })
    }
}
