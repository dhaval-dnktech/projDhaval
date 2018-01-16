//
//  SignUpViewController.swift
//  Cubber
//
//  Created by dnk on 26/08/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate, FBAndGoogleLoginDelegate, OTPViewDelegate, ReferalMobileHelpViewDelegate, ParentSelectionDelegate , AppNavigationControllerDelegate {
    
    //MARK: CONSTANT
    let REG_MOBILE_NO                   = "REG_MOBILE_NO"
    let REG_EMAIL_ID                    = "REG_EMAIL_ID"
    let REG_PASSWORD                    = "REG_PASSWORD"
    let REG_NAME                        = "REG_NAME"
    let REG_REFERRAL_MOBILE_NO          = "REG_REFERRAL_MOBILE_NO"
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate let obj_Location = Location.init()
    fileprivate let obj_FBAndGoogleLogin = FBAndGoogleLogin()
    fileprivate var dictSocialInfo = typeAliasDictionary()
    fileprivate var dictCubberAdminInfo = DataModel.getCubberAdminInfo()
    fileprivate var _KDAlertView = KDAlertView()
    internal var mobileNo :String = ""
    //MARK:PROPERTIES
    
    @IBOutlet var txtMobileNo: FloatLabelTextField!
    @IBOutlet var txtEmail: FloatLabelTextField!
    @IBOutlet var txtPassword: FloatLabelTextField!
    @IBOutlet var txtName: FloatLabelTextField!
    @IBOutlet var txtReferMobileNo: FloatLabelTextField!
    @IBOutlet var viewBGCollection: [UIView]!
    @IBOutlet var btnHideShowPassword: UIButton!
    @IBOutlet var btnHideShowConfirmPassword: UIButton!
    @IBOutlet var lblReferralMobileNoUser: UILabel!
    
    @IBOutlet var btnAgreeWith: UIButton!
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewLeft: UIView!
    @IBOutlet var viewRight: UIView!
    @IBOutlet var btnSocial_AgreeWith: UIButton!
    
    @IBOutlet var viewBGSocial: UIView!
    @IBOutlet var txtSocial_MobileNo: FloatLabelTextField!
    @IBOutlet var txtSocial_ReferralMobileNo: FloatLabelTextField!
    @IBOutlet var lblSocial_ReferralMobileNoUser: UILabel!
    
  
    @IBOutlet var lblSocialMessage: UILabel!
    let dictCategory = DataModel.getCategoryListResponse() as typeAliasDictionary

    override func viewDidLoad() {
        super.viewDidLoad()

        obj_FBAndGoogleLogin.delegate = self
        if obj_AppDelegate.referralCode != "" {
            txtReferMobileNo.text = obj_AppDelegate.referralCode
            self.callIsReferralUserService(obj_AppDelegate.referralCode, lblReferralUser: lblReferralMobileNoUser)
        }
        txtMobileNo.text = mobileNo
        if !mobileNo.isEmpty
        {
            txtEmail.becomeFirstResponder()
        }
        else {
            txtMobileNo.becomeFirstResponder()
        }
        viewBGSocial.isHidden = true
        scrollView.isHidden = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        self.setNavigationBar()
        
        for view:UIView in viewBGCollection {
            view.setViewBorder(UIColor.clear, borderWidth: 0, isShadow: false, cornerRadius: 5, backColor: view.backgroundColor!)
        }
         self.sendScreenView(name: SCREEN_SIGNUP)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lblSocialMessage.attributedText = (dictCategory[RES_signupScreenMessage] as! String).htmlAttributedString
        viewLeft.layer.addGradientColor(colors: [UIColor.white , COLOUR_DARK_GREEN])
        viewRight.layer.addGradientColor(colors: [COLOUR_DARK_GREEN , UIColor.white])
        self.registerForKeyboardNotifications()
        self.SetScreenName(name: F_SIGNUP, stclass: F_SIGNUP)

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
        obj_AppDelegate.navigationController.setCustomTitle("SignUp")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func hideKeyboard() {
        txtMobileNo.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        txtName.resignFirstResponder()
        txtReferMobileNo.resignFirstResponder()
        
        txtSocial_MobileNo.resignFirstResponder()
        txtSocial_ReferralMobileNo.resignFirstResponder()
        
    }
    
    
    fileprivate func callRegistrationService(_ loginType: SOCIAL_LOGIN, mobileNo: String, emailId: String, password: String, name: String, referralMobileNo: String) {
        let arrName: Array<String> = name.components(separatedBy: " ")
        let stFirstName: String = !arrName.isEmpty ? arrName[0] : ""
        let stLastName: String = arrName.count == 2 ? arrName[1] : ""
        
        var params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_U_FNAME:stFirstName,
                      REQ_U_LNAME:stLastName,
                      REQ_REFERREL_CODE:referralMobileNo,
                      REQ_U_EMAIL:emailId,
                      REQ_GENDER:"",
                      REQ_U_PASS:password,
                      REQ_U_MOBILE:mobileNo,
                      REQ_USER_DOB:"",
                      REQ_DEVICE_ID:DataModel.getVendorIdentifier(),
                      REQ_DEVICE_MAC_ID:DataModel.getIPAddress(),
                      REQ_DEVICE_TYPE:VAL_DEVICE_TYPE,
                      REQ_LOGIN_TYPE:String(loginType.rawValue),
                      REQ_DEVICE_TOKEN:DataModel.getUDID(),
                      REQ_DEVICE_VERSION:UIDevice.current.modelName,
                      REQ_LATITUDE:obj_Location.latitude,
                      REQ_LONGITUDE:obj_Location.longitude,
                      REQ_DEVICE_NAME:DataModel.getDeviceName(),
                      REQ_APP_VERSION:DataModel.getAppVersion(),
                      REQ_OTP_CODE:""]
        
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_UserRegistration, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            
            DataModel.setHeaderToken(dict[RES_token] as! String)
            params[REQ_HEADER] = DataModel.getHeaderToken()
            if dict[RES_otp_generate] as! String == "1" {
                params[REQ_U_MOBILE] = mobileNo
                let _OTPView = OTPView(dictServicePara: params, otpType: OTP_TYPE.REGISTRATION)
                _OTPView.delegate = self }
            else {
                var dictUserInfo: typeAliasDictionary = dict[RES_register]![RES_user_info] as! typeAliasDictionary
                DataModel.setNoMembershipFeesPayMsg(dict[RES_message] as! String)
                DataModel.setInviteFriendMsg(dict[RES_sharing_message] as! String)
                dictUserInfo[RES_userID] = dictUserInfo["userId"]
                dictUserInfo.removeValue(forKey: "userId")
                DataModel.setUserInfo(dictUserInfo)
                if dict[RES_register]![RES_membership_fee] != nil {
                    DataModel.setMemberShipFees(dict[RES_register]![RES_membership_fee] as! String)}
                self.onOtpSuccess(OTP_TYPE.REGISTRATION, serviceResponse: dict)
            }
            
        }, onFailure: { (code , dict) in
            let message: String = dict[RES_message] as! String
            self._KDAlertView.showMessage(message: message, messageType: MESSAGE_TYPE.FAILURE); return;
        }) { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return }
    }
    
    fileprivate func callSocialRegistrationService(_ loginType: SOCIAL_LOGIN, social_mobileNo: String, emailId: String, password: String, name: String, referralMobileNo: String) {
        let arrName: Array<String> = name.components(separatedBy: " ")
        let stFirstName: String = !arrName.isEmpty ? arrName[0] : ""
        let stLastName: String = arrName.count == 2 ? arrName[1] : ""
        
        var params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_U_FNAME:stFirstName,
                      REQ_U_LNAME:stLastName,
                      REQ_REFERREL_CODE:referralMobileNo,
                      REQ_U_EMAIL:emailId,
                      REQ_GENDER:"",
                      REQ_U_PASS:password,
                      REQ_U_MOBILE:social_mobileNo,
                      REQ_USER_DOB:"",
                      REQ_DEVICE_ID:DataModel.getVendorIdentifier(),
                      REQ_DEVICE_MAC_ID:DataModel.getIPAddress(),
                      REQ_DEVICE_TYPE:VAL_DEVICE_TYPE,
                      REQ_LOGIN_TYPE:String(loginType.rawValue),
                      REQ_DEVICE_TOKEN:DataModel.getUDID(),
                      REQ_DEVICE_VERSION:UIDevice.current.modelName,
                      REQ_LATITUDE:obj_Location.latitude,
                      REQ_LONGITUDE:obj_Location.longitude,
                      REQ_DEVICE_NAME:DataModel.getDeviceName(),
                      REQ_APP_VERSION:DataModel.getAppVersion(),
                      REQ_OTP_CODE:""]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_UserRegistration, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            
            DataModel.setHeaderToken(dict[RES_token] as! String)
            params[REQ_HEADER] = DataModel.getHeaderToken()
            if dict[RES_otp_generate] as! String == "1" {
                if dict[RES_register_required] as! String == "0" {
                   params[REQ_U_MOBILE] = dict[RES_userMobileNo] as! String?
                }
                let _OTPView = OTPView(dictServicePara: params, otpType: OTP_TYPE.REGISTRATION)
                _OTPView.delegate = self}
                
            else{
                var dictUserInfo: typeAliasDictionary = dict[RES_register]![RES_user_info] as! typeAliasDictionary
                DataModel.setNoMembershipFeesPayMsg(dict[RES_message] as! String)
                dictUserInfo[RES_userID] = dictUserInfo["userId"]
                dictUserInfo.removeValue(forKey: "userId")
                DataModel.setUserInfo(dictUserInfo)
                if dict[RES_register]![RES_membership_fee] != nil {
                    DataModel.setMemberShipFees(dict[RES_register]![RES_membership_fee] as! String)}
                self.onOtpSuccess(OTP_TYPE.REGISTRATION, serviceResponse: dict)
            }
            
        }, onFailure: { (code , dict) in
            
            if dict[RES_register_required] as! String == "1" {
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations:
                { self.viewBGSocial.alpha = 1; self.scrollView.alpha = 0 }) { (finished) in self.viewBGSocial.isHidden = false; self.scrollView.isHidden = true;
                    if self.obj_AppDelegate.referralCode != "" {
                        self.txtSocial_ReferralMobileNo.text = self.obj_AppDelegate.referralCode
                        self.callIsReferralUserService(self.obj_AppDelegate.referralCode, lblReferralUser: self.lblSocial_ReferralMobileNoUser)
                    }
                }
            }
            else { self._KDAlertView.showMessage(message: "Email id is already registered", messageType: MESSAGE_TYPE.FAILURE); return; }
            
        }) { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return }
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
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_updateProfile, methodType: .POST, isAddToken: false, parameters: params as! typeAliasStringDictionary, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            DataModel.setHeaderToken(dict[RES_token] as! String)
            
            var dictUserInfo: typeAliasDictionary = dict[RES_EditProfile]![RES_user_info] as! typeAliasDictionary
            dictUserInfo[RES_userID] = dictUserInfo["userId"]
            dictUserInfo.removeValue(forKey: "userId")
            DataModel.setUserInfo(dictUserInfo)
            self.obj_AppDelegate.onVKFooterAction(VK_FOOTER_TYPE.HOME)
            if !self.obj_AppDelegate.isMemberShipFeesPaid(){
                let howToEarnVC = HowToEarnViewController(nibName: "HowToEarnViewController", bundle: nil)
                howToEarnVC.categoryID = "13"
                self.navigationController?.pushViewController(howToEarnVC, animated: true)
            }
            
        }, onFailure: { (code , dict) in
            self.obj_AppDelegate.onVKFooterAction(VK_FOOTER_TYPE.HOME)
            if !self.obj_AppDelegate.isMemberShipFeesPaid(){
                let howToEarnVC = HowToEarnViewController(nibName: "HowToEarnViewController", bundle: nil)
                howToEarnVC.categoryID = "13"
                self.navigationController?.pushViewController(howToEarnVC, animated: true)
                
    }
        }) { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return }
    }
    
    func callIsReferralUserService(_ mobileNo: String, lblReferralUser: UILabel) {
        self.hideKeyboard()
        
        let params: typeAliasStringDictionary = [REQ_HEADER: DataModel.getHeaderToken(),
                                                 REQ_REFERREL_CODE: mobileNo]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_IsReferrelUser, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view!)!, onSuccess: { (dict) in
            DataModel.setHeaderToken(dict[RES_token] as! String)
            lblReferralUser.text = dict[RES_referrel_name] as? String
        }, onFailure: { (code,dict) in
            self.txtReferMobileNo.text = "";
            lblReferralUser.text = ""
            self._KDAlertView.showMessage(message: dict[RES_message] as! String, messageType: .FAILURE)
            return
        }) { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING) ;return}
    }

    @IBAction func btnShowPasswordAction() {
        let stPassword: String = txtPassword.text!.trim()
        if !stPassword.characters.isEmpty { txtPassword.isSecureTextEntry = !txtPassword.isSecureTextEntry ;btnHideShowPassword.isSelected = !btnHideShowPassword.isSelected}
        if !txtPassword.isSecureTextEntry {
            let font:UIFont = txtPassword.font!
            txtPassword.font = nil
            txtPassword.font = font
        }
    }
   
    
    @IBAction func btnReferralMobileNo_HelpAction() {
        
        _ = ReferalMobileHelpView.init(frame: UIScreen.main.bounds, strMobileNo: "")
    }
    
    @IBAction func btnSocial_ReferralMobileNo_HelpAction() {
        
        _ = ReferalMobileHelpView.init(frame: UIScreen.main.bounds, strMobileNo: "")
    }
    
    @IBAction func btnAgreeTermsAction() {
 
    }
    
    @IBAction func btnLoginAction() {
        obj_AppDelegate.showLoginView()
    }
    
    
    @IBAction func btnSignupAction() {
//        let mobileRechargeVC = MobileRechargeViewController(nibName: "MobileRechargeViewController", bundle: nil)
//        self.navigationController?.pushViewController(mobileRechargeVC, animated: true)
        
        self.hideKeyboard()
        
        let stMobileNo: String = txtMobileNo.text!.trim()
        let stEmailId: String = txtEmail.text!.trim()
        let stPassword: String = txtPassword.text!.trim()
        let stFirstAndLastName: String = txtName.text!.trim()
        let stReferralMobileNo: String = txtReferMobileNo.text!.trim()
        
        if stMobileNo.characters.isEmpty { _KDAlertView.showMessage(message: MSG_TXT_MOBILE_NO, messageType: MESSAGE_TYPE.WARNING); return; }
            
        else if !DataModel.validateMobileNo(stMobileNo) { _KDAlertView.showMessage(message: MSG_TXT_MOBILE_NO_VALID, messageType: MESSAGE_TYPE.WARNING); return; }
        
        if !stEmailId.characters.isEmpty && !DataModel.validateEmail(stEmailId) { _KDAlertView.showMessage(message: MSG_TXT_EMAIL_VALID, messageType: MESSAGE_TYPE.WARNING); return; }
        
        if stPassword.characters.isEmpty { _KDAlertView.showMessage(message: MSG_TXT_PASSWORD, messageType: MESSAGE_TYPE.WARNING); return; }
            
        else if !DataModel.validatePassword(stPassword) { _KDAlertView.showMessage(message: MSG_TXT_PASSWORD_VALID, messageType: MESSAGE_TYPE.WARNING); return; }
        
        if stFirstAndLastName.characters.isEmpty { _KDAlertView.showMessage(message: MSG_TXT_FIRST_AND_LAST_NAME, messageType: MESSAGE_TYPE.WARNING); return; }
        
        if !btnAgreeWith.isSelected   { _KDAlertView.showMessage(message: MSG_SEL_TERMS_CONDITIONS, messageType: MESSAGE_TYPE.WARNING); return; }
        
        let params = [RES_mobileNo:stMobileNo,
                      "Login Type":"0",
                      FIR_SELECT_CONTENT:"Registeration"]
        self.FIRLogEvent(name: F_MODULE_ACCOUNT, parameters: params as [String : NSObject])
        
        self.callRegistrationService(SOCIAL_LOGIN.DUMMY, mobileNo: stMobileNo, emailId: stEmailId, password: stPassword, name: stFirstAndLastName, referralMobileNo: stReferralMobileNo)
    }
    
    @IBAction func btnAgreeWithAction() { btnAgreeWith.isSelected = !btnAgreeWith.isSelected }
    
     @IBAction func btnSocial_AgreeWithAction(_ sender: UIButton) { btnSocial_AgreeWith.isSelected = !btnSocial_AgreeWith.isSelected }
    
    @IBAction func btnFBSignUpAction() { self.hideKeyboard(); obj_FBAndGoogleLogin.performFBLoginAction(self);
            self.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_SIGNUP)", action: "\(SCREEN_SIGNUP): FB SIGN UP", label: "Sign up from FB", value: nil)}
        
    @IBAction func btnGoogleSignUpAction() { self.hideKeyboard(); obj_FBAndGoogleLogin.performGoogleLoginAction(self);
            self.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_SIGNUP)", action: "\(SCREEN_SIGNUP): GOOGLE SIGN UP", label: "Sign up from Google", value: nil)}
    
    
    @IBAction func btnSocial_ContinueAction() {
        self.hideKeyboard()
        
        let stMobileNo: String = txtSocial_MobileNo.text!.trim()
        let stReferralMobileNo: String =  txtSocial_ReferralMobileNo.text!.trim()
        if stMobileNo.characters.isEmpty { _KDAlertView.showMessage(message: MSG_TXT_MOBILE_NO, messageType: MESSAGE_TYPE.FAILURE)
        return
        }
            
        else if !DataModel.validateMobileNo(stMobileNo) {
            _KDAlertView.showMessage(message: MSG_TXT_MOBILE_NO_VALID, messageType: MESSAGE_TYPE.FAILURE)
            return
        }
        
        if !btnSocial_AgreeWith.isSelected { _KDAlertView.showMessage(message: MSG_SEL_TERMS_CONDITIONS, messageType: MESSAGE_TYPE.FAILURE)
            return
        }
        
        self.callSocialRegistrationService(obj_AppDelegate._SOCIAL_LOGIN, social_mobileNo: stMobileNo, emailId: self.dictSocialInfo[SOCIAL_EMAIL] as! String, password: " ", name: self.dictSocialInfo[SOCIAL_NAME] as! String, referralMobileNo: stReferralMobileNo)
    }
    
    @IBAction func btnSocial_CancelAction() {
        self.hideKeyboard()
        self.dictSocialInfo = typeAliasDictionary()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations:
        { self.viewBGSocial.alpha = 0; self.scrollView.alpha = 1 }) { (finished) in self.viewBGSocial.isHidden = true; self.scrollView.isHidden = false; self.txtSocial_ReferralMobileNo.text = ""; self.txtSocial_MobileNo.text = ""; self.btnSocial_AgreeWith.isSelected = false }
    }
    
    @IBAction func btnTermsAndConditionsAction() {
        let _ = TermsAndCondView.init(typeAliasDictionary() , isSignUP:true, isPrivacyPolicy:false)
    }
    
    @IBAction func btnPrivacyPolicyAction() {
       let _ = TermsAndCondView.init(typeAliasDictionary() , isSignUP:true, isPrivacyPolicy:true)
    }
    
    //MARK:REFERENCE MOBILEVIEW DELEGATE 
    
    func sendReferelNo(stMobileNo: String, stReferLabel: UILabel) {
        
        if !self.dictSocialInfo.isEmpty {
            txtSocial_ReferralMobileNo.text = stMobileNo
            lblSocial_ReferralMobileNoUser.text = stReferLabel.text
            txtReferMobileNo.text = ""
            lblReferralMobileNoUser.text = ""
        }
        else{
            txtSocial_ReferralMobileNo.text = ""
            lblSocial_ReferralMobileNoUser.text = ""
            txtReferMobileNo.text = stMobileNo
            lblReferralMobileNoUser.text = stReferLabel.text

        }
    }
    
    //MARK:TEXT FIELD DELEGATE
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        let stMobileNo:String = txtMobileNo.text!.trim()
        if textField == txtReferMobileNo {
        
            if stMobileNo.isEmpty {
                _KDAlertView.showMessage(message: MSG_TXT_MOBILE_NO, messageType: MESSAGE_TYPE.WARNING)
               
            }
            else if !DataModel.validateMobileNo(stMobileNo) { _KDAlertView.showMessage(message: MSG_TXT_MOBILE_NO_VALID, messageType: MESSAGE_TYPE.WARNING)
            }
            else{
                self.hideKeyboard()
                let _ReferalMobileHelpView = ReferalMobileHelpView.init(frame: UIScreen.main.bounds, strMobileNo: stMobileNo)
                _ReferalMobileHelpView.referealDelegate = self
            }
            return false
        }
        else if textField == txtSocial_ReferralMobileNo {
            self.hideKeyboard()
            let _ReferalMobileHelpView = ReferalMobileHelpView.init(frame: UIScreen.main.bounds, strMobileNo: stMobileNo)
            _ReferalMobileHelpView.referealDelegate = self
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtMobileNo { txtEmail.becomeFirstResponder() }
        else if textField == txtEmail { txtPassword.becomeFirstResponder() }
         else if textField == txtPassword { txtName.becomeFirstResponder() }
        else if textField == txtName { txtName.resignFirstResponder() }
        else if textField == txtReferMobileNo { txtReferMobileNo.resignFirstResponder() }
        else if textField == txtSocial_MobileNo { txtSocial_ReferralMobileNo.becomeFirstResponder() }
        else if textField == txtSocial_ReferralMobileNo { txtSocial_ReferralMobileNo.resignFirstResponder() }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text: String = textField.text!
        let resultingString: String = text.replacingCharacters(in: range.toRange(string: text), with: string)

        if resultingString.isEmpty { return true }
        
        if textField == txtMobileNo || textField == txtReferMobileNo || textField == txtSocial_MobileNo || textField == txtSocial_ReferralMobileNo {
            var holder: Float = 0.00
            let scan: Scanner = Scanner(string: resultingString)
            let RET: Bool = scan.scanFloat(&holder) && scan.isAtEnd
            if string == "." { return false }
            if resultingString.count == 10 && textField == txtMobileNo {
                txtMobileNo.text = resultingString
                txtEmail.becomeFirstResponder()
                return false
            }
            if resultingString.count > 10 { return false }
            
            if textField == txtReferMobileNo && RET {
                lblReferralMobileNoUser.text = ""
                if resultingString.count == 10 { self.callIsReferralUserService(resultingString, lblReferralUser: lblReferralMobileNoUser); txtReferMobileNo.text = resultingString }
            }
                
            else if textField == txtSocial_ReferralMobileNo && RET {
                lblSocial_ReferralMobileNoUser.text = ""
                if resultingString.characters.count == 10 { self.callIsReferralUserService(resultingString, lblReferralUser: lblSocial_ReferralMobileNoUser); txtSocial_ReferralMobileNo.text = resultingString }
            }

            return RET
        }
        return true
    }
    
    //MARK: FB AND GOOGLE LOGIN DELEGATE
    func getSocialProfile(_ dictUserInfo: typeAliasDictionary) {
        if dictUserInfo[SOCIAL_EMAIL] == nil && dictUserInfo[SOCIAL_NAME] == nil {
            _KDAlertView.showMessage(message: MSG_ERR_SOCIAL_LOGIN, messageType: .FAILURE)
            return
        }
        else {
            self.hideKeyboard()
            self.dictSocialInfo = dictUserInfo
            self.callSocialRegistrationService(obj_AppDelegate._SOCIAL_LOGIN, social_mobileNo: "", emailId: self.dictSocialInfo[SOCIAL_EMAIL] as! String, password: " ", name: self.dictSocialInfo[SOCIAL_NAME] as! String, referralMobileNo: "")
            let params = [RES_mobileNo:self.dictSocialInfo[SOCIAL_EMAIL]!,
                          "Login Type":obj_AppDelegate._SOCIAL_LOGIN == .FACEBOOK ? "Facebook" : "Google",
                          FIR_SELECT_CONTENT:"Registeration"] as [String : Any]
            self.FIRLogEvent(name: F_MODULE_ACCOUNT, parameters: params as! [String : NSObject])
        }
    }
    
    //MARK: PARENT SELECTION DELEGATE
    func onParentSelection(_ stParentMobileNo: String) {
        
        if self.dictSocialInfo.isEmpty {
            self.txtReferMobileNo.text = stParentMobileNo
            self.callIsReferralUserService(stParentMobileNo, lblReferralUser: lblReferralMobileNoUser)
        }
        else {
            self.txtSocial_ReferralMobileNo.text = stParentMobileNo
            self.callIsReferralUserService(stParentMobileNo, lblReferralUser: lblSocial_ReferralMobileNoUser)
        }
    }

    //MARK: OTP VIEW DELEGATE
    func onOtpSuccess(_ otpType: OTP_TYPE, serviceResponse: typeAliasDictionary) {
        
        let label:String = DataModel.getUserInfo().isEmpty ? "" : DataModel.getUserInfo().isKeyNull(RES_userID) ? "" : DataModel.getUserInfo()[RES_userID] as! String
        let tracker = GAI.sharedInstance().defaultTracker
        tracker!.send(GAIDictionaryBuilder.createEvent(withCategory: "Registered User ", action: "Register", label: label, value: nil).build() as [NSObject : AnyObject])
        
        if (DataModel.getUserInfo()[RES_userProfileImage] as! String).isEmpty{
            if self.dictSocialInfo[SOCIAL_PROFILE_IMAGE] != nil {
                let stImageBase64:String = (self.dictSocialInfo[SOCIAL_PROFILE_IMAGE] as! UIImage).base64(format: ImageFormat.JPEG(0))
                self.callUpdateProfileService(userInfo: DataModel.getUserInfo(), stImage: stImageBase64)
            }
            else {
                obj_AppDelegate.onVKFooterAction(VK_FOOTER_TYPE.HOME)
                if !obj_AppDelegate.isMemberShipFeesPaid(){
                    let howToEarnVC = HowToEarnViewController(nibName: "HowToEarnViewController", bundle: nil)
                    howToEarnVC.categoryID = "13"
                    self.navigationController?.pushViewController(howToEarnVC, animated: true)}
            }
        }
        else {
            obj_AppDelegate.onVKFooterAction(VK_FOOTER_TYPE.HOME)
            if !obj_AppDelegate.isMemberShipFeesPaid(){
                let howToEarnVC = HowToEarnViewController(nibName: "HowToEarnViewController", bundle: nil)
                howToEarnVC.categoryID = "13"
                self.navigationController?.pushViewController(howToEarnVC, animated: true)}
        }
    }
}
