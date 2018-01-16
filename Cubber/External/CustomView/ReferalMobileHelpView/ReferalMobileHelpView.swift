//
//  ReferalMobileHelpView.swift
//  Cubber
//
//  Created by dnk on 11/09/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

@objc protocol ReferalMobileHelpViewDelegate {
    func sendReferelNo(stMobileNo:String , stReferLabel:UILabel)
    
}

class ReferalMobileHelpView: UIView, UIGestureRecognizerDelegate, ParentSelectionDelegate, UITextFieldDelegate {
    
    //MARK: PROPERTIES
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var viewBG: UIView!
    @IBOutlet var viewMain: UIView!
    @IBOutlet var txtReferalMobileNo: UITextField!
    @IBOutlet var lblReferralMobileNoUser: UILabel!
    var referealDelegate:ReferalMobileHelpViewDelegate? = nil
    var stMobileNumber: String = ""
    let dictCategory = DataModel.getCategoryListResponse() as typeAliasDictionary
    let dictCubberContact = DataModel.getCubberAdminInfo() as typeAliasDictionary
    @IBOutlet var constraintLabelTopToView: NSLayoutConstraint!
    @IBOutlet var constraintLabelTopToApplyButton: NSLayoutConstraint!
    //MARK: VARIABLES
    let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate let _KDAlertView = KDAlertView()

    //MARK: VIEW METHODS
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(frame: CGRect, strMobileNo:String) {
        let frame: CGRect = UIScreen.main.bounds
        super.init(frame: frame)
        stMobileNumber = strMobileNo
        self.loadXIB()
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
        
         obj_AppDelegate.navigationController.view.addSubview(self)
        lblTitle.text = dictCategory[RES_referral_title] as? String
        lblDescription.text = dictCategory[RES_referral_description] as? String
        let gestureTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(btnCloseViewTapAction))
        self.isUserInteractionEnabled = true
        self.isMultipleTouchEnabled = true
        self.addGestureRecognizer(gestureTap)
        gestureTap.delegate = self
        viewBG.tag = 100

        let velocity: CGFloat = 10;
        let duration: TimeInterval = 0.8;
        let damping: CGFloat = 0.5;    //usingSpringWithDamping : 0 - 1
        
        //Set sub view at  (- view height)
        var sFrame: CGRect = self.viewBG.frame;
        sFrame.origin.y = -self.viewBG.frame.height;
        self.viewBG.frame = sFrame;
        
