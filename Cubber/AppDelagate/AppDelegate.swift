//
//  AppDelegate.swift
//  Cubber
//
//  Created by dnk on 26/08/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit
import CoreLocation
import SafariServices
import FirebaseInstanceID
import FirebaseMessaging
import FirebaseCrash
import Firebase
import UserNotifications
import Google
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate , MessagingDelegate , CLLocationManagerDelegate , SFSafariViewControllerDelegate , TAGContainerOpenerNotifier  {
    
    var window: UIWindow?
    var navigationController: AppNavigationController!
    var _SOCIAL_LOGIN: SOCIAL_LOGIN = SOCIAL_LOGIN.DUMMY
    fileprivate var dictRemoteNotification = typeAliasDictionary()
    var isCouponServiceCall: Bool = false
    internal var dictAppVersionUpdate = typeAliasStringDictionary()
    internal var isShowVersionUpdate:Bool = true
    internal var stMaintananceMessage:String = ""
    internal var referralCode:String = ""
    var isNotificationLaunch:Bool = false
    var isSafari:Bool =  false
    var isBackGround:Bool = false
    fileprivate let obj_OperationWeb = OperationWeb()
    let locationManager = CLLocationManager()
    var safariViewController: SFSafariViewController!
    internal var membershipTitle = "Membership Fees"
    internal var galleryUrl : String = ""
    internal var isShowNotPrimeMemberAlert:Bool = true
    internal var isFirstServiceCall:Bool = true
    internal var isReloadHomeScreen:Bool = true
    internal var isWalletUpdate:Bool = false
    internal var stRechargeImage:String = ""
    var navigationBarColor:UIColor?
    fileprivate let obj_DatabaseModel = DatabaseModel()
    let reachability:Reachability = Reachability()!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        let startVC = SplashViewController(nibName: "SplashViewController", bundle: nil)
        navigationController = AppNavigationController.init(rootViewController: startVC)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        self.window?.backgroundColor = UIColor.white
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        obj_DatabaseModel.createDatabase()
        Fabric.with([Crashlytics.self])
        checkInternetConnection()
        //COMPARE VERSION
        if DataModel.getLastVersion() != DataModel.getAppVersion()
        {
            self.clearAppData()
            // self.unRegisterForPushNotifications()
            //self.registerForPushNotifications(application)
            DataModel.setIsNeverShowReviewPrompt(false)
            DataModel.setIsNotificationEnabled(false)
        }
        DataModel.setLastVersion(DataModel.getAppVersion())
        
        if DataModel.getUserInfo().isEmpty {
            if DataModel.getHomeMenu().isEmpty {
                DataModel.setIsAppInstallFirstTime(true);
                DataModel.setIsNeverShowReviewPrompt(false)
                self.setServiceUpdateData(dictServiceUpdate: typeAliasDictionary())
                self.setIsTutorialForcefully(value: "")
                DataModel.setIsNotificationEnabled(false)
            }
            else { DataModel.setIsAppInstallFirstTime(false) }
            DataModel.setIsShowIntroSlider(true)
        }
        else {
            DataModel.setIsAppInstallFirstTime(false)
        }
        DataModel.setUserWalletResponse(dict: typeAliasDictionary())
        DataModel.setUsedWalletResponse(dict: typeAliasDictionary())
        DataModel.setIsSetFriendInvteFriendMessage(false)
        DataModel.setArrSelectedSeat(array: [typeAliasStringDictionary]())
        
        if let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? typeAliasDictionary {
            dictRemoteNotification = notification
        }
        
        //FACE BOOK
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai?.trackUncaughtExceptions = true  // report uncaught exceptions
        gai?.logger.logLevel = GAILogLevel.verbose  // remove before app release
        _ = gai?.tracker(withTrackingId: "UA-105052808-1") //UA-78834038-1 LIVE //UA-105052808-1 LOCAL
        
        let GTM = TAGManager.instance()
        GTM?.logger.setLogLevel(kTAGLoggerLogLevelVerbose)
        TAGContainerOpener.openContainer(withId: "GTM-W2FD7FT",// change the container ID "GTM-KS6TMJG" to LIVE And "GTM-W2FD7FT" FOR LOCAL
            tagManager: GTM, openType: kTAGOpenTypePreferFresh,
            timeout: nil,
            notifier: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeInputMode(notification:)), name: NSNotification.Name.UITextInputCurrentInputModeDidChange, object: nil)
        
        return true
    }
    
    func changeInputMode(notification : NSNotification)
    {
        let inputMethod = UITextInputMode.activeInputModes.first
        print("inputMethod: \(String(describing: inputMethod))")
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        isBackGround = true
        isReloadHomeScreen = true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        FBSDKAppEvents.activateApp();
        if !dictRemoteNotification.isEmpty {
            isNotificationLaunch = true;
            self.performPushNotification(application, userInfo: dictRemoteNotification);
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if url.scheme?.uppercased() == SCHEME_CUBBER && url.host?.uppercased() == HOST_REFERRAL {
            let dictRef = url.getDataFromQueryString()
            if DataModel.getUserInfo().isEmpty {
                if dictRef["code"]! != "" && dictRef["code"]! != "0" && dictRef["code"]! != "redirect" {
                    self.referralCode = dictRef["code"]!
                }
                else {
                    self.referralCode = ""
                }
                self.showStartView()
            }
            return true
        }
        
        switch self._SOCIAL_LOGIN {
        case .FACEBOOK:
            return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        case .GOOGLE:
            return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
        default:
            return true
        }
    }
    
    func inputModeChanged(){
        
    }
    
    //MARK: PUSH NOTIFICATIONS
    
    //MARK: APNS
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != UIUserNotificationType() { application.registerForRemoteNotifications() }
        if (navigationController.viewControllers.last?.isKind(of: SplashViewController.classForCoder()))! {
            let splashVC = navigationController.viewControllers.last as! SplashViewController
            splashVC.callCategoryService()
        }
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString: String = ""
        for i in 0..<deviceToken.count { tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]]) }
        print("Device Token: \(tokenString)")
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.prod)
        Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.sandbox)
        print("Token : \(String(describing: Messaging.messaging().fcmToken != nil ? Messaging.messaging().fcmToken : "" ))")
        DataModel.setUDID(Messaging.messaging().fcmToken != nil ? Messaging.messaging().fcmToken! : "@" )
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        DataModel.setUDID(fcmToken)
        print("Refreshed Token:\(fcmToken)")
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
    }
    
    internal func unRegisterForPushNotifications() {
        UIApplication.shared.unregisterForRemoteNotifications() }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        DataModel.setUDID(VAL_SERVICE_STATIC)
        if (navigationController.viewControllers.last?.isKind(of: SplashViewController.classForCoder()))! {
            let splashVC = navigationController.viewControllers.last as! SplashViewController
            splashVC.callCategoryService()
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
        print("Notification PayLoad : \(userInfo)")
        if #available(iOS 10.0, *) {
            dictRemoteNotification = userInfo as! typeAliasDictionary
            UNUserNotificationCenter.current().delegate = self
        }
        else {
            self.performPushNotification(application, userInfo: userInfo as! typeAliasDictionary)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        UIApplication.shared.applicationIconBadgeNumber += 1
        print("Notification PayLoad : \(userInfo)")
        if #available(iOS 10.0, *) {
            dictRemoteNotification = userInfo as! typeAliasDictionary
            UNUserNotificationCenter.current().delegate = self
        }
        else{
            self.performPushNotification(application, userInfo: userInfo as! typeAliasDictionary)
        }
    }
    
    internal func registerForPushNotifications(_ application: UIApplication) {
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]){
                (granted,error) in
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                } else {
                    print("User Notification permission denied: \(String(describing: error?.localizedDescription))")
                }
            }
        } else {
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        }
    }
    
    //MARK: HANDLE PUSH
    
    fileprivate func performPushNotification(_ application: UIApplication, userInfo: typeAliasDictionary) {
        let appState: UIApplicationState = application.applicationState
        
        switch appState {
        case .active:
            if !userInfo.isEmpty {
                
                let dictNotification: typeAliasDictionary = (userInfo[RES_data] as! String).convertToDictionary2()
                if dictNotification[RES_nTypeID] != nil && ( dictNotification[RES_nTypeID] as! String == "1" || dictNotification[RES_nTypeID] as! String == "2") {
                    self.isWalletUpdate = true
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_RECALL_WALLET), object: nil, userInfo: nil)
                }
                // let dictNotification: typeAliasDictionary = userInfo
                if dictNotification["isSave"] as! String == "1" {
                    self.callReadNotificationService(id: dictNotification[RES_notificationID] as! String , userInfo:userInfo , isNotifLaunch:isNotificationLaunch)
                }
                    
                else if isNotificationLaunch {
                    
                    if !isBackGround {
                        DataModel.setDictUserNotification(userInfo)
                    }
                    else {
                        DataModel.setDictUserNotification(typeAliasDictionary())
                        
                        if dictNotification[RES_isRedirect] as! String ==
                            "0" && dictNotification[RES_isShowDetail] as! String == "1" {
                            let notificationDetailVC = NotificationDetailViewController(nibName: "NotificationDetailViewController", bundle: nil)
                            
                            if dictNotification[RES_couponId] as! String != "" {
                                notificationDetailVC.couponID = dictNotification[RES_couponId] as! String
                                notificationDetailVC.isCoupon = true
                            }
                            else{
                                notificationDetailVC.notificationID = dictNotification[RES_PushNotificationId] as! String
                                notificationDetailVC.isCoupon = false
                                
                            }
                            self.navigationController.pushViewController(notificationDetailVC, animated: true)
                        }
                        else if dictNotification[RES_isRedirect] as! String == "1" {
                            
                            let _REDIRECT_SCREEN_TYPE: REDIRECT_SCREEN_TYPE =  REDIRECT_SCREEN_TYPE(rawValue: dictNotification[RES_redirectScreen] as! String)!
                            
                            
                            if _REDIRECT_SCREEN_TYPE == REDIRECT_SCREEN_TYPE.SCREEN_AFFILIATE_PARTENERDETAIL {
                                let partnerDetailVC = AffiliatePartnerDetailViewController(nibName: "AffiliatePartnerDetailViewController", bundle: nil)
                                partnerDetailVC.partnerID = dictNotification[RES_partner_id] as! String
                                self.navigationController?.pushViewController(partnerDetailVC, animated: true)
                            }
                            else if  _REDIRECT_SCREEN_TYPE == .SCREEN_HOWTOEARN {
                                
                                let howToEarnVC = HowToEarnViewController(nibName: "HowToEarnViewController", bundle: nil)
                                howToEarnVC.categoryID = dictNotification[RES_earnCategoryId] as! String
                                self.navigationController?.pushViewController(howToEarnVC, animated: true)
                            }
                            else if  _REDIRECT_SCREEN_TYPE == .SCREEN_AFFILIATE_PARTNERLIST {
                                self.showShopView(_selectedTab: Int(dictNotification[RES_affiliate_type_id] as! String)!)
                            }
                            else if  _REDIRECT_SCREEN_TYPE == .SCREEN_AFFILIATE_OFFERLIST {
                                
                                let allPartnerListVC = AffiliatePartnersViewController(nibName: "AffiliatePartnersViewController", bundle: nil)
                                allPartnerListVC.isOffer = true
                                allPartnerListVC.selctedTypeId = dictNotification[RES_affiliate_type_id] as! String
                                self.navigationController.pushViewController(allPartnerListVC, animated: true)
                            }
                            else if  _REDIRECT_SCREEN_TYPE == .SCREEN_ORDER_SUMMARY {
                                let orderDetailVC = OrderDetailViewController(nibName: "OrderDetailViewController", bundle: nil)
                                orderDetailVC.orderId = dictNotification[RES_orderID] as! String
                                self.navigationController?.pushViewController(orderDetailVC, animated: true)
                            }
                            else if  _REDIRECT_SCREEN_TYPE == .SCREEN_GALLERY {
                            }
                            else if _REDIRECT_SCREEN_TYPE == .SCREEN_AFFILIATE_OFFERDETAIL {
                                let offerDetailVC = affiliateOfferDetailViewController(nibName: "affiliateOfferDetailViewController", bundle: nil)
                                offerDetailVC.offerID = dictNotification[RES_offerId] as! String
                                self.navigationController?.pushViewController(offerDetailVC, animated: true)
                                
                            }
                            else{
                                self.redirectToScreen(_REDIRECT_SCREEN_TYPE: REDIRECT_SCREEN_TYPE(rawValue:dictNotification[RES_redirectScreen] as! String)! , dict:dictNotification)
                            }
                            
                        }
                        else{
                            let notificationVC = NotificationViewController(nibName: "NotificationViewController", bundle: nil)
                            self.navigateToViewController(notificationVC)
                        }
                        
                    }
                }
                else  {
                    
                    if self.isWalletUpdate == true {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_RECALL_WALLET), object: nil, userInfo: nil)
                    }
                    DataModel.setDictUserNotification(typeAliasDictionary())
                    let stAlert: String = (dictNotification[RES_notificationDescription] as? String)!
                    var isExists: Bool = false
                    for view in self.navigationController.view.subviews {
                        if view.isKind(of: VKNotificaitonView.classForCoder()) {
                            isExists = true
                            let _vKNotificaitonView = view as! VKNotificaitonView
                            _vKNotificaitonView.lblMessage.text = stAlert
                            break
                        }
                    }
                    if !isExists {
                        let _vKNotificaitonView = VKNotificaitonView.init(title: stAlert , dictNotification: userInfo)
                        self.navigationController.view.addSubview(_vKNotificaitonView)
                    }
                }
            }
            
            dictRemoteNotification.removeAll()
            isNotificationLaunch = false
            UIApplication.shared.applicationIconBadgeNumber = 1
            UIApplication.shared.applicationIconBadgeNumber = 0
            break
        default:
            dictRemoteNotification = userInfo
            break
        }
    }
    
    //MARK: CUSTOM METHODS
    
    func checkInternetConnection() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name: .reachabilityChanged, object: reachability)
        do{ try reachability.startNotifier() }
        catch{ print("could not start reachability notifier") }
    }
    
    func reachabilityChanged(_ note: Notification) {
        
        let reachabilityN = note.object as! Reachability
        if reachabilityN.connection == .none {
            print("There IS NO internet connection")
            
        }
        else {
            print("There IS internet connection")
        }
    }
    
    
    internal func setOrderBackView(_ _RECHARGE_TYPE: RECHARGE_TYPE) {
        
        let navController: AppNavigationController = self.navigationController
        var arrNav:[UIViewController] = navController.viewControllers
        
        let rechargeVC = RechargeViewController(nibName: "RechargeViewController", bundle: nil)
        var indexRecharge: Int = -1
        for i in 0..<arrNav.count { if NSStringFromClass(rechargeVC.classForCoder) == NSStringFromClass(arrNav[i].classForCoder) { indexRecharge = i; break; } }
        if indexRecharge >= 0 { arrNav.remove(at: indexRecharge) }
        
        let paymentVC = PaymentViewController(nibName: "PaymentViewController", bundle: nil)
        var indexPayment: Int = -1
        for i in 0..<arrNav.count { if NSStringFromClass(paymentVC.classForCoder) == NSStringFromClass(arrNav[i].classForCoder) { indexPayment = i; break; } }
        if indexPayment >= 0 { arrNav.remove(at: indexPayment) }
        
        navController.viewControllers = arrNav
        self.navigationController = navController
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFICATION_MOBILE_RECHARGE_SUCCESS), object: nil)
    }
    
    
    internal func setServiceUpdateData(dictServiceUpdate:typeAliasDictionary) {
        
        let dictValue:typeAliasStringDictionary = [KEY_VALUE_1:"-1",KEY_VALUE_2:"0"]
        if DataModel.getDictServiceUpdate().isEmpty {
            
            var dictServiceUpdate:typeAliasDictionary = typeAliasDictionary()
            dictServiceUpdate[JMETHOD_CategoryList] = dictValue as AnyObject?
            dictServiceUpdate[JMETHOD_CouponList] = dictValue as AnyObject?
            dictServiceUpdate[JMETHOD_PlanList] = dictValue as AnyObject?
            dictServiceUpdate[JMETHOD_AffiliatePartner_list] = dictValue as AnyObject?
            dictServiceUpdate[JMETHOD_AffilateCategoryList] = dictValue as AnyObject?
            dictServiceUpdate[JMETHOD_GetMenuList] = dictValue as AnyObject?
            dictServiceUpdate[JMETHOD_GetSources] = dictValue as AnyObject?
            dictServiceUpdate[JMETHOD_OperatorList] = dictValue as AnyObject?
            dictServiceUpdate[JMETHOD_OpratorPlanList] = dictValue as AnyObject?
            dictServiceUpdate[JMETHOD_getAllOrderType] = dictValue as AnyObject?
            dictServiceUpdate[JMETHOD_AffilateOffer_List] = dictValue as AnyObject?
            dictServiceUpdate[JMETHOD_GetHomeSlider] = dictValue as AnyObject?
            dictServiceUpdate[JMETHOD_GetUserSummary] = dictValue as AnyObject?
            dictServiceUpdate[JMETHOD_homeScreenData] = dictValue as AnyObject?
            dictServiceUpdate[JMETHOD_AffiliateProduct_List] = dictValue as AnyObject?
            DataModel.setDictServiceUpdate(dictServiceUpdate)
            
        }
            
        else {
            var dictService = DataModel.getDictServiceUpdate()
            for key in dictServiceUpdate.keys {
                if dictService[key] != nil {
                    var dictValue:typeAliasStringDictionary =  dictService[key] as! typeAliasStringDictionary
                    dictValue[KEY_VALUE_2] = dictServiceUpdate[key] as! String?
                    dictService[key] = dictValue as AnyObject?
                }
                else{
                    let dictValue:typeAliasStringDictionary = [KEY_VALUE_1:"-1",KEY_VALUE_2:(dictServiceUpdate[key] as! String?)! ]
                    dictService[key] = dictValue as AnyObject?
                }
            }
            DataModel.setDictServiceUpdate(dictService)
        }
    }
    
    internal func setIsTutorialForcefully(value:String){
        
        if DataModel.getIsTutorialForcefully().isEmpty {
            let dictValue:typeAliasStringDictionary = [KEY_VALUE_1:"-1",KEY_VALUE_2:"0"]
            DataModel.setIsTutorialForcefully(dictValue)
        }
        else {
            var dictValue = DataModel.getIsTutorialForcefully()
            dictValue[KEY_VALUE_2] = value
            DataModel.setIsTutorialForcefully(dictValue)
        }
    }
    
    internal func updateIsTutorialForcefully() {
        var dictValue = DataModel.getIsTutorialForcefully()
        dictValue[KEY_VALUE_1] = dictValue[KEY_VALUE_2]
        DataModel.setIsTutorialForcefully(dictValue)
    }
    
    internal func checkIsTutorialForcefully() -> Bool {
        var dictValue = DataModel.getIsTutorialForcefully()
        return  dictValue[KEY_VALUE_1] != dictValue[KEY_VALUE_2]
    }
    
    internal func checkIsCallService(serviceName:String) -> Bool {
        
        var dictService = DataModel.getDictServiceUpdate()
        
        if !dictService.isEmpty && dictService[serviceName] != nil {
            
            let dictValue = dictService[serviceName] as! typeAliasStringDictionary
            if dictValue[KEY_VALUE_1]! == dictValue[KEY_VALUE_2]! {
                return false
            }
            else{
                return true
            }
        }
        return true
    }
    
    internal func updateDictService(serviceName:String) {
        
        var dictService = DataModel.getDictServiceUpdate()
        
        if !dictService.isEmpty && dictService[serviceName] != nil{
            
            var dictValue = dictService[serviceName] as! typeAliasStringDictionary
            dictValue[KEY_VALUE_1] = dictValue[KEY_VALUE_2]!
            dictService[serviceName] = dictValue as AnyObject?
            DataModel.setDictServiceUpdate(dictService)
        }
    }
    
    internal func isMemberShipFeesPaid() -> Bool {
        if !DataModel.getUserInfo().isEmpty && (DataModel.getUserInfo()[RES_isMemberFeesPay] as! String) != "1" {
            //VKToast.showToast(DataModel.getNoMembershipFeesPayMsg(), toastType: VKTOAST_TYPE.FAILURE)
            return false;
        }
        else { return true };
    }
    
    internal func isReferralActive() -> Bool {
        if !DataModel.getUserInfo().isEmpty && (DataModel.getUserInfo()[RES_isReferrelActive] as! String) != "1" {
            //VKToast.showToast(DataModel.getNoMembershipFeesPayMsg(), toastType: VKTOAST_TYPE.FAILURE)
            return false;
        }
        else { return true };
    }
    
    internal func showHowToEarnView(categoryID:String) {
        let howToEarnVC = HowToEarnViewController(nibName: "HowToEarnViewController", bundle: nil)
        howToEarnVC.categoryID = categoryID
        self.navigationController?.pushViewController(howToEarnVC, animated: true)
    }
    
    //MARK: LOGOUT 
    
    internal func callLogOutService() {
        
        let dictUserInfo: typeAliasDictionary = DataModel.getUserInfo()
        DesignModel.startActivityIndicator(self.navigationController!.view)
        let params: typeAliasStringDictionary = [REQ_HEADER: DataModel.getHeaderToken(),
                                                 REQ_LOGIN_TYPE: (dictUserInfo[RES_login_type]) == nil ? "0" : dictUserInfo[RES_login_type] as! String,
                                                 REQ_USER_ID: dictUserInfo[RES_userID] as! String]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_UserLogout, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController.view, onSuccess: { (dict) in
            self.performLogout()
        }, onFailure: { (code, dict) in
            
        }) {
            let _KDAlertView = KDAlertView()
            _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING); return
        }
    }
    
    
    internal func performLogout() {
        DataModel.resetPList()
        self.clearAppData()
        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil);
        loginVC.isRootVC = true
        navigationController = AppNavigationController.init(rootViewController: loginVC)
        window?.rootViewController = navigationController
    }
    
    internal func clearAppData() {
        UIApplication.shared.applicationIconBadgeNumber = 1
        UIApplication.shared.applicationIconBadgeNumber = 0
        UIApplication.shared.cancelAllLocalNotifications()
        DataModel.setIsSetFriendInvteFriendMessage(false)
        DataModel.setArrSelectedSeat(array: [typeAliasStringDictionary]())
        DataModel.setUserWalletResponse(dict: typeAliasDictionary())
        DataModel.setUsedWalletResponse(dict: typeAliasDictionary())
        DataModel.setDictServiceUpdate(typeAliasDictionary())
        DataModel.setCoupons(typeAliasDictionary())
        DataModel.setUpComingCoupons(typeAliasDictionary())
        DataModel.setHomeSliderResponse(typeAliasDictionary())
        DataModel.setHomeScreenResponse(dict: typeAliasDictionary())
        DataModel.setUserSummaryData(typeAliasDictionary())
        self.setServiceUpdateData(dictServiceUpdate: typeAliasDictionary())
        DataModel.setTodayDate(date: nil)
        DataModel.setRemovedHomeSlider(arr: [typeAliasDictionary]())
        DataModel.setTodayDateForSlider(date: nil)
        DataModel.setRecentFlightData(arr: [typeAliasDictionary]())
    }
    
    //MARK: NAVIGATION METHODS
    
    internal func jumpToPayMemberShipFeesPage(){
        
        let rechargeVC = RechargeViewController(nibName: "RechargeViewController", bundle: nil)
        rechargeVC._RECHARGE_TYPE = RECHARGE_TYPE.MEMBERSHIP_FEES
        rechargeVC.cart_TotalAmount = DataModel.getMemberShipFees()
        self.navigationController?.pushViewController(rechargeVC, animated: true)
    }
    
    internal func showHomeView() {
        
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        homeVC.dictAppVersionUpdate = dictAppVersionUpdate
        
        if NSStringFromClass((navigationController.viewControllers.first?.classForCoder)!) == NSStringFromClass(homeVC.classForCoder) {
            let home:HomeViewController = navigationController.viewControllers.first as! HomeViewController
            self.navigationController.popToRootViewController(animated: false)
        }
        else{
            navigationController = AppNavigationController.init(rootViewController: homeVC)
            window?.rootViewController = navigationController
            self.dictAppVersionUpdate = typeAliasStringDictionary()
        }
    }
    
    internal func showLoginView(mobileNo:String) {
        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil);
        loginVC.mobileNo = mobileNo
        loginVC.isRootVC = true
        self.navigateToViewController(loginVC)
    }
    
    internal func showLoginView() {
        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil);
        loginVC.isRootVC = true
        self.navigateToViewController(loginVC)
    }
    
    internal func showStartView() {
        let startVC = StartViewController(nibName: "StartViewController", bundle: nil);
        navigationController = AppNavigationController.init(rootViewController: startVC)
        window?.rootViewController = navigationController}
    
    internal func showSignUpPage(mobileNo:String) {
        let signUpVC = SignUpViewController(nibName: "SignUpViewController", bundle: nil);
        signUpVC.mobileNo = mobileNo
        self.navigateToViewController(signUpVC)
    }
    
    
    internal func showSignUpPage() {
        let signUpVC = SignUpViewController(nibName: "SignUpViewController", bundle: nil)
        self.navigateToViewController(signUpVC)
    }
    
    internal func showWalletView(_ isShowAddMoneyView: Bool) {
        let walletVC = WalletViewController(nibName: "WalletViewController", bundle: nil)
        self.navigateToViewController(walletVC, animated: false)
    }
    
    internal func showBusView() {
        var isPaidFees:Bool = false
        if DataModel.getIsPayMemberShipFee() == "1"{
            isPaidFees = true;
        }
        else{
            if self.isMemberShipFeesPaid() { isPaidFees = true; }
            else { isPaidFees = false }
        }
        
        if isPaidFees {
            let busBookingVC = BusBookingViewController(nibName: "BusBookingViewController", bundle: nil)
            self.navigationController.pushViewController(busBookingVC, animated: true)
        }
        else{
            let _KDAlertView = KDAlertView()
            _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
            return
        }
    }
    
    internal func showShopView(_selectedTab:Int) {
        
        let allPartnerListVC = AffiliatePartnersViewController(nibName: "AffiliatePartnersViewController", bundle: nil)
        allPartnerListVC.selctedTypeId = String(_selectedTab)
        self.navigationController.pushViewController(allPartnerListVC, animated: true)
    }
    
    
    internal func navigateToHomeCategoryPage(_HOME_CATEGORY_TYPE:HOME_CATEGORY_TYPE , dictOperatorCategory:typeAliasDictionary) {
        
        var isPaidFees:Bool = false
        var isActive:Bool = false
        if dictOperatorCategory[RES_isActive] as! String == "1" {
            isActive = true
        }
        
        let _KDAlertView = KDAlertView()
        if  DataModel.getIsPayMemberShipFee() == "1" {
            isPaidFees = true;
        }
        else {
            if self.isMemberShipFeesPaid() { isPaidFees = true; }
            else { isPaidFees = false }
        }
        
        if !isPaidFees {
            _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
            return
        }
        
        if !isActive {
            _KDAlertView.showMessage(message: "Coming Soon", messageType: .WARNING, title: dictOperatorCategory[RES_operatorCategoryName] as! String)
            return
        }
        
        switch _HOME_CATEGORY_TYPE {
            
        case .MOBILE:
            if !isPaidFees {
                _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
                return
            }
            let mobileRechargeVC = MobileRechargeViewController(nibName: "MobileRechargeViewController", bundle: nil)
            mobileRechargeVC.dictOpertaorCategory = dictOperatorCategory
            self.navigationController.pushViewController(mobileRechargeVC, animated: true)
            break
        case .DTH:
            if !isPaidFees {
                _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
                return
            }
            let dthVC = DTHViewController(nibName: "DTHViewController", bundle: nil)
            dthVC.dictOpertaorCategory = dictOperatorCategory
            self.navigationController.pushViewController(dthVC, animated: true)
            break
        case .ELECTRICITY:
            if !isPaidFees {
                _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
                return
            }
            let elecVC = ElectricityBillViewController(nibName: "ElectricityBillViewController", bundle: nil)
            elecVC.dictOpertaorCategory = dictOperatorCategory
            self.navigationController.pushViewController(elecVC, animated: true)
            break
        case .GAS:
            if !isPaidFees {
                _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
                return
            }
            let gasBillVC = GasBillViewController(nibName: "GasBillViewController", bundle: nil)
            gasBillVC.dictOpertaorCategory = dictOperatorCategory
            self.navigationController.pushViewController(gasBillVC, animated: true)
            break
        case .LANDLINE:
            if !isPaidFees {
                _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
                return
            }
            let landlineVC = LandlineAndBroadBandViewController(nibName: "LandlineAndBroadBandViewController", bundle: nil)
            landlineVC.dictOpertaorCategory = dictOperatorCategory
            self.navigationController.pushViewController(landlineVC, animated: true)
            break
        case .DATACARD:
            if !isPaidFees {
                _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
                return
            }
            let dataCardVC = DataCardViewController(nibName: "DataCardViewController", bundle: nil)
            dataCardVC.dictOpertaorCategory = dictOperatorCategory
            self.navigationController.pushViewController(dataCardVC, animated: true)
            break
        case .INSURANCE:
            if !isPaidFees {
                _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
                return
            }
            let insuranceVC = InsuranceViewController(nibName: "InsuranceViewController", bundle: nil)
            insuranceVC.dictOpertaorCategory = dictOperatorCategory
            self.navigationController.pushViewController(insuranceVC, animated: true)
            break
        case .EVENT:
            if !isPaidFees {
                _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
                return
            }
            let eventVC = EventViewController(nibName: "EventViewController", bundle: nil)
            eventVC.dictOpertaorCategory = dictOperatorCategory
            self.navigationController.pushViewController(eventVC, animated: true)
            /*let eventDetailVC = EventDetailViewController(nibName: "EventDetailViewController", bundle: nil)
             self.navigationController.pushViewController(eventDetailVC, animated: true)*/
            break
        case .BUSBOOKING:
            if !isPaidFees {
                _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
                return
            }
            self.showBusView()
            break
        case .ADDMONEY:
            if !isPaidFees {
                _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
                return
            }
            self.onVKFooterAction(.WALLET)
            break
        case .SENDMONEY:
            if !isPaidFees {
                _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
                return
            }
            break
        case .RECEIVEMONEY:
            if !isPaidFees {
                _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
                return
            }
            break
        case .TRANSACTION:
            if !isPaidFees {
                _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
                return
            }
            let walletListVC = WalletListViewController(nibName: "WalletListViewController", bundle: nil)
            self.navigationController.pushViewController(walletListVC, animated: true)
            break
        case.FLIGHT:
            if !isPaidFees {
                _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
                return
            }
            let flightBookVC = FlightBookingViewController(nibName: "FlightBookingViewController", bundle: nil)
            flightBookVC.dictOpertaorCategory = dictOperatorCategory
            self.navigationController.pushViewController(flightBookVC, animated: true)
            break
        case.HOTEL:
            if !isPaidFees {
                _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
                return
            }
            break
        case.BROADBAND:
            if !isPaidFees {
                _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
                return
            }
            let landlineVC = LandlineAndBroadBandViewController(nibName: "LandlineAndBroadBandViewController", bundle: nil)
            landlineVC.dictOpertaorCategory = dictOperatorCategory
            self.navigationController.pushViewController(landlineVC, animated: true)
            break;
        case.DONATE_MONEY:
            if !isPaidFees {
                _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
                return
            }
            let donateVC = DonateMoneyViewController(nibName: "DonateMoneyViewController", bundle: nil)
            donateVC.dictOperatorCategory = dictOperatorCategory
            self.navigationController.pushViewController(donateVC, animated: true)
            break;
        default:
            break
        }
    }
    
    internal func onVKMenuAction(_ _VK_MENU_TYPE: VK_MENU_TYPE , categoryID:Int) {
        
        var isPaidFees:Bool = false
        let _KDAlertView = KDAlertView()
        if DataModel.getUserWalletResponse()[RES_isPayMemberShipFee] as! String == "1"{
            isPaidFees = true;
        }
        else{
            if self.isMemberShipFeesPaid() { isPaidFees = true; }
            else { isPaidFees = false }
        }
        
        let getOperatorCategory = {(HomeId:String) -> typeAliasDictionary in
            
            let categoryListResponse:typeAliasDictionary = DataModel.getCategoryListResponse()
            var arrCategoryMain = categoryListResponse[RES_data] as! [typeAliasDictionary]
            arrCategoryMain = arrCategoryMain.filter({ (dict) -> Bool in
                return dict["homeId"] as! String == HomeId
            })
            if !arrCategoryMain.isEmpty {
                var arrCat = arrCategoryMain.first?[RES_categoryList] as! [typeAliasDictionary]
                arrCat = arrCat.filter({ (dict1) -> Bool in
                    return dict1[RES_operatorCategoryId] as! String == String(categoryID)
                })
                if !arrCat.isEmpty {
                    return arrCat.first!
                }
                else{ return typeAliasDictionary()}
            }
            else{ return typeAliasDictionary()}
        }
        
        
        switch _VK_MENU_TYPE {
        case .RECHARGE:
            if !isPaidFees {
                _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
                return
            }
            if HOME_CATEGORY_TYPE(rawValue: String(categoryID)) != nil {
                let dictOperator = getOperatorCategory("1")
                self.navigateToHomeCategoryPage(_HOME_CATEGORY_TYPE: HOME_CATEGORY_TYPE(rawValue: String(categoryID))!, dictOperatorCategory: dictOperator)
            }
            break
        case .BILL:
            if !isPaidFees {
                _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
                return
            }
            if HOME_CATEGORY_TYPE(rawValue: String(categoryID)) != nil {
                let dictOperator = getOperatorCategory("1")
                self.navigateToHomeCategoryPage(_HOME_CATEGORY_TYPE: HOME_CATEGORY_TYPE(rawValue: String(categoryID))!, dictOperatorCategory: dictOperator)
            }
            break
        case .TICKET:
            if !isPaidFees {
                _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
                return
            }
            if HOME_CATEGORY_TYPE(rawValue: String(categoryID)) != nil {
                let dictOperator = getOperatorCategory("2")
                self.navigateToHomeCategoryPage(_HOME_CATEGORY_TYPE: HOME_CATEGORY_TYPE(rawValue: String(categoryID))!, dictOperatorCategory: dictOperator)
            }
            break
        case .SHOP:
            self.showShopView(_selectedTab: categoryID)
            break
        case .INVITE_FRIENDS:
            self.navigationController.viewControllers.last?.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_INVITEFRIEND)", action: "Invite friend", label: "", value: nil)
            let inviteFriendVC = InviteFriendViewController(nibName: "InviteFriendViewController", bundle: nil)
            self.navigationController.pushViewController(inviteFriendVC, animated: true)
            break
        case .SHARE_APP:
            self.navigationController.viewControllers.last?.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_INVITEFRIEND)", action: "Share App", label: "", value: nil)
            /*  let inviteFriendVC = InviteFriendViewController(nibName: "InviteFriendViewController", bundle: nil)
             self.navigationController.pushViewController(inviteFriendVC, animated: true)*/
            let objectsToShare = [DataModel.getIvniteFriendMsg()]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.navigationController.present(activityVC, animated: true, completion: nil)
            break
        case .RATE_US:
            let _:ExperianceView = ExperianceView.init(frame: UIScreen.main.bounds)
            /*UIApplication.shared.openURL(URL.init(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1171382587&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software")!)*/
            break
        case .LOGOUT:
            self.callLogOutService()
            break
        case.HOW_TO_EARN:
            let howToEarnVC = HowToEarnViewController(nibName: "HowToEarnViewController", bundle: nil)
            howToEarnVC.categoryID = String(categoryID)
            self.navigationController?.pushViewController(howToEarnVC, animated: true)
            break
        case .OFFERS:
            let myOfferVC = MyOfferViewController(nibName: "MyOfferViewController", bundle: nil)
            self.navigationController.pushViewController(myOfferVC, animated: true)
            break
        case .GALLERY:
            if !isPaidFees {
                _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
                return
            }
            
        default:
            break
        }
        
    }
    
    internal func onVKFooterAction(_ _VK_FOOTER_TYPE: VK_FOOTER_TYPE) {
        
        let getOperatorCategory = {(HomeId:String) -> typeAliasDictionary in
            
            let categoryListResponse:typeAliasDictionary = DataModel.getCategoryListResponse()
            var arrCategoryMain = categoryListResponse[RES_data] as! [typeAliasDictionary]
            arrCategoryMain = arrCategoryMain.filter({ (dict) -> Bool in
                return dict["homeId"] as! String == HomeId
            })
            if !arrCategoryMain.isEmpty {
                var arrCat = arrCategoryMain.first?[RES_categoryList] as! [typeAliasDictionary]
                arrCat = arrCat.filter({ (dict1) -> Bool in
                    return dict1[RES_operatorCategoryId] as! String == String("14")
                })
                if !arrCat.isEmpty {
                    return arrCat.first!
                }
                else{ return typeAliasDictionary()}
            }
            else{ return typeAliasDictionary()}
        }
        
        switch _VK_FOOTER_TYPE {
        case .HOME:
            self.showHomeView()
            break
        case .WALLET:
            
            let walletVC = WalletViewController(nibName: "WalletViewController", bundle: nil)
            walletVC.dictOperatorCategory = getOperatorCategory(
                "3")
            self.navigateToViewController(walletVC, animated: false)
            
            break
        case .ACCOUNT:
            let accountVC = AccountViewController(nibName: "AccountViewController", bundle: nil)
            self.navigateToViewController(accountVC, animated: false)
            //            navigationController = AppNavigationController.init(rootViewController: accountVC)
            //            window?.rootViewController = navigationController
            break
        case .MEMBER_TREE:
            
            let treeVC = TreeViewController(nibName: "TreeViewController", bundle: nil)
            self.navigateToViewController(treeVC, animated: false)
            //            navigationController = AppNavigationController.init(rootViewController: treeVC)
            //            window?.rootViewController = navigationController
            break
        case .SHOP:
            
            let affiliateShopVC = AffiliateShopViewController(nibName: "AffiliateShopViewController", bundle: nil)
            self.navigateToViewController(affiliateShopVC, animated: false)
            //             navigationController = AppNavigationController.init(rootViewController: affiliateShopVC)
            //             window?.rootViewController = navigationController
            break
        default:
            break
        }
    }
    
    
    internal func redirectToScreen(_REDIRECT_SCREEN_TYPE:REDIRECT_SCREEN_TYPE , dict:typeAliasDictionary) {
        
        let getOperatorCategory = { (HomeId:String , cateId:String) -> typeAliasDictionary in
            
            let categoryListResponse:typeAliasDictionary = DataModel.getCategoryListResponse()
            var arrCategoryMain = categoryListResponse[RES_data] as! [typeAliasDictionary]
            arrCategoryMain = arrCategoryMain.filter({ (dict) -> Bool in
                return dict["homeId"] as! String == HomeId
            })
            if !arrCategoryMain.isEmpty {
                var arrCat = arrCategoryMain.first?[RES_categoryList] as! [typeAliasDictionary]
                arrCat = arrCat.filter({ (dict1) -> Bool in
                    return dict1[RES_operatorCategoryId] as! String == cateId
                })
                if !arrCat.isEmpty {
                    return arrCat.first!
                }
                else{ return typeAliasDictionary()}
            }
            else{ return typeAliasDictionary()}
        }
        
        
        switch _REDIRECT_SCREEN_TYPE {
            
        case .SCREEN_MOBILE:
            let dictOperator = getOperatorCategory("1", HOME_CATEGORY_TYPE.MOBILE.rawValue)
            if !dictOperator.isEmpty{
                self.navigateToHomeCategoryPage(_HOME_CATEGORY_TYPE: .MOBILE, dictOperatorCategory: dictOperator)}
            break
        case .SCREEN_DTH:
            let dictOperator = getOperatorCategory("1", HOME_CATEGORY_TYPE.DTH.rawValue)
            if !dictOperator.isEmpty{
                self.navigateToHomeCategoryPage(_HOME_CATEGORY_TYPE: .DTH, dictOperatorCategory: dictOperator)}
            break
        case .SCREEN_ELEBILL:
            let dictOperator = getOperatorCategory("1", HOME_CATEGORY_TYPE.ELECTRICITY.rawValue)
            if !dictOperator.isEmpty{
                self.navigateToHomeCategoryPage(_HOME_CATEGORY_TYPE: .ELECTRICITY, dictOperatorCategory: dictOperator)}
            break
        case .SCREEN_GASBILL:
            let dictOperator = getOperatorCategory("1", HOME_CATEGORY_TYPE.GAS.rawValue)
            if !dictOperator.isEmpty{
                self.navigateToHomeCategoryPage(_HOME_CATEGORY_TYPE: .GAS, dictOperatorCategory: dictOperator)}
            break
        case .SCREEN_LANDLINE:
            let dictOperator = getOperatorCategory("1", HOME_CATEGORY_TYPE.LANDLINE.rawValue)
            if !dictOperator.isEmpty{
                self.navigateToHomeCategoryPage(_HOME_CATEGORY_TYPE: .LANDLINE, dictOperatorCategory: dictOperator)}
            break
        case .SCREEN_DATACARD:
            let dictOperator = getOperatorCategory("1", HOME_CATEGORY_TYPE.DATACARD.rawValue)
            if !dictOperator.isEmpty{
                self.navigateToHomeCategoryPage(_HOME_CATEGORY_TYPE: .DATACARD, dictOperatorCategory: dictOperator)}
            break
        case .SCREEN_INSURANCE:
            let dictOperator = getOperatorCategory("1", HOME_CATEGORY_TYPE.INSURANCE.rawValue)
            if !dictOperator.isEmpty{
                self.navigateToHomeCategoryPage(_HOME_CATEGORY_TYPE: .INSURANCE, dictOperatorCategory: dictOperator)}
            break
        case .SCREEN_SENDMONEY:
            
            break
        case .SCREEN_REQUESTMONEY:
            
            break
        case .SCREEN_ADDMONEY:
            let dictOperator = getOperatorCategory("3", HOME_CATEGORY_TYPE.ADDMONEY.rawValue)
            if !dictOperator.isEmpty{
                self.navigateToHomeCategoryPage(_HOME_CATEGORY_TYPE: .ADDMONEY, dictOperatorCategory: dictOperator)
            }
            // self.navigateToHomeCategoryPage(_HOME_CATEGORY_TYPE: .ADDMONEY, dictOperatorCategory: typeAliasDictionary())
            break
        case .SCREEN_NOTIFICATION:
            
            break
        case .SCREEN_TREE:
            self.onVKFooterAction(VK_FOOTER_TYPE.MEMBER_TREE)
            break
        case .SCREEN_HOWTOEARN:
            let howToEarnVC = HowToEarnViewController(nibName: "HowToEarnViewController", bundle: nil)
            howToEarnVC.categoryID = dict[RES_earnCategoryId] as! String
            self.navigationController?.pushViewController(howToEarnVC, animated: true)
            break
        case .SCREEN_REQUEST:
            // let requestVC = RequestsViewController(nibName: "RequestsViewController", bundle: nil)
            //self.navigationController.pushViewController(requestVC, animated: true)
            break
        case .SCREEN_WALLETLIST:
            let walletListVC = WalletListViewController(nibName: "WalletListViewController", bundle: nil)
            self.navigationController.pushViewController(walletListVC, animated: true)
            break
        case .SCREEN_BUS_HOME:
            self.showBusView()
            break
            
        case .SCREEN_AFFILIATE_SHOPPING:
            self.onVKFooterAction(VK_FOOTER_TYPE.SHOP)
            
        case .SCREEN_AFFILIATE_PARTENERDETAIL:
            
            let shopDetailVC = AffiliatePartnerDetailViewController(nibName: "AffiliatePartnerDetailViewController", bundle: nil)
            shopDetailVC.partnerID = dict[RES_partner_id] as! String
            self.navigationController.pushViewController(shopDetailVC, animated: true)
            
            break
            
        case .SCREEN_AFFILIATE_ORDERLIST:
            
            let orderListVC = MyOrderViewController(nibName: "MyOrderViewController", bundle: nil)
            self.navigationController.pushViewController(orderListVC, animated: true)
            break
            
        case.SCREEN_AFFILIATE_CLAIMORDER:
            break
            
        case.SCREEN_OFFER_LIST:
            self.onVKMenuAction(.OFFERS, categoryID: 0)
            break
            
        case.SCREEN_MEMBERSHEEP_FEES:
            let howToEarnVC = HowToEarnViewController(nibName: "HowToEarnViewController", bundle: nil)
            howToEarnVC.categoryID = "13"
            self.navigationController?.pushViewController(howToEarnVC, animated: true)
            break
            
        case.SCREEN_GALLERY:
            break
            
        case.SCREEN_INVITE_FRIEND:
            self.onVKMenuAction(.INVITE_FRIENDS, categoryID: 0)
            break
            
        case.SCREEN_ORDER_SUMMARY:
            let orderDetailVC = OrderDetailViewController(nibName: "OrderDetailViewController", bundle: nil)
            orderDetailVC.orderId = dict[RES_orderID] as! String
            orderDetailVC.isOrderDetailFromOrderHistory = true
            self.navigationController?.pushViewController(orderDetailVC, animated: true)
            break
            
        case.SCREEN_AFFILIATE_OFFERLIST:
            let afffiliateOfferVC = AffiliatePartnersViewController(nibName: "AffiliatePartnersViewController", bundle: nil)
            afffiliateOfferVC.selctedTypeId  = dict[RES_affiliate_type_id] as! String
            afffiliateOfferVC.isOffer = true
            afffiliateOfferVC.selectedIndex = 1
            self.navigationController?.pushViewController(afffiliateOfferVC, animated: true)
            break
            
        case.SCREEN_AFFILIATE_OFFERDETAIL:
            let affiliateOfferDetailVC = affiliateOfferDetailViewController   (nibName: "affiliateOfferDetailViewController", bundle: nil)
            affiliateOfferDetailVC.offerID  = dict[RES_offerId] as! String
            self.navigationController?.pushViewController(affiliateOfferDetailVC, animated: true)
            break
            
        case.SCREEN_AFFILIATE_PARTNERLIST:
            self.showShopView(_selectedTab: Int(dict[RES_affiliate_type_id] as! String)!)
            break
        case.SCREEN_NOTIFICATION_REDIRECT:
            if dict[RES_isExternal] as! String == "1" {
                let webPreviewVC = WebPreviewViewController(nibName: "WebPreviewViewController", bundle: nil)
                webPreviewVC.stUrl = dict[RES_link] as! String
                webPreviewVC.stTitle = dict.isKeyNull(RES_notificationTitle)
                    ? dict.isKeyNull(RES_couponTitle) ? "" : dict[RES_couponTitle] as! String :dict[RES_notificationTitle] as! String
                self.navigationController?.pushViewController(webPreviewVC, animated: true)
                
            }
            else if dict[RES_isExternal] as! String == "2" {
                UIApplication.shared.openURL((dict[RES_link] as! String).convertToUrl())
            }
            break
        case.SCREEN_HOME:
            self.showHomeView()
            break;
        case.SCREEN_EVENT:
            let dictOperator = getOperatorCategory("2", HOME_CATEGORY_TYPE.EVENT.rawValue)
            if !dictOperator.isEmpty {
                self.stRechargeImage = dictOperator[RES_image] as! String
                self.navigateToHomeCategoryPage(_HOME_CATEGORY_TYPE: .EVENT, dictOperatorCategory: dictOperator)}
            break
        case.SCREEN_FLIGHT:
            let dictOperator = getOperatorCategory("2", HOME_CATEGORY_TYPE.FLIGHT.rawValue)
            if !dictOperator.isEmpty {
                self.stRechargeImage = dictOperator[RES_image] as! String
                self.navigateToHomeCategoryPage(_HOME_CATEGORY_TYPE: .FLIGHT, dictOperatorCategory: dictOperator)}
            break
        case.SCREEN_AFFILIATE_PRODUCT_LIST:
            let afffiliateOfferVC = AffiliatePartnersViewController(nibName: "AffiliatePartnersViewController", bundle: nil)
            afffiliateOfferVC.selctedTypeId  = dict[RES_affiliate_type_id] as! String
            afffiliateOfferVC.isOffer = false
            afffiliateOfferVC.selectedIndex = 2
            self.navigationController?.pushViewController(afffiliateOfferVC, animated: true)
            
            break
        case.SCREEN_AFFILIATE_PRODUCT_DETAIL:
            let affliateProductDetailVC = AffiliateProductDetailViewController(nibName: "AffiliateProductDetailViewController", bundle: nil)
            affliateProductDetailVC.stProductID = dict[RES_offerId] as! String
            self.navigationController?.pushViewController(affliateProductDetailVC, animated: true)
            break
        case.SCREEN_GIVE_UP_CASHBACK:
            let userWallet:typeAliasDictionary =  DataModel.getUserWalletResponse()
            if  !userWallet.isEmpty && userWallet[RES_isGiveupApp] as! String == "1" {
                let giveUpVC = GiveUpCashBackViewController(nibName: "GiveUpCashBackViewController", bundle: nil)
                if  DataModel.getUserWalletResponse()[RES_isGiveupTitle] != nil {
                    giveUpVC.giveUpTitle = DataModel.getUserWalletResponse()[RES_isGiveupTitle] as! String
                }
                self.navigationController?.pushViewController(giveUpVC, animated: true)
            }
            break
        case .SCREEN_DONATE_MONEY:
            let dictOperator = getOperatorCategory("3", HOME_CATEGORY_TYPE.DONATE_MONEY.rawValue)
            if !dictOperator.isEmpty{
                self.navigateToHomeCategoryPage(_HOME_CATEGORY_TYPE: .DONATE_MONEY, dictOperatorCategory: dictOperator)
            }
            break
        default:
            break
        }
    }
    
    func restartApp() {
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        let splashVC = SplashViewController(nibName: "SplashViewController", bundle: nil)
        navigationController = AppNavigationController.init(rootViewController: splashVC)
        window?.rootViewController = navigationController
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        self.isFirstServiceCall = true
        // navigationBarColor = self.navigationController.navigationBar.barTintColor
        
        if DataModel.getUserInfo().isEmpty {
            if DataModel.getHomeMenu().isEmpty { DataModel.setIsAppInstallFirstTime(true);
                DataModel.setIsNeverShowReviewPrompt(false)
                self.setServiceUpdateData(dictServiceUpdate: typeAliasDictionary())
                self.setIsTutorialForcefully(value: "")
                DataModel.setIsNotificationEnabled(false)
            }
            else { DataModel.setIsAppInstallFirstTime(false) }
            DataModel.setIsShowIntroSlider(true)
        }
        else {
            
            DataModel.setIsAppInstallFirstTime(false)
        }
        DataModel.setUserWalletResponse(dict: typeAliasDictionary())
        DataModel.setUsedWalletResponse(dict: typeAliasDictionary())
        DataModel.setIsSetFriendInvteFriendMessage(false)
        DataModel.setArrSelectedSeat(array: [typeAliasStringDictionary]())
    }
    
    func callReadNotificationService(id:String , userInfo:typeAliasDictionary , isNotifLaunch:Bool) {
        let dictNotification: typeAliasDictionary = (userInfo[RES_data] as! String).convertToDictionary2()
        var userID:String = ""
        if !DataModel.getUserInfo().isEmpty {
            userID = DataModel.getUserInfo().isKeyNull(RES_userID) ? "" : DataModel.getUserInfo()[RES_userID] as! String
        }
        else if dictNotification[RES_toUserID] != nil && dictNotification[RES_toUserID] as! String != ""  {
            userID = dictNotification[RES_toUserID] as! String
        }
        let params = [REQ_HEADER: DataModel.getHeaderToken(),
                      REQ_USER_ID:userID,
                      REQ_NOTIFICATION_ID: id,
                      REQ_IS_DELETE:  "0",
                      REQ_DELETE_ALL: "0"]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_ReadNotification, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: .init(), onSuccess: { (dict) in
            DataModel.setNotificationBadge(dict[RES_notification_count] as! String)
            self.navigateAfterReadNotificationService(userInfo: userInfo, isNotifLaunch:isNotifLaunch)
        }, onFailure: { (code, dict) in
            
        }, onTokenExpire: {
            let _KDAlertView = KDAlertView()
            _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING); return  })
    }
    
    func navigateAfterReadNotificationService(userInfo:typeAliasDictionary , isNotifLaunch:Bool) {
        
        let dictNotification: typeAliasDictionary = (userInfo[RES_data] as! String).convertToDictionary2()
        
        if isNotifLaunch {
            
            if !isBackGround {
                DataModel.setDictUserNotification(userInfo)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_LAUNCH_WITH_NOTIFICATION), object: nil, userInfo: nil)
            }
            else {
                
                DataModel.setDictUserNotification(typeAliasDictionary())
                
                if dictNotification[RES_isRedirect] as! String ==
                    "0" && dictNotification[RES_isShowDetail] as! String == "1" {
                    let notificationDetailVC = NotificationDetailViewController(nibName: "NotificationDetailViewController", bundle: nil)
                    
                    if dictNotification[RES_couponId] as! String != "" {
                        notificationDetailVC.couponID = dictNotification[RES_couponId] as! String
                        notificationDetailVC.isCoupon = true
                    }
                    else{
                        notificationDetailVC.notificationID = dictNotification[RES_PushNotificationId] as! String
                        notificationDetailVC.isCoupon = false
                        
                    }
                    self.navigationController.pushViewController(notificationDetailVC, animated: true)
                }
                else if dictNotification[RES_isRedirect] as! String == "1" {
                    
                    if  REDIRECT_SCREEN_TYPE(rawValue: dictNotification[RES_redirectScreen] as! String) != nil {
                        self.redirectToScreen(_REDIRECT_SCREEN_TYPE: REDIRECT_SCREEN_TYPE(rawValue:dictNotification[RES_redirectScreen] as! String)! , dict:dictNotification)
                    }
                }
                else{
                    let notificationVC = NotificationViewController(nibName: "NotificationViewController", bundle: nil)
                    self.navigateToViewController(notificationVC)
                }
            }
        }
        else  {
            
            DataModel.setDictUserNotification(typeAliasDictionary())
            let stAlert: String = (dictNotification[RES_notificationDescription] as? String)!
            var isExists: Bool = false
            for view in self.navigationController.view.subviews {
                if view.isKind(of: VKNotificaitonView.classForCoder()) {
                    isExists = true
                    let _vKNotificaitonView = view as! VKNotificaitonView
                    _vKNotificaitonView.lblMessage.text = stAlert
                    break
                }
            }
            if !isExists {
                let _vKNotificaitonView = VKNotificaitonView.init(title: stAlert , dictNotification: userInfo)
                self.navigationController.view.addSubview(_vKNotificaitonView)
            }
        }
        
    }
    
    internal func handlePushNotificationsFromHome(dict:typeAliasDictionary) {
        
        let dictNotification: typeAliasDictionary = (dict[RES_data] as! String).convertToDictionary2()
        // let dictNotification: typeAliasDictionary = dict
        DataModel.setDictUserNotification(typeAliasDictionary())
        
        if dictNotification[RES_isRedirect] as! String ==
            "0" && dictNotification[RES_isShowDetail] as! String == "1" {
            
            let notificationDetailVC = NotificationDetailViewController(nibName: "NotificationDetailViewController", bundle: nil)
            
            if dictNotification[RES_couponId] as! String != "" {
                notificationDetailVC.couponID = dictNotification[RES_couponId] as! String
                notificationDetailVC.isCoupon = true
            }
            else{
                notificationDetailVC.notificationID = dictNotification[RES_PushNotificationId] as! String
                notificationDetailVC.isCoupon = false
            }
            self.navigationController.pushViewController(notificationDetailVC, animated: true)
        }
            
        else if dictNotification[RES_isRedirect] as! String == "1" {
            
            if  REDIRECT_SCREEN_TYPE(rawValue: dictNotification[RES_redirectScreen] as! String) != nil {
                self.redirectToScreen(_REDIRECT_SCREEN_TYPE: REDIRECT_SCREEN_TYPE(rawValue:dictNotification[RES_redirectScreen] as! String)! , dict:dictNotification)
            }
        }
        else {
            let notificationVC = NotificationViewController(nibName: "NotificationViewController", bundle: nil)
            self.navigateToViewController(notificationVC)
        }
        DataModel.setDictUserNotification(typeAliasDictionary())
    }
    
    fileprivate func navigateToViewController(_ viewController: UIViewController) {
        let arrViewController: Array<UIViewController> = self.navigationController.viewControllers
        
        if !arrViewController.isEmpty && arrViewController.last != viewController {
            if self.isViewControllerExist(viewController) {
                let viewControllerIndex: Int = self.getViewControllerIndex(viewController)
                self.navigationController.popToViewController(arrViewController[viewControllerIndex], animated: true)
            }
            else { self.navigationController.pushViewController(viewController, animated: true) }
        }
    }
    
    fileprivate func isViewControllerExist(_ viewController: UIViewController) -> Bool {
        let arrViewController: Array<UIViewController> = self.navigationController.viewControllers
        for vc in arrViewController {
            if NSStringFromClass(vc.classForCoder) == NSStringFromClass(viewController.classForCoder) {
                return true
            }
        }
        return false
    }
    
    fileprivate func getViewControllerIndex(_ viewController: UIViewController) -> Int {
        let arrViewController: Array<UIViewController> = self.navigationController.viewControllers
        for vc in arrViewController {
            if NSStringFromClass(vc.classForCoder) == NSStringFromClass(viewController.classForCoder) {
                return Int(arrViewController.index(of: vc)!)
            }
        }
        return 0;
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if !dictRemoteNotification.isEmpty {
            self.handlePushNotificationsFromHome(dict: dictRemoteNotification)
            dictRemoteNotification = typeAliasDictionary()
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler( [.alert, .badge, .sound])
        if !notification.request.content.userInfo.isEmpty {
            dictRemoteNotification = notification.request.content.userInfo as! typeAliasDictionary
        }
    }
    
    //MARK: TAGMANAGER DELEGATE
    
    func containerAvailable(_ container: TAGContainer!) {
        container.refresh()
    }
    
    func navigateToViewController(_ viewController: UIViewController ,animated:Bool) {
        let arrViewController: Array<UIViewController> = self.navigationController.viewControllers
        
        if !arrViewController.isEmpty && arrViewController.last != viewController {
            if self.isViewControllerExist(viewController) {
                let viewControllerIndex: Int = self.getViewControllerIndex(viewController)
                self.navigationController.popToViewController(arrViewController[viewControllerIndex], animated: animated)
            }
            else { self.navigationController.pushViewController(viewController, animated: animated) }
        }
    }
}

