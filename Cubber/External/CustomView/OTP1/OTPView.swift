//
//  OTPView.swift
//  Cubber
//
//  Created by Vyas Kishan on 30/07/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

public enum OTP_TYPE: Int {
    
    case DUMMY
    case REGISTRATION
    case send_MONEY
    case send_MONEY_WHEN_BALANCE
    case LOGIN
    case FORGOT_PASSWORD
    case VERIFY_EMAIL
}

protocol OTPViewDelegate {
    func onOtpSuccess(_ otpType: OTP_TYPE, serviceResponse: typeAliasDictionary)
}

class OTPView: UIView , UITextFieldDelegate , UIGestureRecognizerDelegate {
    
    //MARK: CONSTANT
    fileprivate let activityIndicatorTrailing: CGFloat = -20
    
    //MARK: PROPERTIES
    
    @IBOutlet var viewMain: UIView!
    @IBOutlet var viewIcon: UIView!
    @IBOutlet var txtCodeCollection: [UITextField]!
    @IBOutlet var txtCode1: UITextField!
    @IBOutlet var txtCode2: UITextField!
    @IBOutlet var txtCode3: UITextField!
    @IBOutlet var txtCode4: UITextField!
    @IBOutlet var txtCode5: UITextField!
    @IBOutlet var txtCode6: UITextField!
    @IBOutlet var lblTimer: UILabel!
    static let InvisibleSign = "\u{200B}"
    @IBOutlet var viewKeyBoard: UIView!
    @IBOutlet var viewBG: UIView!
    @IBOutlet var constraintViewKeyBoardBottomToSuper: NSLayoutConstraint!
    
    @IBOutlet var btnResendOtp: UIButton!
    var timer = Timer()
    var seconds = 60
    var delegate: OTPViewDelegate! = nil
    var _OTP_TYPE: OTP_TYPE = OTP_TYPE.DUMMY
    internal var stOtp = ""
    
    //MARK: VARIABLES
    let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate let _KDAlertView = KDAlertView()
    var dictParameters: [String: String]!
    var stMobileNo: String = ""
    
    //MARK: VIEW METHODS
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
     
    init(dictServicePara: [String: String], otpType: OTP_TYPE) {
        self._OTP_TYPE = otpType
        self.dictParameters = dictServicePara
        let frame: CGRect = UIScreen.main.bounds
        super.init(frame : frame)
        loadXIB()
        obj_AppDelegate.navigationController.view.addSubview(self)
        
       /* let mobileNo: String = dictServicePara[REQ_U_MOBILE]!
        let startIndex = mobileNo.characters.index(mobileNo.startIndex, offsetBy: mobileNo.characters.count - 3)
        let range = startIndex..<mobileNo.endIndex
        let stLastDigits = mobileNo.substring( with: range )
        
        self.lblDescription.text = "We have sent an OTP to *******\(stLastDigits).\nPlease enter it to continue."
        if self._OTP_TYPE == .VERIFY_EMAIL {
            let userInfo = DataModel.getUserInfo()
            let stEmail = userInfo[RES_userEmailId] as! String
            self.lblDescription.text = "We have sent an OTP to \(stEmail).\nPlease enter it to continue."
            btnResendOtp.setTitle("Resend Email", for: .normal)
        }*/
        for txt in txtCodeCollection {
            txt.delegate = self
            txt.addTarget(self, action: #selector(didChangeEditingInTextField(sender:)), for: .editingChanged)
            txt.layer.sublayerTransform = CATransform3DMakeTranslation(-5, 0, 0)
            txt.tintColor = UIColor.blue
        }
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
        
     /*   constraintActivityIndicatorTrailing.constant = self.activityIndicatorTrailing
        self.layoutIfNeeded()
    
        self.backgroundColor = RGBCOLOR(0, g: 0, b: 0, alpha: 0.4)
        viewBG.layer.cornerRadius = 5
        viewTextBGOTP.setBottomBorder(COLOUR_TEXTFIELD_BORDER, borderWidth: 1)
        
        */
       /* let gestureTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(btnCloseViewTapAction))
        self.isUserInteractionEnabled = true
        self.isMultipleTouchEnabled = true
        self.addGestureRecognizer(gestureTap)
        gestureTap.delegate = self
        self.tag = 10001
        viewBG.tag = 101*/

        
        self.viewKeyBoard.isHidden = true
        let velocity: CGFloat = 10;
        let duration: TimeInterval = 0.8;
        let damping: CGFloat = 0.5;    //usingSpringWithDamping : 0 - 1
        
        //Set sub view at  (- view height)
        var sFrame: CGRect = self.viewBG.frame;
        sFrame.origin.y = -self.viewBG.frame.height;
        self.viewBG.frame = sFrame;
        self.constraintViewKeyBoardBottomToSuper.constant = -viewKeyBoard.frame.height
        //self.layoutIfNeeded()
        UIView.animate(withDuration: duration, delay: 0.1, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            var sFrame: CGRect = self.viewBG.frame;
            sFrame.origin.y = 0;
            self.viewBG.frame = sFrame;

        }, completion: {(completed) in
            self.showkeyBoard()
        })
        
     //   btnResendOtp.isHidden = true
       // whiteActivityIndicator.isHidden = true
        
    timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
    }
    
