//
//  ImageSliderView.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 08.08.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class ImageSliderView: UIView {
    
    private var imageView: UIImageView!
    private var activityIndicator: UIActivityIndicatorView!
    private var currentImageIndex = 0
    
    var images: [UIImage] = [] {
        didSet {
            if imageView.image == nil && currentImageIndex == 0 {
                imageView.image = images[0]
                isIndicatorAnimating = false
            }
        }
    }
    
    var isIndicatorAnimating: Bool {
        get {
            return activityIndicator.isAnimating
        }
        
        set {
            if newValue {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    private func initSubviews() {
        imageView = UIImageView(frame: bounds)
        addSubview(imageView)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.center = center
        isIndicatorAnimating = true
        addSubview(activityIndicator)
        
        let leftSwipeGestureRecognizer =
            UISwipeGestureRecognizer(target: self,
                                     action: #selector(showNextImage))
        leftSwipeGestureRecognizer.direction = .left
        addGestureRecognizer(leftSwipeGestureRecognizer)
        
        let rightSwipeGestureRecognizer =
            UISwipeGestureRecognizer(target: self,
                                     action: #selector(showPreviousImage))
        rightSwipeGestureRecognizer.direction = .right
        addGestureRecognizer(rightSwipeGestureRecognizer)
    }
    
    @objc private func showNextImage() {
        guard currentImageIndex < images.count - 1  else { return }
        
        let new = UIImageView(frame: imageView.frame)
        new.image = imageView.image
        addSubview(new)
        sendSubview(toBack: new)
        
        imageView.frame.origin.x += imageView.frame.width
        
        currentImageIndex += 1
        imageView.image = images[currentImageIndex]
        
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.frame.origin.x -= self.imageView.frame.width
            new.frame.origin.x -= new.frame.width
        }, completion: { completed in
            new.removeFromSuperview()
        })
    }
    
    @objc private func showPreviousImage() {
        guard currentImageIndex > 0  else { return }
        
        let substituteImageView = UIImageView(frame: imageView.frame)
        substituteImageView.image = imageView.image
        addSubview(substituteImageView)
        bringSubview(toFront: substituteImageView)
        
        imageView.frame.origin.x -= imageView.frame.width
        
        currentImageIndex -= 1
        imageView.image = images[currentImageIndex]
        
        UIView.animate(withDuration: 0.5, animations: {
            substituteImageView.frame.origin.x += substituteImageView.frame.width
            self.imageView.frame.origin.x += self.imageView.frame.width
        }, completion: { completed in
            substituteImageView.removeFromSuperview()
        })
    }

}