        UIView.animate(withDuration: duration, delay: 0.1, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            var sFrame: CGRect = self.viewBG.frame;
            sFrame.origin.y = 0;
            self.viewBG.frame = sFrame;
            
        }, completion: {(completed) in
        })
    }
    
    func btnCloseViewTapAction() {
       
        UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: UIViewKeyframeAnimationOptions.beginFromCurrentState, animations: {
            var frame = self.viewMain.frame
            frame.origin.y = self.frame.maxY + frame.height
            self.viewMain.frame = frame
        }, completion: { (finished) in
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { self.alpha = 0 }, completion:{ (finished) in self.removeFromSuperview() })
        })
        
    }
    
    //MARK: CUSTOM METHODS
    fileprivate func hideKeyboard() {
        txtReferalMobileNo.resignFirstResponder()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { self.viewBG.center = self.center }, completion: nil)
    }
    
    //MARK: PARENT SELECTION DELEGATE
    
    func onParentSelection(_ stParentMobileNo: String) {
        
         self.txtReferalMobileNo.text = stParentMobileNo
            self.callIsReferralUserService(stParentMobileNo, lblReferralUser: lblReferralMobileNoUser)
    }
    
    func callIsReferralUserService(_ mobileNo: String, lblReferralUser: UILabel) {
        self.hideKeyboard()
        
        let params: typeAliasStringDictionary = [REQ_HEADER: DataModel.getHeaderToken(),
                                                 REQ_REFERREL_CODE: mobileNo]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_IsReferrelUser, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: obj_AppDelegate.navigationController.view, onSuccess: { (dict) in
            DataModel.setHeaderToken(dict[RES_token] as! String)
            self.constraintLabelTopToView.priority = PRIORITY_LOW
            self.constraintLabelTopToApplyButton.priority = PRIORITY_HIGH
            lblReferralUser.text = dict[RES_referrel_name] as? String
        }, onFailure: { (code,dict) in
            self.txtReferalMobileNo.text = "";
            lblReferralUser.text = ""
            self.constraintLabelTopToView.priority = PRIORITY_HIGH
            self.constraintLabelTopToApplyButton.priority = PRIORITY_LOW
           self._KDAlertView.showMessage(message: dict[RES_message] as! String, messageType: .FAILURE)
            return
        }) {
            self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING); return
        }
    }
    
    fileprivate func showParentSelectionView(_ stMobileNo: String) {
     //   self.hideKeyboard()
        stMobileNumber = stMobileNo
        let parentSelectionVC = ParentSelectionViewController(nibName: "ParentSelectionViewController", bundle: nil)
        parentSelectionVC.stMobileNo = stMobileNo
        parentSelectionVC.delegate = obj_AppDelegate.navigationController.viewControllers.last as! ParentSelectionDelegate!
        obj_AppDelegate.navigationController.pushViewController(parentSelectionVC, animated: true)
    }

   // MARK:GESTURE DELEGATE
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let view = touch.view
        if view?.tag == 100 {
            return true
        }
        return false
        
    }

    @IBAction func btnCubberAction() {
        self.btnCloseViewTapAction()
        let lbl:UILabel = UILabel()
        lbl.text = dictCubberContact[RES_cubber_admin] as? String
         self.referealDelegate?.sendReferelNo(stMobileNo: dictCubberContact[RES_cubber_mobile_no] as! String, stReferLabel: lbl)
    }
    
    @IBAction func btnRequestFriendsAction() {
        var stMobileNo: String = txtReferalMobileNo.text!.trim()
        
        stMobileNo = stMobileNo.characters.isEmpty ? stMobileNumber : stMobileNo
        
        self.btnCloseViewTapAction()
        self.showParentSelectionView(stMobileNo)
    }
    
    @IBAction func btnApplyAction() {
        let stMobileNo: String = txtReferalMobileNo.text!.trim()
        self.referealDelegate?.sendReferelNo(stMobileNo: stMobileNo, stReferLabel: lblReferralMobileNoUser)
        self.btnCloseViewTapAction()
        
    }
    
    //MARK: TEXTFIELD DELEGATE
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtReferalMobileNo{
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            var frame: CGRect = self.viewBG.frame
            frame.origin.y = -80
            self.viewBG.frame = frame
        }, completion: nil)
            return true
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.hideKeyboard()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideKeyboard()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text: String = textField.text!
        let resultingString: String = text.replacingCharacters(in: range.toRange(string: text), with: string)
        if resultingString.characters.isEmpty { return true }
        
        if textField == txtReferalMobileNo  {
            var holder: Float = 0.00
            let scan: Scanner = Scanner(string: resultingString)
            let RET: Bool = scan.scanFloat(&holder) && scan.isAtEnd
            if string == "." { return false }
            if resultingString.characters.count > 10 { return false }
            
            if textField == txtReferalMobileNo {
                lblReferralMobileNoUser.text = ""
                if resultingString.characters.count == 10 {
                    
                    self.callIsReferralUserService(resultingString, lblReferralUser: lblReferralMobileNoUser); txtReferalMobileNo.text = resultingString }
                else{
                    self.constraintLabelTopToView.priority = PRIORITY_HIGH
                    self.constraintLabelTopToApplyButton.priority = PRIORITY_LOW
                }
            }
            return RET
        }
        return true
    }

}