    //MARK: CUSTOME METHODS
   /* fileprivate func hideKeyboard() {
        txtOTP.resignFirstResponder()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { self.viewBG.center = self.center }, completion: nil)
    }
    
    */func updateCounter(){
        
        seconds -= 1
        lblTimer.text = "\(String(seconds)) Sec."
        
        if seconds == 0 {
            timer.invalidate()
            seconds = 0
            btnResendOtp.isHidden = false
            lblTimer.isHidden = true
        }
        else{
            btnResendOtp.isHidden = true
            lblTimer.isHidden = false
        }
    }
    
    //MARK: UIBUTTON ACTION
    @IBAction func btnResendOtpAction() {
        
        let sendMoneyMobile: String = self._OTP_TYPE == OTP_TYPE.send_MONEY || self._OTP_TYPE == OTP_TYPE.send_MONEY_WHEN_BALANCE ? self.dictParameters[REQ_SEND_MONEY_MOBILE]! : ""
        
        UIView.animate(withDuration: 0.0, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
//            self.viewTextBGOTP.layoutIfNeeded()
            }) { (finished) in
                
                self.dictParameters[REQ_OTP_CODE] = ""
                var methodName = ""
                if self._OTP_TYPE == OTP_TYPE.REGISTRATION {methodName = JMETHOD_UserRegistration }
                else if self._OTP_TYPE == OTP_TYPE.LOGIN { methodName = JMETHOD_UserLogin}
                else if self._OTP_TYPE == OTP_TYPE.VERIFY_EMAIL { methodName = JEMTHOD_VerifyEmail }
                else {methodName = JMETHOD_VerifyOtp }
                
                self.obj_OperationWeb.callRestApi(methodName: methodName, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: self.dictParameters, viewActivityParent: UIView.init(), onSuccess: { (dict) in
                        print(dict)
                        self.seconds = 60
                       self.timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
                }, onFailure: { (code, dict) in
                 
                }, onTokenExpire: { })
        }
    }
    
    @IBAction func btnVerifyAction() {
        self.hideKeyBoard()
        let stOtp: String = "\(txtCode1.text!.trim())\(txtCode2.text!.trim())\(txtCode3.text!.trim())\(txtCode4.text!.trim())\(txtCode5.text!.trim())\(txtCode6.text!.trim())"
        if stOtp.isEmpty {
            _KDAlertView.showMessage(message: MSG_TXT_OTP, messageType: MESSAGE_TYPE.FAILURE)
            return
        }
        UIView.animate(withDuration: 0.0, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
//            self.viewTextBGOTP.layoutIfNeeded()
        }) { (finished) in
            
            self.dictParameters[REQ_OTP_CODE] = stOtp
            var methodName = ""
            if self._OTP_TYPE == OTP_TYPE.REGISTRATION {methodName = JMETHOD_UserRegistration }
            else if self._OTP_TYPE == OTP_TYPE.LOGIN { methodName = JMETHOD_UserLogin }
            else if self._OTP_TYPE == OTP_TYPE.VERIFY_EMAIL { methodName = JEMTHOD_VerifyEmail }
            else {methodName = JMETHOD_VerifyOtp }
            
            self.obj_OperationWeb.callRestApi(methodName: methodName, methodType: .POST, isAddToken: false, parameters: self.dictParameters, viewActivityParent: self.obj_AppDelegate.navigationController!.view, onSuccess: { (dict) in
                     if self._OTP_TYPE == OTP_TYPE.REGISTRATION {
                        DataModel.setHeaderToken(dict[RES_token] as! String)
                        
                        var dictUserInfo: typeAliasDictionary = dict[RES_register]![RES_user_info] as! typeAliasDictionary
                        dictUserInfo[RES_userID] = dictUserInfo["userId"]
                        dictUserInfo.removeValue(forKey: "userId")
                        DataModel.setUserInfo(dictUserInfo)
                        
                        DataModel.setNoMembershipFeesPayMsg(dict[RES_message] as! String)
                        
                        if dict[RES_register]![RES_membership_fee] != nil {
                            DataModel.setMemberShipFees(dict[RES_register]![RES_membership_fee] as! String)
                        }
                        
                        self.btnCloseViewTapAction()
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { self.delegate.onOtpSuccess(self._OTP_TYPE, serviceResponse: dict) }
                        
                    }
                    else if self._OTP_TYPE == OTP_TYPE.LOGIN {
                        self.btnCloseViewTapAction()
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { self.delegate.onOtpSuccess(self._OTP_TYPE, serviceResponse: dict) }
                    }
                     else {
                        DataModel.setHeaderToken(dict[RES_token] as! String)
                        self.btnCloseViewTapAction()
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { self.delegate.onOtpSuccess(self._OTP_TYPE, serviceResponse: dict) }
                }
            }, onFailure: { (code , dict) in
                let message: String = dict[RES_message] as! String
                self._KDAlertView.showMessage(message: message, messageType: MESSAGE_TYPE.FAILURE)
                return
                
            }, onTokenExpire: {self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING); return})
        }
    }
    
    @IBAction func btnCloseViewTapAction() {
        self.hideKeyBoard()
        UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, options: UIViewKeyframeAnimationOptions.beginFromCurrentState, animations: {
            var frame = self.viewMain.frame
            frame.origin.y = self.frame.maxY + frame.height
            self.viewMain.frame = frame
        }, completion: { (finished) in
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { self.alpha = 0 }, completion:{ (finished) in self.removeFromSuperview() })
        })
        
    }

    func activateTextField(tag:Int) {
        if tag <= txtCodeCollection.count  && tag > 0 {
        for txt in txtCodeCollection {
            if txt.tag == tag {txt.becomeFirstResponder() ;
                if txt.text == "" {
                    txt.text = ""
                }
            }
            else{
               // txt.resignFirstResponder()
            }
            }
        }
    }
    
    @IBAction func btnNumberKeyAction(_ sender: UIButton) {
        
        let stTitle = sender.currentTitle
        if txtCode1.text?.characters.count == 0 { txtCode1.text = stTitle }
        else if txtCode2.text?.characters.count == 0 { txtCode2.text = stTitle }
        else if txtCode3.text?.characters.count == 0 { txtCode3.text = stTitle }
        else if txtCode4.text?.characters.count == 0 { txtCode4.text = stTitle }
        else if txtCode5.text?.characters.count == 0 { txtCode5.text = stTitle }
        else if txtCode6.text?.characters.count == 0 { txtCode6.text = stTitle ;
            self.hideKeyBoard()
   
        }
        }
    
    @IBAction func btnClearTextAction() {
        if txtCode6.text?.characters.count != 0 { txtCode6.text = "" }
        else if txtCode5.text?.characters.count != 0 { txtCode5.text = "" }
        else if txtCode4.text?.characters.count != 0 { txtCode4.text = "" }
        else if txtCode3.text?.characters.count != 0 { txtCode3.text = "" }
        else if txtCode2.text?.characters.count != 0 { txtCode2.text = "" }
        else if txtCode1.text?.characters.count != 0 { txtCode1.text = "" }
    }
    
    func hideKeyBoard() {
        self.constraintViewKeyBoardBottomToSuper.constant = -viewKeyBoard.frame.height
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
            self.viewKeyBoard.isHidden = false
            self.viewBG.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2);
        })
    }
    
    func showkeyBoard() {
        self.constraintViewKeyBoardBottomToSuper.constant = 0
          self.viewKeyBoard.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
            
        })
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            var frame: CGRect = self.viewBG.frame
            frame.origin.y = -80
            self.viewBG.frame = frame
    
        }, completion: {(completed) in
            self.layoutIfNeeded()
        })
        


    }
    //MARK: UITEXTFIELD DELEGATE
    
    @IBAction func didChangeEditingInTextField(sender: UITextField) {
        if var text = sender.text {
            if text.characters.count <= 2 && text != "" {
                text = OTPView.InvisibleSign.appending(text)
                sender.text = text
                self.activateTextField(tag: sender.tag + 1)
            }
                
            else if text == "" {
              sender.text = ""
                self.activateTextField(tag: sender.tag - 1)
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        self.showkeyBoard()
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //self.hideKeyboard()
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //self.hideKeyboard()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
      /*  let text: String = textField.text!
        let resultingString: String = text.replacingCharacters(in: range.toRange(string: text), with: string)
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            textField.text = ""
            //self.activateTextField(tag: textField.tag - 1)
            return true
        }
         
        if string == "" {
            textField.text = ""
            //self.activateTextField(tag: textField.tag - 1)
            return true
        }
            
        else if string != "" && textField.text == "" {
            //self.activateTextField(tag: textField.tag + 1)
            return true
        }
        else if resultingString.characters.count > 1 {
//            self.activateTextField(tag: textField.tag + 1)
            return true
        }

        
        /*if resultingString == "" {
            textField.text = ""
            self.activateTextField(tag: textField.tag - 1)
            return false
        }
        else if resultingString != "" && resultingString.characters.count <= 1 {
            textField.text = resultingString
            self.activateTextField(tag: textField.tag + 1)
            return false
        }
        else if resultingString.characters.count > 1 {
            self.activateTextField(tag: textField.tag + 1)
            return false
        }*/*/
      
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        return true
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let view = touch.view
        if view?.tag == 101 {
          return true
        }
        return false

    }
}
