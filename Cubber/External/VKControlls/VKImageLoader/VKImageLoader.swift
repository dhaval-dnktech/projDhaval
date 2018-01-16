//
//  VKImageLoader.swift
//  BusinessCard
//
//  Created by Vyas Kishan on 27/12/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

class VKImageLoader: UIView , UIScrollViewDelegate {
    
   
    //MARK: PROPERTIES
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    
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
            self.activityIndicatorView.startAnimating()
            imageView.sd_setImage(with: imageUrl.convertToUrl() as URL!, completed: { (image, error, cacheType, imageURL) in
                if image == nil { self.imageView.image = imagePlaceholder }
                else { self.imageView.image = image! }
                self.activityIndicatorView.stopAnimating()
            })
//            imageView.sd_setImage(with: imageUrl.convertToUrl() as URL!, placeholderImage: imagePlaceholder, options: SDWebImageOptions.retryFailed, progress:
//                { (receivedSize, expectedSize) in
//                    self.activityIndicatorView.startAnimating()
//                })
//                
//            { (image, error, cacheType, imageURL) in
//                if image == nil { self.imageView.image = imagePlaceholder }
//                else { self.imageView.image = image! }
//                self.activityIndicatorView.stopAnimating()
//            }
            
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapZoomAction))
            doubleTap.numberOfTapsRequired = 2
           scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = 4.0
            scrollView.delegate = self
            scrollView.isPagingEnabled = true
            scrollView.zoomScale = 1
            scrollView.addGestureRecognizer(doubleTap)
        }
    }
    func doubleTapZoomAction() {
        
         //scrollView.setZoomScale(5.0, animated: false)
        if (scrollView.zoomScale == scrollView.minimumZoomScale)
        { scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true) }
        else { scrollView.setZoomScale(1.0, animated: true) }
    }
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
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
