//
//  SplashViewController.swift
//  Cubber
//
//  Created by Vyas Kishan on 19/07/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import CoreLocation
import SafariServices

class SplashViewController: UIViewController, VKToastDelegate , UNUserNotificationCenterDelegate , UIApplicationDelegate ,  CLLocationManagerDelegate , SFSafariViewControllerDelegate{

    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate let _KDAlertView = KDAlertView()
   
    fileprivate var isNotificationLaunch:Bool = false
    internal var stMaintananceMsg:String = ""
  
    //MARK: VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if stMaintananceMsg != ""{
            self._KDAlertView.showMessage(message: stMaintananceMsg, messageType: MESSAGE_TYPE.WARNING)
            return
        }
       self.registerForAPNS()
 
    NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotifications), name: NSNotification.Name(rawValue: NOTIFICATION_LAUNCH_WITH_NOTIFICATION), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.sendScreenView(name: SCREEN_SPLASH)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.SetScreenName(name: F_SPLASH, stclass: F_SPLASH)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func registerForAPNS() {
        
       if #available(iOS 10.0, *) {
            let current = UNUserNotificationCenter.current()
            current.getNotificationSettings(completionHandler: { (settings) in
                if settings.authorizationStatus == .notDetermined {
                    UNUserNotificationCenter.current().delegate = self.obj_AppDelegate
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]){
                        (granted,error) in
                        if granted {
                            
                            DataModel.setIsNotificationEnabled(true)
                            DispatchQueue.main.async {
                                if self.obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_CategoryList) {
                                    self.callCategoryService()
                                }
                                else { self.setCategoryListData() }
                               UIApplication.shared.registerForRemoteNotifications()
                            }
                            
                        } else {
                            if self.obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_CategoryList) {
                                self.callCategoryService()
                            }
                            else { self.setCategoryListData() }
                            print("User Notification permission denied: \(String(describing: error?.localizedDescription))")
                        }
                    }
                }
                
                else if settings.authorizationStatus == .denied {
                    DispatchQueue.main.async {
                        if self.obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_CategoryList) {
                            self.callCategoryService()
                        }
                        else { self.setCategoryListData() }
                    }
                }
                
                else if settings.authorizationStatus == .authorized {
                    DispatchQueue.main.async {
                        if self.obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_CategoryList) {
                            self.callCategoryService()
                        }
                        else { self.setCategoryListData() }
                    }
                }
            })
            
        }
        else if UIApplication.shared.isRegisteredForRemoteNotifications  {
            if obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_CategoryList) {
                callCategoryService()
            }
            else { self.setCategoryListData() }
        }
        else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.delegate = obj_AppDelegate
        }
        
        
        
      /*  if UIApplication.shared.isRegisteredForRemoteNotifications || DataModel.getISNotificationEnabled() {

            if obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_CategoryList) {
                callCategoryService()
            }
            else { self.setCategoryListData() }
        }
            
        else {
            
            if #available(iOS 10.0, *) {
                // For iOS 10 display notification (sent via APNS)
                UNUserNotificationCenter.current().delegate = self
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]){
                    (granted,error) in
                    if granted {
                        DataModel.setIsNotificationEnabled(true)
                        UIApplication.shared.registerForRemoteNotifications()
                        DispatchQueue.main.async {self.showLocationPrompt()}
                        
                    } else {
                        DispatchQueue.main.async {self.showLocationPrompt()}
                        print("User Notification permission denied: \(String(describing: error?.localizedDescription))")
                    }
                }
                
            } else {
                let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(settings)
                UIApplication.shared.delegate = obj_AppDelegate
            }
        }*/
    }
    
    //MARK: CUSTOM METHODS
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.host?.uppercased() == HOST_REFERRAL {
            let dictRef = url.getDataFromQueryString()
            obj_AppDelegate.referralCode = dictRef["code"]!
            obj_AppDelegate.showSignUpPage()
        }
        return true
    }
    
    func handlePushNotifications() {
        isNotificationLaunch = true
    }
    
    func showLocationPrompt() {
        
        if self.self.obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_CategoryList) {
            self.self.callCategoryService()
        }
        else { self.setCategoryListData() }
        
     /*   let locationManager = CLLocationManager()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            let authorizationStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
            if authorizationStatus == CLAuthorizationStatus.denied || authorizationStatus == CLAuthorizationStatus.restricted { print("Authorization Status Falied") }
            else {
                if self.self.obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_CategoryList) {
                    self.self.callCategoryService()
                }
                else { self.setCategoryListData() }
            }
        }
        else {
            
        }*/
    }
    
    internal func callCategoryService() {
        
        print("Serviced Count 1")
        let obj_Location = Location.init()
        let stAppVersion = DataModel.getAppVersion()
        let dictUser = DataModel.getUserInfo()
        var userID:String = ""
        userID = dictUser[RES_userID] == nil ? "" :  dictUser[RES_userID] as! String
        
                
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_DEVICE_TOKEN:DataModel.getUDID(),
                      REQ_DEVICE_TYPE:VAL_DEVICE_TYPE,
                      REQ_DEVICE_ID:DataModel.getVendorIdentifier(),
                      REQ_DEVICE_VERSION:UIDevice.current.modelName,
                      REQ_DEVICE_NAME:DataModel.getDeviceName(),
                      REQ_APP_VERSION:stAppVersion,
                      REQ_LATITUDE:obj_Location.latitude,
                      REQ_LONGITUDE:obj_Location.longitude,
                      REQ_USER_ID:userID,
                      REQ_DEVICE_MAC_ID:DataModel.getIPAddress()]
        
            var dictAppVersionUpdate = typeAliasStringDictionary()
  obj_OperationWeb.callRestApi(methodName: JMETHOD_CategoryList, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: self.view, onSuccess: { (dict) in
    
        DataModel.setHeaderToken(dict[RES_token] as! String)
        DataModel.setTrustedLogo(dict[RES_trusted_logo] as! String)
        DataModel.setPlanRechargeNote(dict[RES_recharge_plan_note] as! String)
        let arrHome: [typeAliasDictionary] = dict[RES_data] as! [typeAliasDictionary] //Convert AnyObject To Array
        if !arrHome.isEmpty { DataModel.setHomeMenu(arrHome) }
        DataModel.setIsDisplayTLogo(dict[RES_is_display_tlogo] as! String)
        //DataModel.setNotificationBadge(dict[RES_notification_count] as! String)
        DataModel.setLogoutNote(dict[RES_logoutNote] as! String)
        self.obj_AppDelegate.membershipTitle = dict[RES_member_order_title] as! String
        let stVersions:String = dict[RES_ios_version] as! String
        let arrVersion: [String] = stVersions.components(separatedBy: ",")
        self.obj_AppDelegate.isFirstServiceCall = false
        let dictCubberAdminInfo: typeAliasStringDictionary = [RES_cubber_admin: dict[RES_cubber_admin] != nil ? dict[RES_cubber_admin] as! String : "", RES_cubber_mobile_no: dict[RES_cubber_mobile_no] as! String]
        DataModel.setCubberAdminInfo(dictCubberAdminInfo)
    
        let dictServiceUpdate:typeAliasDictionary = dict[RES_serviceUpdate] as! typeAliasDictionary
        DataModel.setCategoryListResponse(dict: dict)
        if userID != "" { self.obj_AppDelegate.setServiceUpdateData(dictServiceUpdate: dictServiceUpdate) ; DataModel.setCategoryListResponse(dict: dict); self.obj_AppDelegate.updateDictService(serviceName: JMETHOD_CategoryList) }
        
        if (dict[RES_is_maintenance] as! String == "1"){
            let message: String = dict[RES_maintenance_message] as! String
            self._KDAlertView.showMessage(message: message, messageType: MESSAGE_TYPE.WARNING)
            return
        }

    
        if !DataModel.getUserInfo().isEmpty {
           // DataModel.setInviteFriendMsg(dict[RES_sharing_message] as! String)
            DataModel.setIsSetFriendInvteFriendMessage(true)
        }
    
        if (dict[RES_ratingFlag] as! String == "1") {
            DataModel.setIsShowReviewPrompt(true)
        }
        else{ DataModel.setIsShowReviewPrompt(false) }
    
        if !arrVersion.contains(stAppVersion) {
            dictAppVersionUpdate[RES_ios_update_msg] = dict[RES_ios_update_msg] as? String;
            dictAppVersionUpdate[RES_isComplusory] = dict[RES_isComplusory] as? String
        }
    
        self.obj_AppDelegate.dictAppVersionUpdate = dictAppVersionUpdate
        if dict[RES_schedule_maintenance_message] as! String != "" {
            self.obj_AppDelegate.stMaintananceMessage = dict[RES_schedule_maintenance_message] as! String }
        self.navigateUser(dict: dict)
    
    
    }, onFailure: { (code , dict) in self.obj_AppDelegate.dictAppVersionUpdate = dictAppVersionUpdate
        let message = dict[RES_message] as! String
        self._KDAlertView.showMessage(message: message, messageType: MESSAGE_TYPE.FAILURE)
        return

        }) {
                self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .INTERNET_WARNING)
            self._KDAlertView.didClick(completion: { (isClicked) in
                self.callCategoryService()
            })
        }
    }
    
    func setCategoryListData() {
        
            let stAppVersion = DataModel.getAppVersion()
            var dictAppVersionUpdate = typeAliasStringDictionary()
            let dict = DataModel.getCategoryListResponse()
            DataModel.setPlanRechargeNote(dict[RES_recharge_plan_note] as! String)
            let arrHome: [typeAliasDictionary] = dict[RES_data] as! [typeAliasDictionary] //Convert AnyObject To Array
            if !arrHome.isEmpty { DataModel.setHomeMenu(arrHome) }
            DataModel.setIsDisplayTLogo(dict[RES_is_display_tlogo] as! String)
        
            let stVersions:String = dict[RES_ios_version] as! String
            let arrVersion: [String] = stVersions.components(separatedBy: ",")
            self.obj_AppDelegate.membershipTitle = dict[RES_member_order_title] as! String
            let dictCubberAdminInfo: typeAliasStringDictionary = [RES_cubber_admin: dict[RES_cubber_admin] != nil ? dict[RES_cubber_admin] as! String : "", RES_cubber_mobile_no: dict[RES_cubber_mobile_no] as! String]
            DataModel.setCubberAdminInfo(dictCubberAdminInfo)
            DataModel.setCubberMaintananceMessage(dict[RES_maintenance_message] as! String)
            if (dict[RES_is_maintenance] as! String == "1"){
                let message: String = dict[RES_maintenance_message] as! String
                self._KDAlertView.showMessage(message: message, messageType: MESSAGE_TYPE.WARNING)
                return
            }
            if !DataModel.getUserInfo().isEmpty {
//                DataModel.setInviteFriendMsg(dict[RES_sharing_message] as! String)
                DataModel.setIsSetFriendInvteFriendMessage(true)
            }
            
            if (dict[RES_ratingFlag] as! String == "1") {
                DataModel.setIsShowReviewPrompt(true)
            }
            else{ DataModel.setIsShowReviewPrompt(false) }
            
            if !arrVersion.contains(stAppVersion) {
                dictAppVersionUpdate[RES_ios_update_msg] = dict[RES_ios_update_msg] as? String;
                dictAppVersionUpdate[RES_isComplusory] = dict[RES_isComplusory] as? String
            }
            
            self.obj_AppDelegate.dictAppVersionUpdate = dictAppVersionUpdate
            if dict[RES_schedule_maintenance_message] as! String != "" {
                self.obj_AppDelegate.stMaintananceMessage = dict[RES_schedule_maintenance_message] as! String }
            self.navigateUser(dict: dict)
    }
    
    //MARK: APNS
    
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        controller.dismiss(animated: false, completion: nil)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: false, completion: nil)
    }
    
    func navigateUser(dict:typeAliasDictionary) {
        
         let dictUser =  DataModel.getUserInfo()
        
        if self.obj_AppDelegate.referralCode != "" || DataModel.getIsAppInstallFirstTime() {
                if self.obj_AppDelegate.referralCode != "" {
                    self.obj_AppDelegate.showStartView()
                }
                else {
                    self.obj_AppDelegate.isSafari = true
                    let redirectUrl = URL(string: "https://www.cubber.in/ref/redirect")!
                    let safariViewController = SFSafariViewController(url: redirectUrl)
                    safariViewController.delegate = self
                    safariViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    safariViewController.view.alpha = 0.05
                    self.present(safariViewController, animated: false, completion: nil)
                    
                   }
            }
            else if DataModel.getUserInfo().isEmpty {
                self.obj_AppDelegate.showStartView()
            }
            else if dictUser[RES_affiliateId] == nil {
                self.obj_AppDelegate.showStartView()
            }
            else  if dictUser[RES_affiliateId] as! String == "" {
                self.obj_AppDelegate.showStartView()
            }
            else {
                self.obj_AppDelegate.showHomeView()
                self.trackEvent(category: MAIN_CATEGORY+SCREEN_LOGIN, action: SCREEN_LOGIN, label: "User not logged in", value: nil)
            }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Tapped in notification")
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler( [.alert, .badge, .sound])
    }
}
