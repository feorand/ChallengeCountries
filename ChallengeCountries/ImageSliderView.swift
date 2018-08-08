//
//  ImageSliderView.swift
//  ChallengeCountries
//
//  Created by Pavel Prokofyev on 08.08.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

struct ImageIndicatorConstants {
    static let CirclesHeightWidth: CGFloat = 6
    static let BottomOffset: CGFloat = 8
    static let Spacing: CGFloat = 5
}

class ImageSliderView: UIView {
    
    private var imageView: UIImageView!
    private var activityIndicator: UIActivityIndicatorView!
    private var currentImageIndex = 0
    private var imageIndexIndicator: UIView!
    
    private var circlesLayer: CAShapeLayer!
    
    var images: [UIImage] = [] {
        didSet {
            if imageView.image == nil && currentImageIndex == 0 {
                imageView.image = images[0]
                isIndicatorAnimating = false
            }
            
            drawCircles()
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
        
        imageIndexIndicator = UIView(frame: .zero)
        addSubview(imageIndexIndicator)
        
        circlesLayer = CAShapeLayer()
        layer.addSublayer(circlesLayer)
        
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
        bringSubview(toFront: imageIndexIndicator)
        
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
    
    private func drawIndexIndicator() {
        let circlesCount = images.count
        guard circlesCount > 0 else { return }
        
        imageIndexIndicator.frame = getIndexIndicatorFrame()
        
        
        imageIndexIndicator.backgroundColor = .red
        
        setNeedsDisplay(getRedrawRect())
    }
    
    private func getIndexIndicatorFrame() -> CGRect {
        guard images.count > 0 else { return CGRect.zero }
        
        let indicatorWidth =
            ImageIndicatorConstants.CirclesHeightWidth * CGFloat(images.count) +
            ImageIndicatorConstants.Spacing * CGFloat(images.count - 1)
        
        let indicatorHeight = ImageIndicatorConstants.CirclesHeightWidth
        
        let indicatorOriginX = (bounds.width - indicatorWidth) / 2
        
        let indicatorOriginY = bounds.origin.y + bounds.height -
            ImageIndicatorConstants.BottomOffset -
            indicatorHeight
        
        return CGRect(x: indicatorOriginX, y: indicatorOriginY,
            width: indicatorWidth, height: indicatorHeight)
    }
    
    private func getRedrawRect() -> CGRect {
        return CGRect(x: bounds.origin.x, y: imageIndexIndicator.frame.origin.y,
            width: bounds.width, height: imageIndexIndicator.frame.height)
    }
    
    private func drawCircles() {
        let boundsRect = getIndexIndicatorFrame()
        
        let circleCenterY = boundsRect.origin.y + boundsRect.height / 2
        
        let path = UIBezierPath()
        
        for index in 0..<images.count {
            let circleCenterX = boundsRect.origin.x +
                ImageIndicatorConstants.CirclesHeightWidth / 2 +
                (ImageIndicatorConstants.CirclesHeightWidth + ImageIndicatorConstants.Spacing) * CGFloat(index)
            
            let center = CGPoint(x: circleCenterX, y: circleCenterY)
            
            let circlePath = UIBezierPath(arcCenter: center,
                radius: ImageIndicatorConstants.CirclesHeightWidth / 2,
                startAngle: 0,
                endAngle: CGFloat.pi * 2,
                clockwise: true)
            
            path.append(circlePath)
        }
        
        path.close()
        
        circlesLayer.path = path.cgPath
        
        let color = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.7)
        circlesLayer.fillColor = color.cgColor
    }
}
