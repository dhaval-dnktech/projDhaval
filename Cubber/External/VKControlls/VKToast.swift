//
//  VKToast.swift
//  Cubber
//
//  Created by Vyas Kishan on 23/07/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

public enum VKTOAST_TYPE: Int {
    case SUCCESS
    case FAILURE
    case QUESTION
    case WARNING
}

import UIKit

@objc protocol VKToastDelegate {
    @objc optional func vKToastYesAction()
    @objc optional func vKToastNoAction()
}

class VKToast: UIView, UIGestureRecognizerDelegate {
    
    //MARK: PROPERTIES
    @IBOutlet var delegate: VKToastDelegate!
    
    //MARK: CONSTANT
    internal let TAG_SUPPER: Int = 10000
    internal let MIN_HEIGHT: CGFloat = 50
    internal let MIN_WIDTH: CGFloat = 100
    internal let LEADING_TRAILING: CGFloat = 50
    internal let TOP_BOTTOM: CGFloat = 100
    internal let MESSAGE_PADDING: CGFloat = 20
    fileprivate let TOAST_COLOUR_SUCCESS = RGBCOLOR(114, g: 187, b: 82) //Green
    fileprivate let TOAST_COLOUR_FAILURE = RGBCOLOR(249, g: 72, b: 88) //Red
    fileprivate let TOAST_COLOUR_WARNING = RGBCOLOR(250, g: 127, b: 39) //Orange
    fileprivate let TOAST_COLOUR_QUESTION = RGBCOLOR(250, g: 103, b: 67) //Orange
    
    //MARK: VARIABLES
    static let sharedInstance = VKToast()
    var viewBG = UIView.init()
    
    //MARK: VIEW METHODS
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    
    init(message: String, toastType: VKTOAST_TYPE) {
        super.init(frame: CGRect.zero)
        self.showMessage(message, toastType: toastType)
    }
    
    class func showToast(_ message: String, toastType: VKTOAST_TYPE) {
        sharedInstance.showMessage(message, toastType: toastType)
    }
    
    fileprivate func showMessage(_ message: String, toastType: VKTOAST_TYPE) {
        let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let frame: CGRect = UIScreen.main.bounds
        self.frame = frame
        obj_AppDelegate.navigationController.view.addSubview(self)
        
        self.alpha = 0
        self.tag = TAG_SUPPER
        self.backgroundColor = RGBCOLOR(0, g: 0, b: 0, alpha: 0.4)
        
        let gestureTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(btnCloseAction))
        self.isUserInteractionEnabled = true
        self.isMultipleTouchEnabled = true
        gestureTap.delegate = self
        self.addGestureRecognizer(gestureTap)
        
        let textFont: UIFont = UIFont.systemFont(ofSize: 14)
        
        let textSize: CGSize = message.textSize(textFont)
        var textWidth: CGFloat = textSize.width + MESSAGE_PADDING
        var textHeight: CGFloat = textSize.height + MESSAGE_PADDING
        if textWidth > self.frame.width {
            textWidth = self.frame.width - LEADING_TRAILING
            textHeight = message.textHeight(textWidth, textFont: textFont)
            textHeight = textHeight > self.frame.height ? textHeight - TOP_BOTTOM : textHeight
            textHeight += MESSAGE_PADDING
        }
        else if textWidth < MIN_WIDTH {
            textWidth = MIN_WIDTH
            textHeight = message.textHeight(textWidth, textFont: textFont)
            textHeight = textHeight > self.frame.height ? textHeight - TOP_BOTTOM : textHeight
            textHeight += MESSAGE_PADDING
        }
        else if textHeight > self.frame.height {
            textHeight = self.frame.height - TOP_BOTTOM
            textWidth = message.textWidth(textHeight, textFont: textFont)
            textWidth = textWidth > self.frame.height ? textWidth - LEADING_TRAILING : textHeight
            textWidth += MESSAGE_PADDING
        }
        
        textWidth += SIZE_EXTRA_TEXT
        textHeight += SIZE_EXTRA_TEXT
        
        textWidth = ceil(textWidth)
        textHeight = ceil(textHeight)
        
        let velocity: CGFloat = 10;
        let duration: TimeInterval = 0.8;
        let damping: CGFloat = 0.5;    //usingSpringWithDamping : 0 - 1
        
        // BG View
        let centerX: CGFloat = (self.frame.width / 2) - (textWidth / 2)
        
