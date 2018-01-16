//
//  ChangePasswordViewController.swift
//  Cubber
//
//  Created by dnk on 02/09/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController, AppNavigationControllerDelegate {
    
    //MARK: PROPERTIES
    @IBOutlet var txtNewPassword: UITextField!
    @IBOutlet var txtConfirmPassword: UITextField!
    @IBOutlet var lblMessage: UILabel!
    @IBOutlet var btnHideShowConfirmPassword: UIButton!
    @IBOutlet var btnHideShowNewPassword: UIButton!
    @IBOutlet var constarintLabelMessageBottomViewNewPassword: NSLayoutConstraint!
    @IBOutlet var constraintLblBottomViewOTP: NSLayoutConstraint!
    @IBOutlet var txtOtp: UITextField!
    @IBOutlet var scrollViewBG: UIScrollView!
    @IBOutlet var lblTimer: UILabel!
    @IBOutlet var btnResendOtp: UIButton!
    @IBOutlet var viewOtpOuter: UIView!
    var timer = Timer()
    var seconds = 60
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate let obj_Location = Location.init()
    fileprivate let obj_FBAndGoogleLogin = FBAndGoogleLogin()
    fileprivate var _KDAlertView = KDAlertView()
    internal var userId: String = ""
    var userMobile: String = ""
    var pageType: UPDATE_PASSWORD = .CHANGE
    var userInfo = typeAliasDictionary()
    var isResendOtp:Bool = false

    override func viewDidLoad()
    {
        super.viewDidLoad()
        if pageType == .CHANGE {
            userInfo = DataModel.getUserInfo()
            userMobile = userInfo[RES_userMobileNo] as! String
            userId = userInfo[RES_userID] as! String
            constraintLblBottomViewOTP.priority = 700
            constarintLabelMessageBottomViewNewPassword.priority = 950
            viewOtpOuter.isHidden = true
        }
        else  if pageType == .FORGOT {
            viewOtpOuter.isHidden = false
            constraintLblBottomViewOTP.priority = 950
            constarintLabelMessageBottomViewNewPassword.priority = 700
            timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        }
        let strMessage : String = "Please enter new password for your Cubber Account"
        lblMessage.text = strMessage + " " + userMobile
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        self.sendScreenView(name: SCREEN_CHANGEPASSWORD)
    }
    
    func setNavigationBar(){
        
        obj_AppDelegate.navigationController.setCustomTitle("Change Password")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.registerForKeyboardNotifications()
        self.SetScreenName(name: F_CHANGEPASSWORD, stclass: F_CHANGEPASSWORD)
    }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK: KEYBOARD
    fileprivate func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    internal func keyboardWasShown(_ aNotification: Notification) {
        let info: [AnyHashable: Any] = (aNotification as NSNotification).userInfo!;
        var keyboardRect: CGRect = ((info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue)
        keyboardRect = self.view.convert(keyboardRect, from: nil);
        var contentInset: UIEdgeInsets = scrollViewBG.contentInset
        contentInset.bottom = keyboardRect.size.height
        scrollViewBG.contentInset = contentInset
    }
    
    internal func keyboardWillBeHidden(_ aNotification: Notification) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            self.scrollViewBG.contentInset = UIEdgeInsets.zero
        }, completion: nil)
    }
    
    func appNavigationController_BackAction() {
        let _ =  self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: CUSTOME METHODS
    fileprivate func hideKeyboard() {
        txtNewPassword.resignFirstResponder()
        txtOtp.resignFirstResponder()
        txtConfirmPassword.resignFirstResponder()
    }
    
    //MARK: UITEXTFIELD DELEGATE
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtOtp {
            txtNewPassword.becomeFirstResponder()
        }
        else if textField == txtNewPassword {
            txtConfirmPassword.becomeFirstResponder()
        }
        else if textField == txtConfirmPassword {
            txtConfirmPassword.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func btnShowNewPasswordAction()
    {
        let stPassword: String = txtNewPassword.text!.trim()
        if !stPassword.characters.isEmpty { txtNewPassword.isSecureTextEntry = !txtNewPassword.isSecureTextEntry; txtNewPassword.text = txtNewPassword.text?.trim()
            btnHideShowNewPassword.isSelected = !btnHideShowNewPassword.isSelected
        }
        if !txtNewPassword.isSecureTextEntry {
            let font:UIFont = txtNewPassword.font!
            txtNewPassword.font = nil
            txtNewPassword.font = font
        }
    }
    
    @IBAction func btnConfirmShowAction()
    {
        let stPassword: String = txtConfirmPassword.text!.trim()
        if !stPassword.characters.isEmpty {
            txtConfirmPassword.isSecureTextEntry = !txtConfirmPassword.isSecureTextEntry;
            txtConfirmPassword.text = txtConfirmPassword.text?.trim()
            btnHideShowConfirmPassword.isSelected = !btnHideShowConfirmPassword.isSelected
        }
        if !txtConfirmPassword.isSecureTextEntry {
            let font:UIFont = txtConfirmPassword.font!
            txtConfirmPassword.font = nil
            txtConfirmPassword.font = font
        }
    }
    
    @IBAction func btnResendOtpAction() {
        self.callForgotPasswordService(.DUMMY, stMobile: self.userMobile, stPass: "", stOtp: "")
        isResendOtp = true
    }

    @IBAction func btnUpdatePasswordAction() {
        
        self.hideKeyboard()
        let stPassword: String = txtConfirmPassword.text!.trim()
        let stNewPassword: String = txtNewPassword.text!.trim()
        let stOtp :String = (txtOtp.text?.trim())!

        if stOtp.characters.isEmpty && self.pageType == .FORGOT {
            _KDAlertView.showMessage(message: MSG_TXT_OTP, messageType: MESSAGE_TYPE.WARNING); return;
        }
        if stNewPassword.isEmpty {
            if stNewPassword.characters.isEmpty { _KDAlertView.showMessage(message: MSG_TXT_PASSWORD, messageType: MESSAGE_TYPE.WARNING); return;
            }
        }
        if stPassword.characters.isEmpty {
            _KDAlertView.showMessage(message: MSG_TXT_CONFIRM_PASSWORD, messageType: MESSAGE_TYPE.WARNING); return; }
       
        if stNewPassword == stPassword {
            
            if self.pageType == .FORGOT{
                isResendOtp = false
                self.callForgotPasswordService(SOCIAL_LOGIN.DUMMY, stMobile: self.userMobile, stPass: stPassword, stOtp: stOtp)
            }
            else{ self.callUpdatePasswordService(SOCIAL_LOGIN.DUMMY, stMobile: self.userMobile, stPassword: stPassword)
            }
        }
        else{
            _KDAlertView.showMessage(message: MSG_TXT_PASSWORD_CHECK, messageType: MESSAGE_TYPE.WARNING); return;
        }

    }
    
    
    func updateCounter(){
        
        seconds -= 1
        lblTimer.text = "\(String(seconds)) Sec"
        
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
    
    fileprivate func callForgotPasswordService(_ loginType: SOCIAL_LOGIN, stMobile: String , stPass:String , stOtp:String) {
        
        let FirParams = [RES_userId:self.userId,
                         FIR_SELECT_CONTENT:"Forgot Password"]
        self.FIRLogEvent(name: F_MODULE_ACCOUNT, parameters: FirParams as [String : NSObject])
        
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_U_MOBILE:stMobile,
                      REQ_DEVICE_TOKEN:DataModel.getUDID(),
                      REQ_DEVICE_TYPE:VAL_DEVICE_TYPE,
                      REQ_DEVICE_ID:DataModel.getVendorIdentifier(),
                      REQ_DEVICE_VERSION:UIDevice.current.modelName,
                      REQ_DEVICE_NAME:DataModel.getDeviceName(),
                      REQ_APP_VERSION:DataModel.getAppVersion(),
                      REQ_LATITUDE:obj_Location.latitude,
                      REQ_LONGITUDE:obj_Location.longitude,
                      REQ_DEVICE_MAC_ID:DataModel.getIPAddress(),
                      REQ_U_PASS:stPass,
                      REQ_OTP_CODE:stOtp];
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_AuthenticatePassword, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
            
            if self.isResendOtp {
                self.txtOtp.text = ""
                self.seconds = 60
                self.timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
            }
            else{
                DataModel.setHeaderToken(dict[RES_token] as! String)
                self.txtNewPassword.text = ""
                self.txtConfirmPassword.text = ""
                self.txtOtp.text = ""
                self.obj_AppDelegate.showLoginView(mobileNo: stMobile)
                self._KDAlertView.showMessage(message: dict[RES_message] as! String, messageType: MESSAGE_TYPE.WARNING); return;

            }
            
        }, onFailure: { (code, dict) in
            let message: String = dict[RES_message] as! String
            self._KDAlertView.showMessage(message: message, messageType: MESSAGE_TYPE.WARNING); return;
        }) {
             self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return
        }
    }

    
    fileprivate func callUpdatePasswordService(_ loginType: SOCIAL_LOGIN, stMobile: String, stPassword: String) {
        
        
        let FirParams = [RES_userId:self.userId,
                         RES_mobileNo:stMobile,
                         FIR_SELECT_CONTENT:"Update Password"]
        self.FIRLogEvent(name: F_MODULE_ACCOUNT, parameters: FirParams as [String : NSObject])
        
        var params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_U_MOBILE:stMobile,
                      REQ_U_PASS:stPassword,
                      REQ_USER_ID:self.userId];
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_UpdatePassword, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in

            DataModel.setHeaderToken(dict[RES_token] as! String)
            self.txtNewPassword.text = ""
            self.txtConfirmPassword.text = ""
            params[REQ_HEADER] = DataModel.getHeaderToken()
            if self.pageType == .CHANGE { let _ = self.navigationController?.popViewController(animated: true)}
            else {  self.obj_AppDelegate.showLoginView(mobileNo: stMobile) }
            self._KDAlertView.showMessage(message: dict[RES_message] as! String, messageType: MESSAGE_TYPE.WARNING); return;
        }, onFailure: { (code, dict) in
            let message: String = dict[RES_message] as! String
            self._KDAlertView.showMessage(message: message, messageType: MESSAGE_TYPE.WARNING); return;
        }) {
             self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return
        }
    }
}
