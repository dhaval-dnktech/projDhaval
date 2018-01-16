//
//  OTPView.swift
//  Cubber
//
//  Created by Vyas Kishan on 30/07/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

class TermsAndCondView: UIView, UIWebViewDelegate {
    
    //MARK: PROPERTIES
    @IBOutlet var viewBG: UIView!
    @IBOutlet var webViewTermsAndCond: UIWebView!
    
    //MARK: VARIABLES
    let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var _dictCoupon = typeAliasDictionary()
    fileprivate var isSignUp:Bool = false
    fileprivate var isPrivacyPolicy:Bool = false
    fileprivate var stTitle:String = ""
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var lblLabel: UILabel!
    //MARK: VIEW METHODS
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ dictCoupon: typeAliasDictionary , isSignUP:Bool, isPrivacyPolicy:Bool) {
        
        let frame: CGRect =  CGRect.init(x: 0, y: STATUS_BAR_HEIGHT, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        super.init(frame : frame)
        self.isSignUp = isSignUP
        self.isPrivacyPolicy = isPrivacyPolicy
        _dictCoupon = dictCoupon
        loadXIB()
    }
    
    init(_ dictCoupon: typeAliasDictionary , isSignUP:Bool, isPrivacyPolicy:Bool , title:String) {
        
        let frame: CGRect = CGRect.init(x: 0, y: STATUS_BAR_HEIGHT, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        super.init(frame : frame)
        self.isSignUp = isSignUP
        self.isPrivacyPolicy = isPrivacyPolicy
        self.stTitle = title
        _dictCoupon = dictCoupon
        loadXIB()
    }

    
    fileprivate func loadXIB() {
        self.alpha = 1
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
        
        if isSignUp && isPrivacyPolicy {
            lblLabel.text = "Privacy Policy"
            let theRrequest: URLRequest = URLRequest(url: JPrivacyPolicy.convertToUrl(), cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 999999999999999999)
            self.webViewTermsAndCond.loadRequest(theRrequest)
        }
            
        else if  isSignUp && !isPrivacyPolicy {
            lblLabel.text = "Terms and Condition"
            let theRrequest: URLRequest = URLRequest(url: JTermsConditions.convertToUrl(), cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 999999999999999999)
            self.webViewTermsAndCond.loadRequest(theRrequest)
        }
        else{
            lblLabel.text = self.stTitle == "" ? "Terms and Condition" : self.stTitle
            self.webViewTermsAndCond.loadHTMLString(_dictCoupon[RES_remark] as! String, baseURL: nil)
        }
        
        self.backgroundColor = RGBCOLOR(0, g: 0, b: 0, alpha: 0.4)
        viewBG.layer.cornerRadius = 5
        
        obj_AppDelegate.navigationController.view.addSubview(self)
        let isOutsideHidden: Bool =  true
        if isOutsideHidden {
            let gestureTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(btnCloseAction))
            self.isUserInteractionEnabled = true
            self.isMultipleTouchEnabled = true
            self.addGestureRecognizer(gestureTap)
        }
        
        //Set sub view at  (- view height)
    }
    
    @IBAction func btnCloseAction() {
        self.closeView()
    }

    internal func closeView() {
      self.removeFromSuperview()
    }
    
    //MARK: UIWEBVIEW DELEGATE
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
       activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }

    

}