        if toastType == VKTOAST_TYPE.QUESTION {
            let heightTextMax: CGFloat = 45.0
            textHeight = textHeight < heightTextMax ? heightTextMax : textHeight
            let heightFooter: CGFloat = 45
            let widthButton = textWidth / 2
            let spacing: CGFloat = 0.5
            var yOrigin: CGFloat = MESSAGE_PADDING / 2
            
            self.viewBG = UIView.init(frame: CGRect(x: centerX, y: 0, width: textWidth, height: textHeight + MESSAGE_PADDING + heightFooter));
            self.viewBG.layer.cornerRadius = 10;
            self.viewBG.backgroundColor = TOAST_COLOUR_QUESTION
            self.addSubview(self.viewBG);
            self.viewBG.clipsToBounds = true
            
            let lblMessage: UILabel = UILabel.init(frame: CGRect(x: 0, y: yOrigin, width: self.viewBG.frame.width - MESSAGE_PADDING, height: textHeight))
            lblMessage.text = message
            lblMessage.font = textFont
            lblMessage.textColor = UIColor.white
            lblMessage.textAlignment = NSTextAlignment.center
            lblMessage.numberOfLines = 0
            self.viewBG.addSubview(lblMessage)
            lblMessage.center = CGPoint(x: self.viewBG.frame.width / 2, y: lblMessage.center.y)
            
            yOrigin = (MESSAGE_PADDING / 2) + lblMessage.frame.maxY
            let btnYes: UIButton = DesignModel.createButton(CGRect(x: 0, y: yOrigin, width: widthButton - spacing, height: heightFooter), title: "YES", tag: 0, titleColor: UIColor.white, titleFont: textFont, textAlignment: UIControlContentHorizontalAlignment.center, bgColor: COLOUR_GREEN, borderWidth: 0, borderColor: nil, cornerRadius: 0)
            btnYes.addTarget(self, action: #selector(btnYesAction), for: UIControlEvents.touchUpInside)
            self.viewBG.addSubview(btnYes)
            
            let btnNo: UIButton = DesignModel.createButton(CGRect(x: btnYes.frame.maxX + spacing, y: yOrigin, width: widthButton, height: heightFooter), title: "NO", tag: 0, titleColor: UIColor.white, titleFont: textFont, textAlignment: UIControlContentHorizontalAlignment.center, bgColor: COLOUR_GREEN, borderWidth: 0, borderColor: nil, cornerRadius: 0)
            btnNo.addTarget(self, action: #selector(btnNoAction), for: UIControlEvents.touchUpInside)
            self.viewBG.addSubview(btnNo)
            
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.alpha = 1
                self.viewBG.center = self.center
                }, completion: nil)
        }
        else {
            self.viewBG = UIView.init(frame: CGRect(x: centerX, y: 0, width: textWidth, height: textHeight));
            self.viewBG.layer.cornerRadius = 10;
            self.viewBG.backgroundColor = toastType == VKTOAST_TYPE.SUCCESS ? TOAST_COLOUR_SUCCESS : toastType == VKTOAST_TYPE.WARNING ? TOAST_COLOUR_WARNING : TOAST_COLOUR_FAILURE
            self.addSubview(self.viewBG);
            self.viewBG.clipsToBounds = true
            
            let lblMessage: UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.viewBG.frame.width - MESSAGE_PADDING, height: self.viewBG.frame.height - MESSAGE_PADDING))
            lblMessage.text = message
            lblMessage.font = textFont
            lblMessage.textColor = UIColor.white
            lblMessage.textAlignment = NSTextAlignment.center
            lblMessage.numberOfLines = 0
            self.viewBG.addSubview(lblMessage)
            lblMessage.center = CGPoint(x: self.viewBG.frame.width / 2, y: self.viewBG.frame.height / 2)
            
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.alpha = 1
                self.viewBG.center = self.center
            }) { (finished) in
                UIView.animateKeyframes(withDuration: 0.5, delay: duration, options: UIViewKeyframeAnimationOptions.beginFromCurrentState, animations: {
                    var frame = self.viewBG.frame
                    frame.origin.y = self.frame.maxY + frame.height
                    self.viewBG.frame = frame
                    }, completion: { (finished) in
                        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { self.alpha = 0 }, completion:{ (finished) in self.removeFromSuperview() })
                })
            }
        }
    }
    
    internal func btnCloseAction() {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, options: UIViewKeyframeAnimationOptions.beginFromCurrentState, animations: {
            var frame = self.viewBG.frame
            frame.origin.y = self.frame.maxY + frame.height
            self.viewBG.frame = frame
            }, completion: { (finished) in
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { self.alpha = 0 }, completion:{ (finished) in self.removeFromSuperview() })
        })
    }
    
    internal func btnYesAction() {
        self.btnCloseAction()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.8 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { self.delegate.vKToastYesAction!() }
    }
    
    internal func btnNoAction() {
        self.btnCloseAction()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.8 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { self.delegate.vKToastNoAction!() }
    }
    
    //MARK: UI GESTURE RRECOGNIZER
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let view: UIView = touch.view!
        if view.tag == TAG_SUPPER { return false }
        return true
    }
}
