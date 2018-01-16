//
//  LoginViewController.swift
//  Cubber
//
//  Created by dnk on 26/08/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, FBAndGoogleLoginDelegate , OTPViewDelegate , AppNavigationControllerDelegate {
    
    //MARK:PROPERTIES
    @IBOutlet var txtMobileNoEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var viewBGCollection: [UIView]!
    @IBOutlet var viewHighLightEmail: UIView!
    @IBOutlet var viewHighLightPassword: UIView!
    @IBOutlet var viewBGHighLightCollection: [UIView]!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var btnHideShowPassword: UIButton!
    @IBOutlet var viewLeft: UIView!
    @IBOutlet var viewRight: UIView!
    @IBOutlet var lblLoginMessage: UILabel!
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate let obj_Location = Location.init()
    fileprivate var _KDAlertView = KDAlertView()
    fileprivate let obj_FBAndGoogleLogin = FBAndGoogleLogin()
    fileprivate var dictSocial = typeAliasDictionary()
    internal var mobileNo :String = ""
    internal var isRootVC:Bool = false
    let dictCategory = DataModel.getCategoryListResponse() as typeAliasDictionary
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        obj_FBAndGoogleLogin.delegate = self
        txtMobileNoEmail.text = mobileNo
        if (FBSDKAccessToken.current() != nil) {}
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.setNavigationBar()
        for view:UIView in viewBGCollection {
            view.setViewBorder(UIColor.clear, borderWidth: 0, isShadow: false, cornerRadius: 5, backColor: view.backgroundColor!)
        }
        if !mobileNo.isEmpty
        {
            txtPassword.text = ""
            txtPassword.becomeFirstResponder()
        }
        else {
            txtPassword.text = ""
            txtMobileNoEmail.becomeFirstResponder()
        }
        if dictCategory[RES_loginScreenMessage] != nil {
            lblLoginMessage.attributedText = (dictCategory[RES_loginScreenMessage] as! String).htmlAttributedString
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewLeft.layer.addGradientColor(colors: [UIColor.white , COLOUR_DARK_GREEN])
        viewRight.layer.addGradientColor(colors: [COLOUR_DARK_GREEN , UIColor.white])
        self.registerForKeyboardNotifications()
        self.SetScreenName(name: F_LOGIN, stclass: F_LOGIN)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
        
        var contentInset: UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = keyboardRect.size.height
        scrollView.contentInset = contentInset
    }
    
    internal func keyboardWillBeHidden(_ aNotification: Notification) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            self.scrollView.contentInset = UIEdgeInsets.zero
        }, completion: nil)
    }
    
    func setNavigationBar() {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        obj_AppDelegate.navigationController.setCustomTitle("Login")
        if !isRootVC {
            obj_AppDelegate.navigationController.setLeftButton(title: "")
            obj_AppDelegate.navigationController.navigationDelegate = self
        }
    }
    
    func appNavigationController_BackAction() {

        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: CUSTOME METHODS
    
    @IBAction func btnFBLoginAction() {
        
        obj_FBAndGoogleLogin.performFBLoginAction(self)
        self.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_LOGIN)", action: "\(SCREEN_LOGIN):FB LOGIN", label: "User not logged in", value: nil)}
    
    @IBAction func btnGoogleLoginAction() { obj_FBAndGoogleLogin.performGoogleLoginAction(self)
        self.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_LOGIN)", action: "\(SCREEN_LOGIN):GOOGLE LOGIN", label: "User not logged in", value: nil)}
    
    fileprivate func hideKeyboard() {
        txtMobileNoEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        for view:UIView in viewBGHighLightCollection {
            view.unSetHighlight()
        }
    }
    
    @IBAction func btnForgotPasswordAction() {
        self.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_LOGIN)", action: FORGOTPASSWORD, label: "Forget Password", value: nil)
        let forgotPassVc = ForgotPasswordViewController(nibName: "ForgotPasswordViewController", bundle: nil)
        forgotPassVc.userMobile = txtMobileNoEmail.text?.trim()
        self.navigationController?.pushViewController(forgotPassVc, animated: true)
    }
    
    @IBAction func btnHideShowPasswordAction() {
        
        btnHideShowPassword.isSelected = !btnHideShowPassword.isSelected
        if btnHideShowPassword.isSelected { txtPassword.isSecureTextEntry = false }
        else { txtPassword.isSecureTextEntry = true }
        if !txtPassword.isSecureTextEntry {
            let font:UIFont = txtPassword.font!
            txtPassword.font = nil
            txtPassword.font = font
        }
    }
    
    @IBAction func btnLoginAction() {
        
        self.hideKeyboard()
        self.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_LOGIN)", action: SCREEN_LOGIN, label: "User not logged in", value: nil)
        let stMobileNo: String = txtMobileNoEmail.text!.trim()
        let stPassword: String = txtPassword.text!.trim()
        
        if stMobileNo.isEmpty {
            if stMobileNo.characters.isEmpty {
                _KDAlertView.showMessage(message: MSG_TXT_MOBILE_NO, messageType: MESSAGE_TYPE.FAILURE)
                return
            }
        }
        else {
            if stMobileNo.isNumeric() {
                if !DataModel.validateMobileNo(stMobileNo) {
                    _KDAlertView.showMessage(message: MSG_TXT_MOBILE_NO_VALID, messageType: MESSAGE_TYPE.FAILURE)
                    return
                }
            }
            else {
                if !stMobileNo.characters.isEmpty && !DataModel.validateEmail(stMobileNo) {
                    _KDAlertView.showMessage(message: MSG_TXT_EMAIL_VALID, messageType: MESSAGE_TYPE.FAILURE)
                    return
                }
            }
        }
        if stPassword.characters.isEmpty {
            _KDAlertView.showMessage(message: MSG_TXT_PASSWORD, messageType: MESSAGE_TYPE.FAILURE)
            return
        }
        let params = [RES_mobileNo:stMobileNo,
                      "Login Type":"0",
                      FIR_SELECT_CONTENT:"Login"]
        self.FIRLogEvent(name: F_MODULE_ACCOUNT, parameters: params as [String : NSObject])
        
       
        self.callLoginService(SOCIAL_LOGIN.DUMMY, stMobile: stMobileNo, stPassword: stPassword)
    }
    
    fileprivate func callLoginService(_ loginType: SOCIAL_LOGIN, stMobile: String, stPassword: String) {
        
        var params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_U_MOBILE:stMobile,
                      REQ_U_PASS:stPassword,
                      REQ_LOGIN_TYPE:String(loginType.rawValue),
                      REQ_DEVICE_TOKEN:DataModel.getUDID(),
                      REQ_DEVICE_TYPE:VAL_DEVICE_TYPE,
                      REQ_DEVICE_ID:DataModel.getVendorIdentifier(),
                      REQ_DEVICE_VERSION:UIDevice.current.modelName,
                      REQ_DEVICE_NAME:DataModel.getDeviceName(),
                      REQ_APP_VERSION:DataModel.getAppVersion(),
                      REQ_LATITUDE:obj_Location.latitude,
                      REQ_LONGITUDE:obj_Location.longitude,
                      REQ_DEVICE_MAC_ID:DataModel.getIPAddress(),
                      REQ_OTP_CODE: ""]
        print(params)
        obj_OperationWeb.callRestApi(methodName: JMETHOD_UserLogin, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            DataModel.setHeaderToken(dict[RES_token] as! String)
            
            if dict[RES_otp_generate] as! String == "1" {
                //OTP AUTOFILL IN LOCAL
                params[REQ_U_MOBILE] = dict[RES_userMobileNo] as! String?
                params[REQ_HEADER] = DataModel.getHeaderToken()
                let _OTPView = OTPView(dictServicePara: params, otpType: OTP_TYPE.LOGIN)
                if dict["otp"] as! String != "" {
                   NotificationCenter.default.post(name: Notification.Name(rawValue: "OTP"), object: dict["otp"] as! String)
                }
                
                _OTPView.delegate = self
            }
            else { self.onOtpSuccess(OTP_TYPE.LOGIN, serviceResponse: dict) }
            
            
        }, onFailure: { (code , dict) in
            let message: String = dict[RES_message] as! String
            self._KDAlertView.showMessage(message: message, messageType: MESSAGE_TYPE.WARNING)
            return
        }) {self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING)}
        /*
         //LOGIN_TYPE = 0 : simple, 1: GP, 2 : FB
         U_MOBILE: email/ mobile
         U_PASS: fb & gp = "" , as it is
         DEVICE_TOKEN = gcm push notification
         DEVICE_TYPE = iPhone
         DEVICE_ID = vender identifier
         DEVICE_VERSION = iphone 5, 5s
         LATITUDE =
         LONGITUDE=
         DEVICE_NAME = ipad simulator
         APP_VERSION = 1.0
         */
    }
    
    fileprivate func callUpdateProfileService(userInfo:typeAliasDictionary,stImage:String) {
        
        let userId : String = userInfo[RES_userID] as! String
        let stFirstName: String = userInfo[RES_userFirstName] as! String
        let stLastName: String = userInfo[RES_userLastName] as! String
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_U_FNAME:stFirstName,
                      REQ_U_LNAME:stLastName,
                      REQ_U_EMAIL:userInfo[RES_userEmailId] as! String?,
                      REQ_GENDER:userInfo[RES_userSex] as! String?,
                      REQ_U_MOBILE:userInfo[RES_userMobileNo] as! String?,
                      REQ_USER_DOB:userInfo[RES_userDOB] as! String?,
                      REQ_USER_ID:userId,
                      REQ_DEVICE_TYPE:VAL_DEVICE_TYPE,
                      REQ_U_IMAGE:stImage]
        print(params)
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_updateProfile, methodType: .POST, isAddToken: false, parameters: params as! typeAliasStringDictionary, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            DataModel.setHeaderToken(dict[RES_token] as! String)
            
            var dictUserInfo: typeAliasDictionary = dict[RES_EditProfile]![RES_user_info] as! typeAliasDictionary
            dictUserInfo[RES_userID] = dictUserInfo["userId"]
            dictUserInfo.removeValue(forKey: "userId")
            DataModel.setUserInfo(dictUserInfo)
             self.navigateUser()
            
        }, onFailure: { (code , dict) in
             self.navigateUser()
            
        }) {self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return  }
        
    }
    
    //MARK: FB AND GOOGLE LOGIN DELEGATE
    func getSocialProfile(_ dictUserInfo: typeAliasDictionary) {
        
        self.hideKeyboard()
        print("Social Profile : \(dictUserInfo)")
        let params = [RES_emailId:dictUserInfo[SOCIAL_EMAIL] as! String,
                      "Login Type":self.obj_AppDelegate._SOCIAL_LOGIN == .FACEBOOK ? "Facebook" : "Google",
                      FIR_SELECT_CONTENT:"Social Login"]
        self.FIRLogEvent(name: F_MODULE_ACCOUNT, parameters: params as [String : NSObject])
        self.dictSocial = dictUserInfo
        if dictUserInfo[SOCIAL_EMAIL] == nil && dictUserInfo[SOCIAL_NAME] == nil { _KDAlertView.showMessage(message: MSG_ERR_SOMETING_WRONG, messageType: MESSAGE_TYPE.FAILURE)
            return
        }
        else {
            self.hideKeyboard()
            self.callLoginService(self.obj_AppDelegate._SOCIAL_LOGIN, stMobile: dictUserInfo[SOCIAL_EMAIL] as! String, stPassword: " ") }
    }
    
    
    //MARK:TEXT FIELD DELEGATE
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
           return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtMobileNoEmail {
            txtPassword.becomeFirstResponder()
            
        }
        else if textField == txtPassword {
            txtPassword.resignFirstResponder()
            
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        let text: String = textField.text!
        let resultingString: String = text.replacingCharacters(in: range.toRange(string: text), with: string)
        if resultingString.isEmpty
        {
          return true
        }
        
        if textField == txtMobileNoEmail  {
            var holder: Float = 0.00
            let scan: Scanner = Scanner(string: resultingString)
            let RET: Bool = scan.scanFloat(&holder) && scan.isAtEnd
            if string == "." { return false }
            if resultingString.count == 10 && textField == txtMobileNoEmail {
                txtMobileNoEmail.text = resultingString
                txtPassword.becomeFirstResponder()
                return false
            }
            if resultingString.count > 10 { return false }
            return RET
        }
        
        return true
    }
    
    @IBAction func btnLogin_SignupAction() {
        obj_AppDelegate.showSignUpPage()
    }
    
    //MARK: VKALERT ACTION DELEGATE
    
    func vkActionSheetAction(_ actionSheetType: ACTION_SHEET_TYPE, buttonIndex: Int, buttonTitle: String) {}
    func vkYesNoAlertAction(_alertType: ALERT_TYPE , buttonIndex:Int , buttonTitle:String) {}
    
    //MARK: OTP VIEW DELEGATE
    func onOtpSuccess(_ otpType: OTP_TYPE, serviceResponse: typeAliasDictionary) {
        var dictUserInfo: typeAliasDictionary = serviceResponse[RES_login]![RES_user_info] as! typeAliasDictionary
        dictUserInfo[RES_userID] = dictUserInfo["userId"]
        dictUserInfo.removeValue(forKey: "userId")
        DataModel.setUserInfo(dictUserInfo)
        DataModel.setNoMembershipFeesPayMsg(serviceResponse[RES_message] as! String)
       
        if serviceResponse[RES_login]![RES_membership_fee] != nil {
            DataModel.setMemberShipFees(serviceResponse[RES_login]![RES_membership_fee] as! String)
        }
        
        DataModel.setNotificationBadge(serviceResponse[RES_notification_count] as! String)
        if (dictUserInfo[RES_userProfileImage] as! String).isEmpty {
            if self.dictSocial[SOCIAL_PROFILE_IMAGE] != nil{
                let stImageBase64:String = (self.dictSocial[SOCIAL_PROFILE_IMAGE] as! UIImage).base64(format: ImageFormat.JPEG(0))
                self.callUpdateProfileService(userInfo: DataModel.getUserInfo(), stImage: stImageBase64)
            }
        }
        self.navigateUser()
    }
    
    func navigateUser() {
        
        self.obj_AppDelegate.onVKFooterAction(.HOME)
        if !self.obj_AppDelegate.isMemberShipFeesPaid() {
            obj_AppDelegate.showHowToEarnView(categoryID: "13")
        }
        else if !self.obj_AppDelegate.isReferralActive()  {
            DesignModel.stopActivityIndicator()
            if DataModel.getTodayDate() != nil && Calendar.current.isDateInToday(DataModel.getTodayDate()!) { return }
            else {
                DataModel.setTodayDate(date: Date())
                obj_AppDelegate.showHowToEarnView(categoryID: "12")
            }
        }
    }
    
    func dummy() {
        
        
        
    }

}
