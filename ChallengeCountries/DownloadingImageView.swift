//
//  DownloadingImageView.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 06.08.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class DownloadingImageView: UIView {
    var imageView: UIImageView!
    var activityIndicator: UIActivityIndicatorView!
    
    var backgroundImage: UIImage? = nil {
        didSet {
            if image == nil {
                imageView?.image = backgroundImage
            }
        }
    }
    
    var image: UIImage? = nil {
        didSet {
            imageView?.image = image
            activityIndicator.stopAnimating()
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
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.center = center
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        addSubview(activityIndicator)
        //bringSubview(toFront: activityIndicator)
    }
}
