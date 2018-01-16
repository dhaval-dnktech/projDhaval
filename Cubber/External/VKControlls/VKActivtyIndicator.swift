//
//  VKActivtyIndicator.swift
//  Cubber
//
//  Created by Vyas Kishan on 18/07/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit
import ImageIO
import ModelIO

class VKActivtyIndicator: UIView {

    //MARK: PROPERTIES
    var VKActivtyIndicatorSize: CGSize!
    var titleLabel: UILabel!;
    var imageView:UIImageView!;
    //MARK: VIEW METHODS
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String) {
        let frame: CGRect = UIScreen.main.bounds
        super.init(frame : frame)
        self.showIndicator(title)
    }
    
    fileprivate func showIndicator(_ title: String) {
        self.isOpaque = false;
        
        VKActivtyIndicatorSize = CGSize(width: 70, height: 70);
        
        // BG View
        let view: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 80, height: 80));
        view.layer.cornerRadius = 10;
        view.backgroundColor = RGBCOLOR(240, g: 240, b: 240, alpha: 1)
        view.setShadowDrop(view)
        self.backgroundColor = RGBCOLOR(0 , g: 0, b: 0, alpha: 0.4)
        self.addSubview(view);
        
        //ACTIVITY INDICATOR
        let activityIndicator: UIActivityIndicatorView =  UIActivityIndicatorView.init(frame: CGRect(x: 0, y: 0, width: 60, height: 60));
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge;
        activityIndicator.color = COLOUR_ORANGE;
        activityIndicator.color = .black;
        activityIndicator.startAnimating();
        activityIndicator.center = view.center
        
       /* var center: CGPoint = activityIndicator.center;
        center.x = view.center.x;
        activityIndicator.center = center;*/
        
        imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        imageView.center = view.center
        self.setStaticImage()
       // imageView.loadGif(name: "simplespin")
        view.addSubview(imageView);

        
      //  view.addSubview(activityIndicator);
        
        view.center = self.center;
        
        self.titleLabel = UILabel.init(frame: CGRect(x: 0, y: activityIndicator.frame.maxY + 5, width: view.frame.width, height: 20));
        self.titleLabel.text = title;
        self.titleLabel.textColor = COLOUR_ORANGE;
       // self.titleLabel.textColor = .white;
        self.titleLabel.font = UIFont.systemFont(ofSize: 15)
        self.titleLabel.textAlignment = NSTextAlignment.center;
       // view.addSubview(self.titleLabel);
    }
    
    func setStaticImage() {
        
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "simplespin", withExtension: "gif")!)
        
        guard let source = CGImageSourceCreateWithData(imageData as! CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return
        }
        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        
        for i in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        imageView.animationImages = images
        imageView.animationDuration = 1.5
        imageView.startAnimating()
       
    }
    
    override func draw(_ rect: CGRect) {
//        let context: CGContext = UIGraphicsGetCurrentContext()!;
//        UIGraphicsPushContext(context);
//        context.setFillColor(gray: 0.0, alpha: 0.85);
//        
//        //Center Activty Indicator
//        let allRect: CGRect = self.bounds;
//        // Draw rounded Backgroud Rect
//        let boxRect: CGRect = CGRect(x: round((allRect.size.width - VKActivtyIndicatorSize.width) / 2) + 0.0, y: round((allRect.size.height - VKActivtyIndicatorSize.height) / 2) + 0.0, width: VKActivtyIndicatorSize.width, height: VKActivtyIndicatorSize.height);
//        let radius: CGFloat = 10;
//
//        context.beginPath();
//        
//        //CGContextMoveToPoint(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect));
//        context.move(to: CGPoint(x: boxRect.minX + radius, y: boxRect.minY));
//        
//        //CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMinY(boxRect) + radius, radius, 3 * CGFloat(M_PI / 2), 0, 0);
//        context.addArc(center: CGPoint(x: boxRect.maxX - radius, y: boxRect.minY + radius), radius: radius, startAngle: 3 * CGFloat(M_PI / 2), endAngle: 0, clockwise: false)
//        
//        //CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMaxY(boxRect) - radius, radius, 0, CGFloat(M_PI / 2), 0);
//        context.addArc(center: CGPoint(x:boxRect.maxX - radius, y:boxRect.maxY - radius), radius: 0, startAngle: 0, endAngle: CGFloat(M_PI / 2), clockwise: false)
//        
//        //CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMaxY(boxRect) - radius, radius, CGFloat(M_PI / 2), CGFloat(M_PI), 0);
//        context.addArc(center: CGPoint(x:boxRect.minX + radius, y:boxRect.maxY - radius), radius: radius, startAngle: CGFloat(M_PI / 2), endAngle: CGFloat(M_PI), clockwise: false)
//        
//        //CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect) + radius, radius, CGFloat(M_PI), 3 * CGFloat(M_PI / 2), 0);
//        context.addArc(center: CGPoint(x:boxRect.minX + radius, y:boxRect.minY + radius), radius: radius, startAngle: CGFloat(M_PI), endAngle: 3 * CGFloat(M_PI / 2), clockwise: false)
//
//        context.closePath();
//        context.fillPath();
//        
//        UIGraphicsPopContext();
    }
    

}
