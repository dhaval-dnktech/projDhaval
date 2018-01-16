//
//  MessageView.swift
//  Cubber
//
//  Created by dnk on 11/09/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//
public enum MESSAGE_TYPE: Int {
    case SUCCESS
    case FAILURE
    case QUESTION
    case WARNING
    case RATING
    case MEMBERSHIP_WARNING
    case SECURITY_WARNING
    case INTERNET_WARNING
    case PAYMENT
}

@objc protocol KDAlertViewDelegate {
   @objc optional func messageOkAction()
   @objc optional func messageYesAction()
   @objc optional func messageNoAction()
}

import UIKit

class KDAlertView: UIView , UIWebViewDelegate {

    //MARK: PROPERTIES
    @IBOutlet var viewBG: UIView!
    @IBOutlet var imageViewBGLogo: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblMessage: UILabel!
    var _MESSAGE_TYPE: MESSAGE_TYPE = MESSAGE_TYPE.WARNING
    var alertDelegate:KDAlertViewDelegate? = nil
    @IBOutlet var viewYesNo: UIStackView!
    @IBOutlet var btnOk: UIButton!
    @IBOutlet var viewLine: UIView!
    @IBOutlet var constraintLblMessageHeight: NSLayoutConstraint!
    @IBOutlet var webViewAlert: UIWebView!
    @IBOutlet var viewRating: UIStackView!
    
    @IBOutlet var btnYes: UIButton!
    @IBOutlet var btnNo: UIButton!
    
    
    //MARK: VARIABLES
    
    var privatedidSelect: (_ isClicked:Bool) -> () = { _ in }
    
