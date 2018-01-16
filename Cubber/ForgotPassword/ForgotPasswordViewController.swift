//
//  ForgotPassword.swift
//  Cubber
//
//  Created by dnk on 11/11/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController , OTPViewDelegate, AppNavigationControllerDelegate
{
    fileprivate var _KDAlertView = KDAlertView()
    @IBOutlet var txtMobileEmail: UITextField!
    @IBOutlet var viewForgotPassword: UIView!
    internal var userId,userMobile: String!
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate let obj_Location = Location.init()
    fileprivate let obj_FBAndGoogleLogin = FBAndGoogleLogin()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if userMobile != "" {
            txtMobileEmail.text = userMobile
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        obj_AppDelegate.navigationController.setCustomTitle("Forgot Password")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
        self.sendScreenView(name: FORGOTPASSWORD)
     
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.SetScreenName(name: F_FORGOTPASSWORD, stclass: F_FORGOTPASSWORD)
    }
    
    func appNavigationController_BackAction() {
        let _ =  self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: CUSTOME METHODS
    fileprivate func hideKeyboard() {
        txtMobileEmail.resignFirstResponder()
    }
    
    //MARK: UITEXTFIELD DELEGATE
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
       
     return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtMobileEmail { txtMobileEmail.resignFirstResponder() }
        return true
    }
    
    
    @IBAction func btnContinue()
    {
        
        self.hideKeyboard()
        let stMobileNo: String = txtMobileEmail.text!.trim()
        
        if stMobileNo.isEmpty {
            if stMobileNo.characters.isEmpty { _KDAlertView.showMessage(message: MSG_TXT_MOBILE_NO_EMAIL, messageType: MESSAGE_TYPE.WARNING); return;
            }
        }
        else {
            if stMobileNo.isNumeric() {
                if !DataModel.validateMobileNo(stMobileNo) { _KDAlertView.showMessage(message: MSG_TXT_MOBILE_NO_VALID, messageType: MESSAGE_TYPE.WARNING); return;
                    
                }
            }
            else {
                if !stMobileNo.characters.isEmpty && !DataModel.validateEmail(stMobileNo) { _KDAlertView.showMessage(message: MSG_TXT_EMAIL_VALID, messageType: MESSAGE_TYPE.WARNING); return;
                }
            }
        }
        self.callForgotPasswordService(SOCIAL_LOGIN.DUMMY, stMobile: stMobileNo)
    }
    
    fileprivate func callForgotPasswordService(_ loginType: SOCIAL_LOGIN, stMobile: String) {
        
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
                      REQ_U_PASS:"",
                      REQ_OTP_CODE:""];
        obj_OperationWeb.callRestApi(methodName: JMETHOD_AuthenticatePassword, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
            
            DataModel.setHeaderToken(dict[RES_token] as! String)
            self.userMobile = stMobile
            
            let changePasswordVC = ChangePasswordViewController(nibName: "ChangePasswordViewController", bundle: nil)
            changePasswordVC.pageType = UPDATE_PASSWORD.FORGOT
            changePasswordVC.userMobile = self.userMobile
            self.navigationController?.pushViewController(changePasswordVC, animated: true)
            
            // params[REQ_HEADER] = DataModel.getHeaderToken()
            // let _OTPView = OTPView(dictServicePara: params, otpType: OTP_TYPE.FORGOT_PASSWORD)
            // _OTPView.delegate = self

        }, onFailure: { (code, dict) in
             self.userId = ""
            let message: String = dict[RES_message] as! String
            self._KDAlertView.showMessage(message: message, messageType: MESSAGE_TYPE.FAILURE); return;

        }) {
            self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return
        }
    }
    //MARK: OTP VIEW DELEGATE
    func onOtpSuccess(_ otpType: OTP_TYPE, serviceResponse: typeAliasDictionary) {
        let status: String = serviceResponse[RES_status] as! String
        if status == VAL_STATUS_SUCCESS
        {
            let changePasswordVC = ChangePasswordViewController(nibName: "ChangePasswordViewController", bundle: nil)
            changePasswordVC.pageType = UPDATE_PASSWORD.FORGOT
            changePasswordVC.userMobile = self.userMobile
            self.navigationController?.pushViewController(changePasswordVC, animated: true)
        }
        
    }

   
}
