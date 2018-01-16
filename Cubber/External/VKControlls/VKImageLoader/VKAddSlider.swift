//
//  VKImageLoader.swift
//  BusinessCard
//
//  Created by Vyas Kishan on 27/12/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit
class VKAddSlider: UIView {
    
    //MARK: PROPERTIES
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var imageScrollView: ImageScrollView!
    
    
    //MARK: METHODS
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadXIB()
    }
    
    required init(frame: CGRect, image: UIImage?, imageName: String, imageUrl: String, imagePlaceholder: UIImage) {
        super.init(frame: frame)
        self.loadXIB()
        
        if image != nil {
            imageView.image = image
            self.activityIndicatorView.stopAnimating()
        }
        
        else if !imageName.isEmpty {
            imageView.image = UIImage(named: imageName)
            self.activityIndicatorView.stopAnimating()
        }
            
        else if !imageUrl.isEmpty {
            imageView.sd_setImage(with: imageUrl.convertToUrl() as URL!, placeholderImage: imagePlaceholder, options: SDWebImageOptions.progressiveDownload, progress:
                { (receivedSize, expectedSize) in
                    self.activityIndicatorView.startAnimating()
                })
            { (image, error, cacheType, imageURL) in
                if image == nil { self.imageView.image = imagePlaceholder ; self.imageScrollView.display(image: imagePlaceholder) }
                else { self.imageView.image = image! ; self.imageScrollView.display(image: image!) }
                self.activityIndicatorView.stopAnimating()
            }
        }
    }

    fileprivate func loadXIB() {
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(view)
        
        //TOP
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
        
        //LEADING
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0))
        
        //WIDTH
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
        
        //HEIGHT
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
        
        self.layoutIfNeeded()
    }
}