    //MARK: VIEW METHODS
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        let frame: CGRect = UIScreen.main.bounds
        super.init(frame: frame)

    }
    
    internal func showMessage(message: String, messageType: MESSAGE_TYPE) {
        self._MESSAGE_TYPE = messageType
        self.loadXIB()
        let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        obj_AppDelegate.navigationController.view.addSubview(self)
        lblTitle.text = "Cubber"
        lblMessage.text = message
        webViewAlert.isHidden = true
        constraintLblMessageHeight.constant = 50
        lblMessage.isHidden = false
        if self._MESSAGE_TYPE == MESSAGE_TYPE.QUESTION {
            imageViewBGLogo.image = UIImage.init(named: "icon_errornet")
            viewYesNo.isHidden = false; btnOk.isHidden = true ; viewRating.isHidden = true ; viewLine.isHidden = true }
            
        else if self._MESSAGE_TYPE == MESSAGE_TYPE.PAYMENT {
            
            lblTitle.text = "Cancel Transaction"
            imageViewBGLogo.image = UIImage.init(named: "icon_sessionerror")
            viewYesNo.isHidden = false; btnOk.isHidden = true ; viewRating.isHidden = true ; viewLine.isHidden = true
            btnYes.setTitle("Proceed", for: .normal)
            btnNo.setTitle("Cancel", for: .normal)
            
        }
            
        else if self._MESSAGE_TYPE == MESSAGE_TYPE.SECURITY_WARNING {
            imageViewBGLogo.image = UIImage.init(named: "icon_sessionerror")
             viewYesNo.isHidden = true ; btnOk.isHidden = false ; viewRating.isHidden = true ; viewLine.isHidden = true        }
            
        else if self._MESSAGE_TYPE == MESSAGE_TYPE.MEMBERSHIP_WARNING {
            imageViewBGLogo.image = UIImage.init(named: "icon_cash")
            viewYesNo.isHidden = true ; btnOk.isHidden = false ; viewRating.isHidden = true ; viewLine.isHidden = true
            btnOk.setTitle("Pay", for: .normal)
        }
        else if self._MESSAGE_TYPE == MESSAGE_TYPE.INTERNET_WARNING{
            imageViewBGLogo.image = UIImage.init(named: "icon_errornet")
            viewYesNo.isHidden = true ; btnOk.isHidden = false ; viewRating.isHidden = true ; viewLine.isHidden = true
            btnOk.setTitle("Retry", for: .normal)
        }
        else if self._MESSAGE_TYPE == MESSAGE_TYPE.RATING {
            lblTitle.text = "Rating"
            imageViewBGLogo.image = UIImage.init(named: "logo")
            viewYesNo.isHidden = true ; btnOk.isHidden = true ; viewRating.isHidden = false ; viewLine.isHidden = false
        }
        else {
            imageViewBGLogo.image = UIImage.init(named: "icon_errornet")
            viewYesNo.isHidden = true ; btnOk.isHidden = false ; viewRating.isHidden = true ; viewLine.isHidden = true
        }
    }
    
    internal func showMessage(message: String, messageType: MESSAGE_TYPE , title:String) {
        self._MESSAGE_TYPE = messageType
        self.loadXIB()
        let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        obj_AppDelegate.navigationController.view.addSubview(self)
        lblTitle.text = title
        lblMessage.text = message
        webViewAlert.isHidden = true
        constraintLblMessageHeight.constant = 50
        lblMessage.isHidden = false
        if self._MESSAGE_TYPE == MESSAGE_TYPE.QUESTION {
            imageViewBGLogo.image = UIImage.init(named: "icon_errornet")
            viewYesNo.isHidden = false; btnOk.isHidden = true ; viewRating.isHidden = true ; viewLine.isHidden = true }
        else if self._MESSAGE_TYPE == MESSAGE_TYPE.SECURITY_WARNING{
            imageViewBGLogo.image = UIImage.init(named: "icon_sessionerror")
            viewYesNo.isHidden = true ; btnOk.isHidden = false ; viewRating.isHidden = true ; viewLine.isHidden = true        }
        else if self._MESSAGE_TYPE == MESSAGE_TYPE.MEMBERSHIP_WARNING{
            imageViewBGLogo.image = UIImage.init(named: "icon_cash")
            viewYesNo.isHidden = true ; btnOk.isHidden = false ; viewRating.isHidden = true ; viewLine.isHidden = true
            btnOk.setTitle("Pay", for: .normal)
        }
        else if self._MESSAGE_TYPE == MESSAGE_TYPE.INTERNET_WARNING{
            imageViewBGLogo.image = UIImage.init(named: "icon_errornet")
            viewYesNo.isHidden = true ; btnOk.isHidden = false ; viewRating.isHidden = true ; viewLine.isHidden = true
            btnOk.setTitle("Retry", for: .normal)
        }
        else if self._MESSAGE_TYPE == MESSAGE_TYPE.RATING{
            lblTitle.text = "Your Experience"
            imageViewBGLogo.image = UIImage.init(named: "logo")
            viewYesNo.isHidden = true ; btnOk.isHidden = true ; viewRating.isHidden = false ; viewLine.isHidden = false
        }
        else{
            imageViewBGLogo.image = UIImage.init(named: "icon_errornet")
            viewYesNo.isHidden = true ; btnOk.isHidden = false ; viewRating.isHidden = true ; viewLine.isHidden = true
        }
    }
    
    
    internal func showWebViewAlert(stMessage:String ,messageType: MESSAGE_TYPE , stTitle:String) {
        self._MESSAGE_TYPE = messageType
        self.loadXIB()
        let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        obj_AppDelegate.navigationController.view.addSubview(self)
        webViewAlert.loadHTMLString(stMessage, baseURL: nil)
        viewYesNo.isHidden = true ; btnOk.isHidden = false ; viewRating.isHidden = true ; viewLine.isHidden = true
        webViewAlert.isHidden = false
        lblTitle.text = stTitle
       // constraintLblMessageHeight.constant = 0
        lblMessage.isHidden = true
        if self._MESSAGE_TYPE == MESSAGE_TYPE.QUESTION {
            imageViewBGLogo.image = UIImage.init(named: "icon_errornet")
            viewYesNo.isHidden = false; btnOk.isHidden = true }
        else if self._MESSAGE_TYPE == MESSAGE_TYPE.SECURITY_WARNING{
            imageViewBGLogo.image = UIImage.init(named: "icon_sessionerror")
            viewYesNo.isHidden = true ; btnOk.isHidden = false
        }
        else if self._MESSAGE_TYPE == MESSAGE_TYPE.MEMBERSHIP_WARNING{
            imageViewBGLogo.image = UIImage.init(named: "icon_cash")
            viewYesNo.isHidden = true ; btnOk.isHidden = false
        }
        else{
            imageViewBGLogo.image = UIImage.init(named: "icon_errornet")
            viewYesNo.isHidden = true ; btnOk.isHidden = false
        }
    }
    
    fileprivate func loadXIB() {
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false;
        for view in self.subviews { view.removeFromSuperview() }
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
        
        UIView.animate(withDuration: 0.3, animations: {
            self.viewBG.alpha = 1
        }) { (completed) in
        }
    }
    
    internal func btnCloseViewTapAction() {
        self.removeFromSuperview()
        UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: UIViewKeyframeAnimationOptions.beginFromCurrentState, animations: {
            self.viewBG.alpha = 0
        }, completion: { (finished) in

        })
        
    }
    
    @IBAction func btnOkAction() {
        self.btnCloseViewTapAction()
        if self._MESSAGE_TYPE == .MEMBERSHIP_WARNING {
            let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            obj_AppDelegate.onVKMenuAction(.HOW_TO_EARN, categoryID: 13)
        }
       self.alertDelegate?.messageOkAction!()
       privatedidSelect(true)
    }
    
    @IBAction func btnYesAction() {
        self.btnCloseViewTapAction()
        self.alertDelegate?.messageYesAction!()
    }
    
    @IBAction func btnNoAction() {
        self.btnCloseViewTapAction()
        self.alertDelegate?.messageNoAction!()
    }
    
    @IBAction func btnRateNowAction() {
        self.btnCloseViewTapAction()
        if #available(iOS 11.0 , *) {
            UIApplication.shared.openURL("itms-apps://itunes.apple.com/us/app/cubber/id1171382587?mt=8&action=write-review".convertToUrl())
        }
        else {
            UIApplication.shared.openURL(URL.init(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1171382587&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software&action=write-review")!)
        }
    }
    
    @IBAction func btnRateLaterAction() {
        self.btnCloseViewTapAction()
    }
    
    @IBAction func btnNeverAskAgainAction() {
        self.btnCloseViewTapAction()
        DataModel.setIsNeverShowReviewPrompt(true)
    }
    
    internal func didClick(completion: @escaping (_ isClicked:Bool) -> ()) {
        privatedidSelect = completion
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        let size:CGSize = webView.sizeThatFits(.zero)
        constraintLblMessageHeight.constant = size.height
        self.layoutIfNeeded()
    }
}
