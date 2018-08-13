//
//  ImageSliderView.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 08.08.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

struct PageControlConstants {
    static let CirclesHeightWidth: CGFloat = 6
    static let BottomOffset: CGFloat = 8
    static let Spacing: CGFloat = 5
}

class ImageSliderView: UIView {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var pageControl: UIPageControl!
    
    var images: [UIImage] = [] {
        didSet {
            if imageView.image == nil {
                imageView.image = images[0]
                isIndicatorAnimating = false
            }
            
            pageControl.numberOfPages = images.count
            updatePageControl()
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
        
        pageControl = UIPageControl(frame: .zero)
        pageControl.center.x = center.x
        pageControl.frame = pageControl.frame.offsetBy(dx: 0, dy: bounds.maxY - PageControlConstants.CirclesHeightWidth - PageControlConstants.BottomOffset)
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.4)
        pageControl.currentPageIndicatorTintColor = UIColor.white
        addSubview(pageControl)
        
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
        guard pageControl.currentPage < pageControl.numberOfPages - 1  else { return }
        
        let new = UIImageView(frame: imageView.frame)
        new.image = imageView.image
        addSubview(new)
        sendSubview(toBack: new)
        
        imageView.frame.origin.x += imageView.frame.width
        
        pageControl.currentPage += 1
        imageView.image = images[pageControl.currentPage]
        
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.frame.origin.x -= self.imageView.frame.width
            new.frame.origin.x -= new.frame.width
        }, completion: { completed in
            new.removeFromSuperview()
        })
    }
    
    @objc private func showPreviousImage() {
        guard pageControl.currentPage > 0 else { return }
        
        let substituteImageView = UIImageView(frame: imageView.frame)
        substituteImageView.image = imageView.image
        addSubview(substituteImageView)
        bringSubview(toFront: substituteImageView)
        bringSubview(toFront: pageControl)
        
        imageView.frame.origin.x -= imageView.frame.width
        
        pageControl.currentPage -= 1
        imageView.image = images[pageControl.currentPage]
        
        UIView.animate(withDuration: 0.5, animations: {
            substituteImageView.frame.origin.x += substituteImageView.frame.width
            self.imageView.frame.origin.x += self.imageView.frame.width
        }, completion: { completed in
            substituteImageView.removeFromSuperview()
        })
    }
    
    private func updatePageControl() {
        let defaultControlSpacing: CGFloat = 7 // Apple default spacing
        
        let spacingFactor = PageControlConstants.Spacing / defaultControlSpacing
        let reverseSpacingFactor = CGFloat(1) / spacingFactor
        
        pageControl.transform = CGAffineTransform(scaleX: spacingFactor, y: spacingFactor)
        for dot in pageControl.subviews {
            dot.transform = CGAffineTransform(scaleX: reverseSpacingFactor, y: reverseSpacingFactor)
        }
    }
}
