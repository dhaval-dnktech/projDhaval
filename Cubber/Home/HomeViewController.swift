//
//  HomeViewController.swift
//  Cubber
//
//  Created by dnk on 28/08/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//
import UIKit
import ImageIO
import ModelIO
import Contacts
import ContactsUI
import StoreKit
import Crashlytics


class HomeViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , UICollectionViewDelegate , KolodaViewDelegate , KolodaViewDataSource , BillInfoViewDelegate , CouponCellDelegate {
    
    //MARK: CONSTANTS
    
    let MOBILE_CELL_HEIGHT :CGFloat = 150
    let USER_SUMMARY_HEIGHT : CGFloat = 300
    let OFFER_CELL_HEIGHT    : CGFloat = 160
    let SHOPPING_CELL_HEIGHT : CGFloat = 145
    let CELL_HEIGHT : CGFloat = 50
    let COLLECTION_MOBILE_CELL_HEIGHT : CGFloat = 90

    //MARK: PROPERTIES
    
    @IBOutlet var viewBillInfo: UIView!
    @IBOutlet var viewNote: UIView!
    @IBOutlet var viewNavigationBar: UIView!
    @IBOutlet var tableViewCategory: UITableView!
    @IBOutlet var kolodaView: KolodaView!
    @IBOutlet var viewNotificationBadgeBG: UIView!
    @IBOutlet var viewPayBill: UIView!
    
    @IBOutlet var btnNotificationTitle: UIButton!
    
    @IBOutlet var imageMemberShipStatus: UIImageView!
    @IBOutlet var btnMemberShipStatus: UIButton!
    @IBOutlet var constraintBtnNotificationLeadingToLblUserWallet: NSLayoutConstraint!
    
    @IBOutlet var constraintBtnNotificationLeadingToBtnMembershipStatus: NSLayoutConstraint!
    
    //USER INFO
    @IBOutlet var indicatorWallet: UIActivityIndicatorView!
    
    @IBOutlet var imageUserProfile: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblUserWallet: UILabel!
    @IBOutlet var constraintLblUserWalletWidth: NSLayoutConstraint!
    @IBOutlet var lblUserSortName: UILabel!
     @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var webViewMaintanance: UIWebView!
    @IBOutlet var constraintWebViewmaintananceHeight: NSLayoutConstraint!

    //MARK: CONSTRAINTS
    @IBOutlet var constraintTableViewCategoryHeight: NSLayoutConstraint!
    
    @IBOutlet var constraintTableViewTopToViewBillInfo: NSLayoutConstraint!
    @IBOutlet var constraintTableViewCategoryTopToViewNote: NSLayoutConstraint!
    @IBOutlet var constraintViewStatusBarHeight: NSLayoutConstraint!
    
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var _KDAlertView = KDAlertView()
    internal var dictAppVersionUpdate:typeAliasStringDictionary = typeAliasStringDictionary()
    fileprivate var arrCategoryMain:[typeAliasDictionary] = [typeAliasDictionary]()
    fileprivate var arrCateList:[typeAliasDictionary] = [typeAliasDictionary]()
    fileprivate var arrSlider:[typeAliasDictionary] = [typeAliasDictionary]()
    fileprivate var dictUserSummary:typeAliasDictionary = typeAliasDictionary()
    fileprivate var dictShoppingData:typeAliasDictionary = typeAliasDictionary()
    fileprivate var arrCouponList:[typeAliasDictionary] = [typeAliasDictionary]()
    fileprivate var arrCellheight:[CGFloat] = [CGFloat]()
    fileprivate var pageSize: Int = 0
    fileprivate var totalPages: Int = 0
    fileprivate var totalRecords: Int = 0
    fileprivate var currentPage: Int = 1
    fileprivate var isWalletServiceCall:Bool = false
    
    //MARK: DEFAULT METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0 , *){self.constraintViewStatusBarHeight.constant = 0}
        else{ self.constraintViewStatusBarHeight.constant = 20 }
        self.viewNotificationBadgeBG.isHidden = true
        let categoryListResponse:typeAliasDictionary = DataModel.getCategoryListResponse()
        arrCategoryMain = categoryListResponse[RES_data] as! [typeAliasDictionary]
        arrCategoryMain.sort { (dict, dict1) -> Bool in
            return (Int(dict[RES_indexOrder] as! String))! < (Int(dict1[RES_indexOrder] as! String))!
        }
        
        for _ in 0..<arrCategoryMain.count {
            arrCellheight.append(CELL_HEIGHT)
        }
        
        viewNotificationBadgeBG.layer.borderColor = COLOUR_ORANGE.cgColor
        tableViewCategory.register(UINib.init(nibName: CELL_IDENTIFIER_HOME_CATEGORY_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_HOME_CATEGORY_CELL)
        tableViewCategory.tableFooterView = UIView.init()
        //tableViewCategory.estimatedRowHeight = 130
        tableViewCategory.rowHeight = 0
        if kolodaView != nil {
            kolodaView.delegate = self
            kolodaView.dataSource = self
        }
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        self.setHomeScreenData()

        NotificationCenter.default.addObserver(self, selector: #selector(handlePush), name: NSNotification.Name(rawValue: NOTIFICATION_LAUNCH_WITH_NOTIFICATION), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recallUserWallet), name: NSNotification.Name(rawValue: NOTIFICATION_RECALL_WALLET), object: nil)
     //   print(Int("GEEE")!)
        //Crashlytics.sharedInstance().crash()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.indicatorWallet.stopAnimating()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.setStatusBarBackgroundColor(color:viewNavigationBar.backgroundColor!)
       
        self.setUserInfo()
        self.resizeTableView()
        if DataModel.getUserWalletResponse().isEmpty || obj_AppDelegate.isWalletUpdate {
            self.callHomeGetUserWalletService()
        }
        else {
            self.setWalletInfo(dict: DataModel.getUserWalletResponse())
            if obj_AppDelegate.isReloadHomeScreen { self.getHomeScreenData() }
        }
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setNotificationBadge()
        self.setUserProperty(propertyName: F_HOME_TAB, PropertyValue: F_HOME_TAB)
        self.sendScreenView(name: SCREEN_HOME)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.setStatusBarBackgroundColor(color: .white)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
    }
    
    //MARK: BUTTON ACTION
 
    @IBAction func btnNavBarNotPrimeMemberAction() {
        if  !obj_AppDelegate.isMemberShipFeesPaid() {
            obj_AppDelegate.onVKMenuAction(VK_MENU_TYPE.HOW_TO_EARN, categoryID: 13)
        }
        else if DataModel.getUserWalletResponse()[RES_isReferrelActive] as! String == "0" {
            obj_AppDelegate.onVKMenuAction(VK_MENU_TYPE.HOW_TO_EARN, categoryID: 12)
        }
    }
    
    @IBAction func btnSideMenuAction() {
        let _vkSideMenu = VKSideMenu()
        self.navigationController?.view.addSubview(_vkSideMenu)
    }
 
    @IBAction func btnNotificationAction(_ sender: UIButton) {
        let notificationVC = NotificationViewController(nibName: "NotificationViewController", bundle: nil)
        self.navigationController?.pushViewController(notificationVC, animated: true)
    }
    
    @IBAction func btnWalletAmountAction() {
        
        if !obj_AppDelegate.isMemberShipFeesPaid() {
            _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
            return
        }
        
        let walletListVC = WalletListViewController(nibName: "WalletListViewController", bundle: nil)
        walletListVC.walletAmount = self.lblUserWallet.text!
        self.navigationController?.pushViewController(walletListVC, animated: true)
    }
    

    //MARK: CUSTOME METHODS
    
    func recallUserWallet() {
        if (self.navigationController?.viewControllers.last?.isKind(of: HomeViewController.classForCoder()))! {
            self.callHomeGetUserWalletService()
        }
    }

    func handlePush()
    {
        if !DataModel.getDictUserNotification().isEmpty {
            self.obj_AppDelegate.handlePushNotificationsFromHome(dict: DataModel.getDictUserNotification())
            DataModel.setDictUserNotification(typeAliasDictionary())
            return
        }
    }
    
    func setSheduleMaintanace() {
        
        if !obj_AppDelegate.stMaintananceMessage.isEmpty {
            webViewMaintanance.loadHTMLString( obj_AppDelegate.stMaintananceMessage, baseURL: nil)
            viewNote.isHidden = false
            constraintWebViewmaintananceHeight.constant = 25
        }
        else { viewNote.isHidden = true;constraintWebViewmaintananceHeight.constant = 0 }
    }
    
    func getHomeScreenData() {
    
        let dictHomeSlider = DataModel.getHomeScreenResponse()
        if dictHomeSlider.isEmpty || obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_homeScreenData)
            {
            self.callHomeScreenDataService()
        }
        else { //CHECK FOR ALL THREE SERVICES
            arrSlider = [typeAliasDictionary]()
            self.arrSlider = dictHomeSlider[RES_homeSlider] as! [typeAliasDictionary]
            self.setHomeScreenData()
            self.getCouponListData()
        }
   }
    
    func getCouponListData() {
        if DataModel.getCoupons().isEmpty || obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_CouponList) {
            DataModel.setCoupons(typeAliasDictionary())
            self.arrCouponList = [typeAliasDictionary]()
            self.currentPage = 1
            self.callCouponListService()
        }
        else {
                let dictCoupon = DataModel.getCoupons()
                let arrData: Array<typeAliasDictionary> = dictCoupon[RES_data] as! Array<typeAliasDictionary>
                self.arrCouponList = arrData
                self.pageSize = dictCoupon[RES_par_page] as! Int
                self.totalPages = dictCoupon[RES_total_pages] as! Int
                self.totalRecords = dictCoupon[RES_total_items] as! Int
                self.setCouponData()
                self.getHomeSliderData()
        }
    }
    
    func getHomeSliderData() {
       
        if DataModel.getHomeSliderResponse().isEmpty  || obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_GetHomeSlider) {
            DataModel.setHomeSliderResponse(typeAliasDictionary())
            self.callGetHomeSliderService()
        }
        else {
            arrSlider = [typeAliasDictionary]()
            self.arrSlider = DataModel.getHomeSliderResponse()[RES_data] as! [typeAliasDictionary]
            self.setHomeSliderData()
            self.getUserSummaryData()
        }
    }
    
    func getUserSummaryData() {
        
        if DataModel.getUserSummaryData().isEmpty  || obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_GetUserSummary) {
            DataModel.setUserSummaryData(typeAliasDictionary())
            self.callGetUserSummaryService()
        }
        else{
            dictUserSummary = typeAliasDictionary()
            self.dictUserSummary = DataModel.getUserSummaryData()[RES_userSummaryData] as! typeAliasDictionary
            self.dictShoppingData = DataModel.getUserSummaryData()[RES_userShoppingData] as! typeAliasDictionary
            self.setUserSummaryData()
            self.obj_AppDelegate.isReloadHomeScreen = false
        }
    }
    
    func setStaticImage(imageName:String , btn:UIButton) {
        
        btn.isHidden = false
        self.imageMemberShipStatus.isHidden = false
        constraintBtnNotificationLeadingToLblUserWallet.priority = PRIORITY_LOW
        constraintBtnNotificationLeadingToBtnMembershipStatus.priority = PRIORITY_HIGH
        
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: imageName, withExtension: "gif")!)
        guard let source = CGImageSourceCreateWithData(imageData as! CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return
        }
        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        
        for i in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        imageMemberShipStatus.image = images.last
        imageMemberShipStatus.animationImages = images
        imageMemberShipStatus.animationDuration = 1
        //imageMemberShipStatus.animationRepeatCount = 999
        imageMemberShipStatus.startAnimating()
    }

    
    func setNotificationBadge() {
        
        let stCount = DataModel.getNotificationBadge()
        if stCount == ""{
            viewNotificationBadgeBG.isHidden = true
        }
        else if Int(stCount) == 0 {
            viewNotificationBadgeBG.isHidden = true
        }
        else if Int(stCount)! > 99 {
            viewNotificationBadgeBG.isHidden = false
            btnNotificationTitle.setTitle("99+", for: .normal)
        }
        else {
            self.viewNotificationBadgeBG.isHidden = false
            btnNotificationTitle.setTitle(stCount, for: .normal)
        }
    }
    
    func setHomeScreenData() {
        
        self.setHomeSliderData()
        self.setCouponData()
        self.setUserSummaryData()
    }

    func setHomeSliderData() {
        
        if !arrSlider.isEmpty {
            for _ in 0..<10 {
                arrSlider.append(contentsOf: arrSlider)
            }
            constraintTableViewTopToViewBillInfo.priority = PRIORITY_HIGH
            constraintTableViewCategoryTopToViewNote.priority = PRIORITY_LOW
            viewBillInfo.isHidden = false
            kolodaView.reloadData()
        }
        else {
            constraintTableViewTopToViewBillInfo.priority = PRIORITY_LOW
            constraintTableViewCategoryTopToViewNote.priority = PRIORITY_HIGH
            viewBillInfo.isHidden = true
        }
    }
    
    
    func setCouponData() {
        
        if !arrCouponList.isEmpty {
            let ind:Int = arrCategoryMain.index(where: { (dict1) -> Bool in
                return dict1[RES_type] as! String == "offer"
            })!
            var dict = arrCategoryMain[ind]
            dict[RES_categoryList] = arrCouponList as AnyObject?
            arrCategoryMain[ind] = dict
        }
        self.resizeTableView()
    }
    
    func setUserSummaryData() {
       
        if !dictUserSummary.isEmpty {
            let ind:Int = arrCategoryMain.index(where: { (dict1) -> Bool in
                return dict1[RES_type] as! String == "summary"
            })!
            var dict = arrCategoryMain[ind]
            dict[RES_categoryList] = dictUserSummary as AnyObject?
            arrCategoryMain[ind] = dict
        }
        self.resizeTableView()
    }
    
    func resizeTableView() {
        var categoryListResponse:typeAliasDictionary = DataModel.getCategoryListResponse()
        categoryListResponse[RES_data] =  arrCategoryMain as AnyObject?
        
        var height:CGFloat = 0;
        for i in 0..<arrCategoryMain.count {
            
            let dict = arrCategoryMain[i]
            if dict[RES_type] as! String == "mobile" {
              if !(dict[RES_categoryList] as! [typeAliasDictionary]).isEmpty { height += MOBILE_CELL_HEIGHT
                  arrCellheight[i] = MOBILE_CELL_HEIGHT
                }
            }
                
            else if dict[RES_type] as! String == "offer" {
                if !(dict[RES_categoryList] as! [typeAliasDictionary]).isEmpty { height += OFFER_CELL_HEIGHT ;                   arrCellheight[i] = OFFER_CELL_HEIGHT }
                }
                
            else if dict[RES_type] as! String == "summary" {
                if !dictUserSummary.isEmpty && Int(dictUserSummary[RES_totalMemeber] as! String)! > 0 {
                    height += USER_SUMMARY_HEIGHT;arrCellheight[i] = USER_SUMMARY_HEIGHT
                }
                else if !dictUserSummary.isEmpty && Int(dictUserSummary[RES_totalMemeber] as! String)! == 0 {
                    do{
                        let data:Data = try Data.init(contentsOf: (dictUserSummary[RES_inviteImage] as! String).convertToUrl())
                         let image = UIImage.init(data: data)
                            if image == nil { }
                            else {
                                let imageHeight = ((UIScreen.main.bounds.width - 10) * ((image?.size.height)!/(image?.size.width)!))
                                height += imageHeight + 50
                                arrCellheight[i] = imageHeight + 50
//                            self.constraintTableViewCategoryHeight.constant = height
//                            self.tableViewCategory.layoutIfNeeded()
                        }
                    }
                    catch {print("Oops!")}
               }
            }
            else if dict[RES_type] as! String == "shop" {
                height +=  SHOPPING_CELL_HEIGHT;arrCellheight[i] = SHOPPING_CELL_HEIGHT }
            }
        
        self.tableViewCategory.reloadData()
        constraintTableViewCategoryHeight.constant = height
        self.tableViewCategory.layoutIfNeeded()
        self.view.layoutIfNeeded()
     
    }
    
    func callHomeScreenDataService() {
        
        let userInfo: typeAliasDictionary = DataModel.getUserInfo()
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID: userInfo[RES_userID] as! String]
        obj_OperationWeb.callRestApi(methodName: JMETHOD_homeScreenData, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: UIView.init(frame: CGRect.zero), onSuccess: { (dict) in
            DataModel.setHomeScreenResponse(dict: dict)
            self.obj_AppDelegate.updateDictService(serviceName: JMETHOD_homeScreenData)
            self.obj_AppDelegate.updateDictService(serviceName: JMETHOD_CouponList)
            self.obj_AppDelegate.updateDictService(serviceName: JMETHOD_GetUserSummary)
            self.obj_AppDelegate.updateDictService(serviceName: JMETHOD_GetHomeSlider)
            
            self.arrSlider = dict[RES_homeSlider] as! [typeAliasDictionary]
            let dictCoupon = dict[RES_CouponList] as! typeAliasDictionary
            self.pageSize = Int(dictCoupon[RES_par_page] as! String)!
            self.totalPages = Int(dictCoupon[RES_total_pages] as! String)!
            self.totalRecords = Int(dictCoupon[RES_total_items] as! String)!
            let arrData: Array<typeAliasStringDictionary> = dictCoupon[RES_data] as! Array<typeAliasStringDictionary>
            self.arrCouponList = arrData as [typeAliasDictionary]
            self.dictUserSummary = dict[RES_userSummaryData] as! typeAliasDictionary
            self.dictShoppingData = dict[RES_userShoppingData] as! typeAliasDictionary
            self.setHomeScreenData()
            
        }, onFailure: { (code, dict) in
            
        }) {  self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return
        }
    }
    
    fileprivate func setWalletInfo(dict:typeAliasDictionary) {

        DataModel.setHeaderToken(dict[RES_token] as! String)
        let stWallet:String = "\(RUPEES_SYMBOL) \(dict[RES_wallet]!)"
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: stWallet, attributes: [NSFontAttributeName:UIFont(name: FONT_OPEN_SANS_SEMIBOLD, size: 13)!])
       // let location:Int = Int(stWallet.range(of: ".")?.lowerBound)
        let stWallet1 = stWallet.components(separatedBy: ".")
        let loc:Int =  (stWallet1.first?.characters.count)!
        
        myMutableString.addAttribute(NSFontAttributeName,
                                     value: UIFont(name: FONT_OPEN_SANS_SEMIBOLD,size: 11)!,range: NSMakeRange(loc + 1, 2))
        self.lblUserWallet.attributedText = myMutableString
        let width:CGFloat = stWallet.textWidth(17, textFont: UIFont.init(name: FONT_OPEN_SANS_SEMIBOLD, size: 17)!)
        constraintLblUserWalletWidth.constant =  width < 60 ? 60 :  width

        if  !obj_AppDelegate.isMemberShipFeesPaid() {
            self.setStaticImage(imageName: "feesnotpay", btn: btnMemberShipStatus)
        }
        else if DataModel.getUserWalletResponse()[RES_isReferrelActive] as! String == "0" {
            self.setStaticImage(imageName: "notprimemember", btn: btnMemberShipStatus)
        }
        else{
            self.imageMemberShipStatus.isHidden = true
            self.btnMemberShipStatus.isHidden = true
            constraintBtnNotificationLeadingToLblUserWallet.priority = PRIORITY_HIGH
            constraintBtnNotificationLeadingToBtnMembershipStatus.priority = PRIORITY_LOW
        }
    }

    
    fileprivate func setUserInfo() {
        
        if !DataModel.getUserInfo().isEmpty {
            
            self.setSheduleMaintanace()
            let userInfo: typeAliasDictionary = DataModel.getUserInfo()
            
            if !(userInfo[RES_userProfileImage] as! String).isEmpty {
                self.activityIndicator.startAnimating()
                let sturl = userInfo[RES_userProfileImage] as! String
                imageUserProfile.sd_setImage(with: NSURL.init(string: sturl) as URL!, completed: { (image, error, type, url) in
                    if image != nil {
                        self.imageUserProfile.isHidden = false
                        self.lblUserSortName.isHidden = true
                    }
                    else{
                        self.imageUserProfile.isHidden = true
                        self.lblUserSortName.isHidden = false
                    }
                    self.activityIndicator.stopAnimating()
                })
            }
            else{
                imageUserProfile.isHidden = true
                lblUserSortName.isHidden = false
            }
            
            let stFirstName: String = userInfo[RES_userFirstName] as! String
            let stLastName: String = userInfo[RES_userLastName] as! String
            var userFullName:String = stFirstName
            
            let startIndex = stFirstName.characters.index(stFirstName.startIndex, offsetBy: 0)
            let range = startIndex..<stFirstName.characters.index(stFirstName.startIndex, offsetBy: 1)
            let stFN = stFirstName.substring( with: range )
            var stLN:String = ""
            if !stLastName.isEmpty { stLN = stLastName.substring( with: range ); userFullName += " " + stLastName; }
            self.lblUserSortName.text = (stFN + stLN).uppercased()
            self.lblUserName.text = userFullName
        }
    }
    
    @objc fileprivate func callHomeGetUserWalletService() {
        
        self.indicatorWallet.startAnimating()
        let userInfo: typeAliasDictionary = DataModel.getUserInfo()
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID: userInfo[RES_userID] as! String,
                      REQ_DEVICE_TOKEN:DataModel.getUDID()]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_GetUserWallet, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController?.view != nil ? (self.navigationController?.view)! :UIView.init(frame: CGRect.zero) , onSuccess: { (dict) in
            self.isWalletServiceCall = false
            self.indicatorWallet.stopAnimating()
            DataModel.setHeaderToken(dict[RES_token] as! String)
            DataModel.setUserWalletResponse(dict: dict)
            DataModel.setIsPayMemberShipFee(dict[RES_isPayMemberShipFee] as! String)
            DataModel.setInviteFriendMsg(dict[RES_sharing_message] as! String)
            
            //ADD CONTACT  //UNCOMMENT IT
            if dict[RES_cubber_mobile_no] as! String != "" {
                //self.addContact(no: dict[RES_cubber_mobile_no] as! String , email: "")
            }
            
            let dictServiceUpdate:typeAliasDictionary = dict[RES_serviceUpdate] as! typeAliasDictionary
            self.obj_AppDelegate.isFirstServiceCall = false
            self.obj_AppDelegate.setServiceUpdateData(dictServiceUpdate: dictServiceUpdate)
            self.setWalletInfo(dict: dict)
            self.obj_AppDelegate.isWalletUpdate = false
            DataModel.setTrustedLogo(dict[RES_trusted_logo] as! String)
            DataModel.setPlanRechargeNote(dict[RES_recharge_plan_note] as! String)
            DataModel.setIsDisplayTLogo(dict[RES_is_display_tlogo] as! String)
            let dictCubberAdminInfo: typeAliasStringDictionary = [RES_cubber_admin: dict[RES_cubber_admin] != nil ? dict[RES_cubber_admin] as! String : "", RES_cubber_mobile_no: dict[RES_cubber_mobile_no] as! String]
            DataModel.setCubberAdminInfo(dictCubberAdminInfo)
            DataModel.setNotificationBadge(dict[RES_notification_count] as! String)
            DataModel.setNoMembershipFeesPayMsg(dict[RES_memberShipMessage] as! String)
            DataModel.setCubberMaintananceMessage(dict[RES_maintenance_message] as! String)
            if dict[RES_homeDialogActive] as! String == "1" {
                let _KDAlertView = KDAlertView()
                _KDAlertView.showWebViewAlert(stMessage: dict[RES_homeDialog] as! String, messageType: .WARNING, stTitle: dict[RES_homeDialogTitle] as! String)
            }
            //SET NOTIFICATION
            self.setNotificationBadge()
            
            self.obj_AppDelegate.galleryUrl = dict[RES_gallery_url] as! String
            let stVersions:String = dict[RES_ios_version] as! String
            let arrVersion: [String] = stVersions.components(separatedBy: ",")
            let stAppVersion = DataModel.getAppVersion()
            
            if !arrVersion.contains(stAppVersion) {
                self.dictAppVersionUpdate[RES_ios_update_msg] = dict[RES_ios_update_msg] as? String;
                self.dictAppVersionUpdate[RES_isComplusory] = dict[RES_isComplusory] as? String
                if self.obj_AppDelegate.isShowVersionUpdate {
                    let _ = UpdateVersionView.init(self.dictAppVersionUpdate)
                }
                self.obj_AppDelegate.dictAppVersionUpdate = typeAliasStringDictionary()
                self.obj_AppDelegate.isShowVersionUpdate = false
            }
            
            if (dict[RES_is_maintenance] as! String == "1") {
                let message: String = dict[RES_maintenance_message] as! String
                let splashVC = SplashViewController(nibName: "SplashViewController", bundle: nil)
                splashVC.stMaintananceMsg = message
                self.obj_AppDelegate.navigationController.pushViewController(splashVC, animated: true)
                return
            }
            if (dict[RES_ratingFlag] as! String == "1") {
                DataModel.setIsShowReviewPrompt(true)
            }
            else { DataModel.setIsShowReviewPrompt(false) }
            if (dict[RES_isIosAllowGTM] as! String == "1") {
                DataModel.setIsAllowGTM(true)
            }
            else {  DataModel.setIsAllowGTM(false) }
            if dict[RES_isGiveupApp] != nil {
                DataModel.setIsGiveUpApp(dict[RES_isGiveupApp]  as! String)
            }
            else{
             DataModel.setIsGiveUpApp("0")
            }
            self.obj_AppDelegate.stMaintananceMessage = dict[RES_schedule_maintenance_message] as! String
            self.setSheduleMaintanace()
            if !DataModel.getDictUserNotification().isEmpty {
                self.obj_AppDelegate.handlePushNotificationsFromHome(dict: DataModel.getDictUserNotification())
                DataModel.setDictUserNotification(typeAliasDictionary())
                return
            }
            self.getHomeScreenData()
            
        }, onFailure: { (code, dict) in
            self.indicatorWallet.stopAnimating()
            
        }) {
            self.indicatorWallet.stopAnimating()
            self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .INTERNET_WARNING)
            self._KDAlertView.didClick(completion: { (isClicked) in
                self.callHomeGetUserWalletService()
            })

        }
    }
    
    fileprivate func callCouponListService() {
        
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_PAGE_NO:"\(self.currentPage)"]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_CouponList, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: .init(), onSuccess: { (dict) in
            
            DataModel.setHeaderToken(dict[RES_token] as! String)
            let arrData: Array<typeAliasDictionary> = dict[RES_data] as! Array<typeAliasDictionary>
            self.arrCouponList += arrData
            self.pageSize = Int(dict[RES_par_page] as! String)!
            self.totalPages = Int(dict[RES_total_pages] as! String)!
            self.totalRecords = Int(dict[RES_total_items] as! String)!

            if self.currentPage == 1 {
              let dictCoupons: typeAliasDictionary = [RES_data:self.arrCouponList as AnyObject,
                                                        REQ_PAGE_NO:self.currentPage as AnyObject,
                                                        RES_par_page:self.pageSize as AnyObject,
                                                        RES_total_pages:self.totalPages as AnyObject,
                                                        RES_total_items:self.totalRecords as AnyObject]
             DataModel.setCoupons(dictCoupons)
             self.obj_AppDelegate.updateDictService(serviceName: JMETHOD_CouponList)
             self.getHomeSliderData()
            }
            self.setHomeScreenData()
            
        }, onFailure: { (code, dict) in
            
        }) {  self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return }
    }
    fileprivate func callGetUserSummaryService() {
        
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID:DataModel.getUserInfo()[RES_userID] as! String]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_GetUserSummary, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: .init(), onSuccess: { (dict) in
            
            DataModel.setHeaderToken(dict[RES_token] as! String)
            DataModel.setUserSummaryData(dict)
            self.dictUserSummary = dict[RES_userSummaryData] as! typeAliasDictionary
            self.dictShoppingData = dict[RES_userShoppingData] as! typeAliasDictionary
            self.obj_AppDelegate.updateDictService(serviceName: JMETHOD_GetUserSummary)
            self.setUserSummaryData()
            self.obj_AppDelegate.isReloadHomeScreen = false
            
        }, onFailure: { (code, dict) in
            
        }) {  self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return  }
    }
    fileprivate func callGetHomeSliderService() {
        
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID:DataModel.getUserInfo()[RES_userID] as! String]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_GetHomeSlider, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: .init(), onSuccess: { (dict) in
            
            DataModel.setHeaderToken(dict[RES_token] as! String)
            DataModel.setHomeSliderResponse(dict)
            self.arrSlider = dict[RES_data] as! [typeAliasDictionary]
            self.obj_AppDelegate.updateDictService(serviceName: JMETHOD_GetHomeSlider)
            self.getUserSummaryData()
            self.setHomeSliderData()
            
        }, onFailure: { (code, dict) in
            
        }) { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return  }
    }
    
    //MARK: TABLEVIEW DATA SOURCE
    
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int     { return arrCategoryMain.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:HomeCategoryViewCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_HOME_CATEGORY_CELL) as! HomeCategoryViewCell
        
        let dictCateMain :typeAliasDictionary = arrCategoryMain[indexPath.row]
        cell.collectionViewCategories.tag = indexPath.row
        cell.collectionViewCategories.delegate = self
        cell.collectionViewCategories.dataSource = self
        cell.btnInfo.isHidden = true
        
        if dictCateMain[RES_type] as! String == "mobile" {
            cell.userSummaryView.isHidden = true
            if let layout = cell.collectionViewCategories.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }
            cell.btnInviteFriend.isEnabled = false
            cell.imageViewInvite.isHidden = true
            cell.viewShopping.isHidden = true
             cell.collectionViewCategories.register(UINib.init(nibName: CELL_IDENTIFIER_HOME_CATEGORY_COLLECTION_CELL, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_HOME_CATEGORY_COLLECTION_CELL)
        }
        
        else if  dictCateMain[RES_type] as! String == "offer" {
            cell.userSummaryView.isHidden = true
            cell.btnInviteFriend.isEnabled = false
            if let layout = cell.collectionViewCategories.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }
            cell.imageViewInvite.isHidden = true
            cell.viewShopping.isHidden = true
            cell.collectionViewCategories.register(UINib.init(nibName: CELL_IDENTIFIER_COUPON, bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER_COUPON)
        }
        else if  dictCateMain[RES_type] as! String == "summary" {
             cell.viewShopping.isHidden = true
             cell.btnInfo.isHidden = false
            if !dictUserSummary.isEmpty && Int(dictUserSummary[RES_totalMemeber] as! String)! > 0 {
               // cell.constraintCollectionViewCategoryHeight.constant = 250
                let view = SummaryView.init(frame: CGRect.init(x: 0, y: 0, width:  tableViewCategory.frame.width - 10, height:250))
                cell.userSummaryView.isHidden = false
                cell.btnInviteFriend.isEnabled = false
                view.viewDashedLine.addDashedLine(color:COLOUR_TEXT_GRAY)
                view.loadData(dictSummary: dictUserSummary)
                cell.userSummaryView.addSubview(view)
                
            }
            else if !dictUserSummary.isEmpty && Int(dictUserSummary[RES_totalMemeber] as! String)! == 0 {
             cell.btnInviteFriend.isEnabled = true
             cell.imageViewInvite.sd_setImage(with: (dictUserSummary[RES_inviteImage] as! String).convertToUrl(), completed: { (image, error, type, url) in
                if image == nil { }
                else { cell.imageViewInvite.image = image ;
                       cell.userSummaryView.isHidden = true
                       cell.imageViewInvite.isHidden = false
                     }
                })
            }
            else{
             cell.userSummaryView.isHidden = true
             cell.btnInviteFriend.isEnabled = false
            }
        }
        
        else {
           
            cell.btnInviteFriend.isEnabled = false
            cell.imageViewInvite.isHidden = true
            cell.viewShopping.isHidden = false
            cell.collectionViewCategories.isHidden = true
            cell.userSummaryView.isHidden = true
            if !dictShoppingData.isEmpty {
                let amount:Double = Double(dictShoppingData[RES_tentativeAmount] as! String)!
                    if amount > 0 {
                        cell.viewShopNowBG.isHidden = true
                        cell.viewDate.isHidden = false
                        cell.btnShoppingAmount.isEnabled = true
                    }
                    else
                    {
                       cell.btnShoppingAmount.isEnabled = true
                       cell.viewShopNowBG.isHidden = false
                       cell.viewDate.isHidden = true
                    }
                let stAmount = String.init(format: "%.2f", amount)
                cell.lblShoppingTentativeAmount.text = "\(RUPEES_SYMBOL) \(stAmount)"
                cell.lblShopping_Date.text = dictShoppingData[RES_expectedDate]! as? String
            }
        }
        
        cell.contentView.layoutIfNeeded()
        cell.lblTitle.text = dictCateMain[RES_title] as? String
        cell.collectionViewCategories.reloadData()
        cell.selectionStyle = .none
        return cell
    }
    
    //MARK: TABLEVIEW DELEGATE
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return arrCellheight[indexPath.row]
        
      /*  let dictCateMain :typeAliasDictionary = arrCategoryMain[indexPath.row]
        if dictCateMain[RES_type] as! String == "mobile" {
            let  arrList = dictCateMain[RES_categoryList] as! [typeAliasDictionary]
            return arrList.count > 0 ? MOBILE_CELL_HEIGHT : 50
        }
        else   if dictCateMain[RES_type] as! String == "offer" {
            let  arrList = dictCateMain[RES_categoryList] as! [typeAliasDictionary]
            return  arrList.count > 0 ? OFFER_CELL_HEIGHT : 50
        }
        else if dictCateMain[RES_type] as! String == "summary" {
            
            if !dictUserSummary.isEmpty && Int(dictUserSummary[RES_totalMemeber] as! String)! > 0 {
                return USER_SUMMARY_HEIGHT
            }
            else if !dictUserSummary.isEmpty && Int(dictUserSummary[RES_totalMemeber] as! String)! == 0 {
                var height:CGFloat = 0
                let imageView = UIImageView()
                imageView.sd_setImage(with: (dictUserSummary[RES_inviteImage] as! String).convertToUrl(), completed: { (image, error, type, url) in
                    if image == nil { }
                    else {
                        imageView.image = image ;
                        height = ((UIScreen.main.bounds.width - 10) * ((image?.size.height)!/(image?.size.width)!))
                    }
                })

                 return height + 50
            }
            else { return 50 }
        }
        else if dictCateMain[RES_type] as! String == "shop" {
          return SHOPPING_CELL_HEIGHT
        }
        return 50*/
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    //MARK: COLLECTION VIEW DATA SOURCE
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {return 1}
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let dictCateMain:typeAliasDictionary = arrCategoryMain[collectionView.tag]
        if dictCateMain[RES_type] as! String == "summary" {return 0}
        arrCateList  = dictCateMain[RES_categoryList] as! [typeAliasDictionary]
        return arrCateList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let dictCateMain:typeAliasDictionary = arrCategoryMain[collectionView.tag]
        if dictCateMain[RES_type] as! String == "mobile" {  //RECHARGE, WALLET , BUS
            
            let cell: HomeCategoryCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER_HOME_CATEGORY_COLLECTION_CELL, for: indexPath) as! HomeCategoryCollectionCell
        
            arrCateList = dictCateMain[RES_categoryList] as! [typeAliasDictionary]
            let dictCat:typeAliasDictionary = arrCateList[indexPath.item]
        
            cell.lblTitle.text = dictCat[RES_operatorCategoryName] as? String
            cell.activityIndicator.startAnimating()
            
            
            if dictCat[RES_offerShortTitle] as! String != "" {
                cell.lblShortOffer.text = dictCat[RES_offerShortTitle] as? String
                cell.lblShortOffer.isHidden = false
                cell.lblShortTitleBG.isHidden = false
            }
            else{
                cell.lblShortOffer.isHidden =  true
                cell.lblShortTitleBG.isHidden = true
            }
        
            var stImage:String = ""
            if dictCat[RES_isActive] as! String == "1" { stImage = dictCat[RES_image] as! String } else { stImage = dictCat[RES_inActiveImage] as! String }

            cell.imageViewIcon.sd_setImage(with: stImage.convertToUrl()) { (image, error, type, url) in
                if image == nil { }
                else{
                   cell.imageViewIcon.image = image
                }
                cell.activityIndicator.stopAnimating()
            }
            
            if dictCat[RES_isActive] as! String == "0" { cell.lblTitle.textColor = UIColor.lightGray }
            else { cell.lblTitle.textColor = COLOUR_DARK_GREEN }
            return cell

        }
        
       else {
        
        let cell: CouponCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER_COUPON, for: indexPath)  as! CouponCell
        
        arrCateList = dictCateMain[RES_categoryList] as! [typeAliasDictionary]
        let dict:typeAliasDictionary = arrCateList[indexPath.item]

        cell.delegate = self
        cell.btnCoupon.accessibilityIdentifier = String(indexPath.row)
        cell.btnCoupon.accessibilityLabel = String(collectionView.tag)
        
        let setCouponLabel = {
            cell.imageViewCoupon.isHidden = true
            cell.lblCoupon.isHidden = false
            cell.lblCoupon.text = "User coupon code : \n\(dict[RES_couponCode]!)"
        }
        
        let stBanner: String = dict[RES_smallBanner]! as! String
        if !stBanner.isEmpty && stBanner != "0" {
            cell.imageViewCoupon.isHidden = false
            cell.lblCoupon.isHidden = true
            
            cell.imageViewCoupon.sd_setImage(with: stBanner.convertToUrl() as URL!, placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, progress:
                { (receivedSize, expectedSize) in cell.activityIndicator.startAnimating() })
            { (image, error, cacheType, imageURL) in
                
                if image == nil { setCouponLabel() }
                else { cell.imageViewCoupon.image = image!
                    
                    //self.scaleFactor = (image?.size.width)!/(image?.size.height)!
                }
                cell.activityIndicator.stopAnimating()
            }
        }
        else { setCouponLabel() }
        
        if (indexPath as NSIndexPath).row == self.arrCouponList.count - 1 {
            let page: Int = self.currentPage + 1
            if page <= self.totalPages {
                currentPage = page
                self.callCouponListService()
            }
        }
        return cell

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dictCateMain:typeAliasDictionary = arrCategoryMain[collectionView.tag]
        arrCateList  = dictCateMain[RES_categoryList] as! [typeAliasDictionary]
        let dictCat:typeAliasDictionary = arrCateList[indexPath.item]
        
        var isPaidFees:Bool = false
        if DataModel.getIsPayMemberShipFee() == "1"{
            isPaidFees = true;
        }
        else{
            if obj_AppDelegate.isMemberShipFeesPaid() { isPaidFees = true; }
            else { isPaidFees = false }
        }
        
        if dictCat[RES_isBrowser] != nil && dictCat[RES_isBrowser] as! String == "1" {
            if !isPaidFees {
                let _KDAlertView = KDAlertView()
                _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
                return
            }

            if dictCat[RES_url] as! String != "" {
                let webPreviewVC = WebPreviewViewController(nibName: "WebPreviewViewController", bundle: nil)
                webPreviewVC.stUrl = dictCat[RES_url]! as! String
                webPreviewVC.stTitle = dictCat[RES_operatorCategoryName]! as? String
                self.navigationController?.pushViewController(webPreviewVC, animated: true)
                return
            }
        }
        
        if dictCateMain[RES_type] as! String == "mobile" {
        
            if !isPaidFees {
                let _KDAlertView = KDAlertView()
                _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .MEMBERSHIP_WARNING)
                return
            }
            
            if HOME_CATEGORY_TYPE(rawValue: dictCat[RES_operatorCategoryId] as! String) != nil && dictCat[RES_isActive] as! String == "1" {
                let _HOME_CATEGORY_TYPE:HOME_CATEGORY_TYPE = HOME_CATEGORY_TYPE(rawValue: dictCat[RES_operatorCategoryId] as! String)!
                obj_AppDelegate.stRechargeImage =   dictCat[RES_image]  as! String
                obj_AppDelegate.navigateToHomeCategoryPage(_HOME_CATEGORY_TYPE: _HOME_CATEGORY_TYPE , dictOperatorCategory:dictCat)
            }
            else{
                _KDAlertView.showMessage(message: "Coming Soon", messageType: MESSAGE_TYPE.WARNING , title:"\(dictCat[RES_operatorCategoryName] as! String)")
            }
                
        }
            
        else if dictCateMain[RES_type] as! String == "offer" {
            
            if dictCat[RES_isRedirect] as! String  == "1" {
                
                if REDIRECT_SCREEN_TYPE(rawValue: dictCat[RES_redirectScreen] as! String) != nil {
                    obj_AppDelegate.redirectToScreen(_REDIRECT_SCREEN_TYPE: REDIRECT_SCREEN_TYPE(rawValue: dictCat[RES_redirectScreen] as! String)! , dict:dictCat)
                }
            }

            else {
                    if dictCat[RES_isShowDetail] as! String  == "1" {
                        let notificDetailVC = NotificationDetailViewController(nibName: "NotificationDetailViewController", bundle: nil)
                        notificDetailVC.dictNotification = dictCat as typeAliasDictionary
                        notificDetailVC.isCoupon = true
                        notificDetailVC.couponID = dictCat[RES_couponID] as! String
                        obj_AppDelegate.navigationController?.pushViewController(notificDetailVC, animated: true)
                    }
            }
        }
    }
    //MARK: COLLECTON VIEW DELEGATE FLOW LAYOUT
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let dictCateMain:typeAliasDictionary = arrCategoryMain[collectionView.tag]
        if dictCateMain[RES_type] as! String == "mobile" {
            return CGSize(width: 70 , height: COLLECTION_MOBILE_CELL_HEIGHT)
        }
        else  if dictCateMain[RES_type] as! String == "offer" {
            let width = HEIGHT_COUPON_CELL*1.8 //ASPECT RATION IS 1.8
            return CGSize(width: width , height: HEIGHT_COUPON_CELL)
        }
        else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    //MARK: KOLODA VIEW DELEGATE
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return arrSlider.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        let _BillInfoView = BillInfoView.init(frame: kolodaView.frame)
        
        let dictSlider:typeAliasDictionary = arrSlider[index]
        if dictSlider[RES_hs_price] != nil {
        if dictSlider[RES_hs_price] as! String != "" && Double(dictSlider[RES_hs_price] as! String)! > 0.0 {
            _BillInfoView.lblAmount.text = "\(RUPEES_SYMBOL)\(dictSlider[RES_hs_price] as! String)"
            _BillInfoView.lblAmount.isHidden = false
            _BillInfoView.constraintLblAmountWidth.constant = 90
        }
        else{_BillInfoView.lblAmount.isHidden = true;_BillInfoView.constraintLblAmountWidth.constant = 0}
        }
        else{
           _BillInfoView.lblAmount.isHidden = true;_BillInfoView.constraintLblAmountWidth.constant = 0
        }
        
        if dictSlider[RES_hs_icon] != nil {
            
            if dictSlider[RES_hs_icon] as! String != "" && dictSlider[RES_hs_isFullSlider] as! String == "1" {
                _BillInfoView.imageViewFullSlider.isHidden = false
                _BillInfoView.activityIndicator.startAnimating()
                _BillInfoView.imageViewFullSlider.sd_setImage(with: (dictSlider[RES_hs_icon] as! String).convertToUrl()) { (image, error, type, url) in
                    if image == nil { _BillInfoView.imageViewFullSlider.image = #imageLiteral(resourceName: "logo_nav")}
                    else {
                        _BillInfoView.imageViewFullSlider.image = image
                    }
                    _BillInfoView.activityIndicator.stopAnimating()
                }
            }
            else {
                _BillInfoView.imageViewFullSlider.isHidden = true
                _BillInfoView.imageViewIcon.sd_setImage(with: (dictSlider[RES_hs_icon] as! String).convertToUrl()) { (image, error, type, url) in
                    if image == nil { _BillInfoView.imageViewIcon.image = #imageLiteral(resourceName: "logo_nav")}
                    else {
                        _BillInfoView.imageViewIcon.image = image
                        let ratio = (image?.size.height)! / (image?.size.width)!
                        let height:CGFloat = 45 * ratio
                        if height > 100 {
                         _BillInfoView.constraintImageViewIconHeight.constant = 100
                        }
                        else{
                        _BillInfoView.constraintImageViewIconHeight.constant = height
                        }
                    }
                }
            }
        }
        
        
        if dictSlider[RES_hs_title] != nil {
            _BillInfoView.lblTitle.text = dictSlider[RES_hs_title] as! String?
        }
        else {
            _BillInfoView.lblTitle.text = ""
        }
        
        if dictSlider[RES_hs_title] != nil {
            _BillInfoView.lblDate.text = dictSlider[RES_hs_short_detail] as! String?
        }
        else {
            _BillInfoView.lblDate.text = dictSlider[RES_hs_short_detail] as! String?
        }
        
        _BillInfoView.lblTitle.text = dictSlider[RES_hs_title] as! String?
        _BillInfoView.lblDate.text = dictSlider[RES_hs_short_detail] as! String?
        _BillInfoView.btnPayNow.accessibilityIdentifier = String(index)
        if dictSlider[RES_hs_button_text] != nil && dictSlider[RES_hs_button_text] as! String != "" {
            _BillInfoView.btnPayNow.setTitle(dictSlider[RES_hs_button_text] as! String?, for: .normal)
            _BillInfoView.btnPayNow.isHidden = false
        }
        else {
            _BillInfoView.btnPayNow.isHidden = true
        }
        
        
        if dictSlider[RES_hs_button_offer] != nil && dictSlider[RES_hs_button_offer] as! String != "" {
            _BillInfoView.btnOffer.setTitle(dictSlider[RES_hs_button_offer] as! String?, for: .normal)
            _BillInfoView.btnOffer.isHidden = false
        }

        else {
            _BillInfoView.btnOffer.isHidden = true
        }

        if dictSlider[RES_hs_isRemove] as! String == "1" {
            _BillInfoView.viewCancel.isHidden = false
            _BillInfoView.btnCancel.isHidden = false
            _BillInfoView.btnCancel.accessibilityIdentifier = String(index)
        }
        else {
            _BillInfoView.viewCancel.isHidden = true
            _BillInfoView.btnCancel.isHidden = true
        }
        
        _BillInfoView.setShadowDrop(_BillInfoView)
        _BillInfoView.delegate = self
        
        return  _BillInfoView
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {

    }
    
    
    //MARK: BILL INFO VIEW DELEGATE
    
    func BillInfoView_btnCancelAction(button: UIButton) {
        
        let item:Int = Int(button.accessibilityIdentifier!)!
        let dictCat:typeAliasDictionary = arrSlider[item]
        let dictUserInfo: typeAliasDictionary = DataModel.getUserInfo()
        let params = [REQ_HEADER:DataModel.getHeaderToken() , REQ_USER_ID:dictUserInfo[RES_userID] as! String,REQ_UNIQUE_ID:dictCat[RES_unqId] as! String]
        obj_OperationWeb.callRestApi(methodName: JMETHOD_REMOVE_HOME_SLIDER, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (obj_AppDelegate.navigationController?.view)!, onSuccess: { (dict) in
            
            DesignModel.stopActivityIndicator()
            /*var arr = DataModel.getRemovedHomeSlider()
            arr.append(dictCat)
            DataModel.setRemovedHomeSlider(arr: arr)
            DataModel.setTodayDateForSlider(date: Date())*/
            
            self.kolodaView.swipe(.right)
        
                self.arrSlider = self.arrSlider.filter({ (dict) -> Bool in
                    return dict[RES_unqId] as! String != dictCat[RES_unqId] as! String
                })

            if !DataModel.getHomeSliderResponse().isEmpty {
                var dictHomeSlider = DataModel.getHomeSliderResponse()
                var arrSliderMain:[typeAliasDictionary] = dictHomeSlider[RES_data] as! [typeAliasDictionary]
                arrSliderMain = arrSliderMain.filter({ (dict) -> Bool in
                    return dict[RES_unqId] as! String != dictCat[RES_unqId] as! String
                })
                dictHomeSlider[RES_data] = arrSliderMain as AnyObject?
                DataModel.setHomeSliderResponse(dictHomeSlider)
                self.arrSlider = [typeAliasDictionary]()
                self.kolodaView.reloadData()
                self.arrSlider = arrSliderMain
            }
            else if !DataModel.getHomeScreenResponse().isEmpty {
                var dictHomeScreen = DataModel.getHomeScreenResponse()
                var arrSliderMain:[typeAliasDictionary] = dictHomeScreen[RES_homeSlider] as! [typeAliasDictionary]
                arrSliderMain = arrSliderMain.filter({ (dict) -> Bool in
                    return dict[RES_unqId] as! String != dictCat[RES_unqId] as! String
                })
                dictHomeScreen[RES_homeSlider] = arrSliderMain as AnyObject?
                DataModel.setHomeScreenResponse(dict: dictHomeScreen)
                self.arrSlider = [typeAliasDictionary]()
                self.kolodaView.reloadData()
                self.arrSlider = arrSliderMain
            }
            
            
                if !self.arrSlider.isEmpty {
                    for _ in 0..<10 {
                        self.arrSlider.append(contentsOf: self.arrSlider)
                    }
                    self.constraintTableViewTopToViewBillInfo.priority = PRIORITY_HIGH
                    self.constraintTableViewCategoryTopToViewNote.priority = PRIORITY_LOW
                    self.viewBillInfo.isHidden = false
                    self.kolodaView.reloadData()
                }
                else {
                    self.constraintTableViewTopToViewBillInfo.priority = PRIORITY_LOW
                    self.constraintTableViewCategoryTopToViewNote.priority = PRIORITY_HIGH
                    self.viewBillInfo.isHidden = true
                }
            
            
        }, onFailure: { (code, dict) in
            self._KDAlertView.showMessage(message: dict[RES_message]! as! String, messageType: MESSAGE_TYPE.FAILURE); return;
        }) { 
            self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return
        }
        //kolodaView.swipe(.right)
    }
    
    func redirectToServices(dictService:typeAliasDictionary){
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
        
        if HOME_CATEGORY_TYPE(rawValue: dictService[RES_operatorCategoryMasterId] as! String) != nil {
            
            let CATEGORY_TYPE:HOME_CATEGORY_TYPE = HOME_CATEGORY_TYPE(rawValue: dictService[RES_operatorCategoryMasterId] as! String)!
            
            var isPaidFees:Bool = false
            var isActive:Bool = false
            let dictOperatorCategory = getOperatorCategory("1",dictService[RES_operatorCategoryMasterId] as! String )

            if dictOperatorCategory[RES_isActive] as! String == "1" {
                isActive = true
            }
            
            let _KDAlertView = KDAlertView()
            if DataModel.getUserWalletResponse()[RES_isPayMemberShipFee] as! String == "1"{
                isPaidFees = true;
            }
            else{
                if obj_AppDelegate.isMemberShipFeesPaid() { isPaidFees = true; }
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
            
            switch CATEGORY_TYPE {
            case .MOBILE:
                let mobileRechargeVC = MobileRechargeViewController(nibName: "MobileRechargeViewController", bundle: nil)
                mobileRechargeVC.dictOpertaorCategory = dictOperatorCategory
                mobileRechargeVC.isFillOrder = true
                mobileRechargeVC.dictFillOrder = dictService
                self.navigationController?.pushViewController(mobileRechargeVC, animated: true)
                break
            case.DTH:
                let dthVC = DTHViewController(nibName: "DTHViewController", bundle: nil)
                dthVC.dictOpertaorCategory = dictOperatorCategory
                dthVC.isFillOrder = true
                dthVC.dictFillOrder = dictService
                self.navigationController?.pushViewController(dthVC, animated: true)
                break
            case.DATACARD:
                let dataCardVC = DataCardViewController(nibName: "DataCardViewController", bundle: nil)
                dataCardVC.dictOpertaorCategory = dictOperatorCategory
                dataCardVC.isFillOrder = true
                dataCardVC.dictFillOrder = dictService
                self.navigationController?.pushViewController(dataCardVC, animated: true)
                break
            case.ELECTRICITY:
                let elecVC = ElectricityBillViewController(nibName: "ElectricityBillViewController", bundle: nil)
                elecVC.dictOpertaorCategory = dictOperatorCategory
                elecVC.isFillOrder = true
                elecVC.dictFillOrder = dictService
                self.navigationController?.pushViewController(elecVC, animated: true)
                break
            case.GAS:
                let gasBillVC = GasBillViewController(nibName: "GasBillViewController", bundle: nil)
                gasBillVC.dictOpertaorCategory = dictOperatorCategory
                gasBillVC.isFillOrder = true
                gasBillVC.dictFillOrder = dictService
                self.navigationController?.pushViewController(gasBillVC, animated: true)
                break
            case.LANDLINE:
                let landlineVC = LandlineAndBroadBandViewController(nibName: "LandlineAndBroadBandViewController", bundle: nil)
                landlineVC.dictOpertaorCategory = dictOperatorCategory
                landlineVC.isFillOrder = true
                landlineVC.dictFillOrder = dictService
                self.navigationController?.pushViewController(landlineVC, animated: true)
                break
            case.BROADBAND:
                let landlineVC = LandlineAndBroadBandViewController(nibName: "LandlineAndBroadBandViewController", bundle: nil)
                landlineVC.dictOpertaorCategory = dictOperatorCategory
                landlineVC.isFillOrder = true
                landlineVC.dictFillOrder = dictService
                self.navigationController?.pushViewController(landlineVC, animated: true)
                break
            case.INSURANCE:
                let insuranceVC = InsuranceViewController(nibName: "InsuranceViewController", bundle: nil)
                insuranceVC.isFillOrder = true
                insuranceVC.dictFillOrder = dictService
                insuranceVC.dictOpertaorCategory = dictOperatorCategory
                self.navigationController?.pushViewController(insuranceVC, animated: true)
                break
                
            default:
                break
            }
        }
    }
    
    func BillInfoView_btnPayNowAction(button: UIButton) {
        
        let item:Int = Int(button.accessibilityIdentifier!)!
        let dictCat:typeAliasDictionary = arrSlider[item]
        
        if dictCat[RES_hs_isService] as! String == "1" {
            redirectToServices(dictService: dictCat)
        }
        else {
            if  dictCat[RES_isDirectRedirect] != nil && dictCat[RES_isDirectRedirect] as! String  == "1" {
                
                let dictUserInfo: typeAliasDictionary = DataModel.getUserInfo()
                let params = [REQ_HEADER:DataModel.getAffiliateHeaderToken() , REQ_PARTNER_ID:dictCat[RES_partner_id] as! String , REQ_USER_ID:dictUserInfo[RES_affiliateId] as! String , REQ_DEVICE_TYPE:"2" ,  REQ_offer_id:"\(dictCat[RES_offerId] as! String)"]
                
                obj_OperationWeb.callRest_Affiliate_Api(methodName: JMETHOD_AffilateClick, methodType: .POST, isAddToken: false, parameters: params , viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
                    DataModel.setAffiliateHeaderToken(dict[RES_token]! as! String)
                    let dictPartenerDetail:typeAliasStringDictionary = dict[RES_partnerDetail] as! typeAliasStringDictionary
                    UIApplication.shared.openURL((dictPartenerDetail[RES_redirectUrl]!).convertToUrl())
                    
                }, onFailure: { (code, dict) in
                    self._KDAlertView.showMessage(message: dict[RES_message]! as! String, messageType: MESSAGE_TYPE.FAILURE); return;
                    
                }, onTokenExpire: { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return})
            }
                
            else if dictCat[RES_isRedirect] as! String  == "1" {
                
                if REDIRECT_SCREEN_TYPE(rawValue: dictCat[RES_redirectScreen] as! String) != nil {
                    obj_AppDelegate.redirectToScreen(_REDIRECT_SCREEN_TYPE: REDIRECT_SCREEN_TYPE(rawValue: dictCat[RES_redirectScreen] as! String)! , dict:dictCat)
                }
            }
                
            else {
                if dictCat[RES_isShowDetail] as! String  == "1" {
                    let notificDetailVC = NotificationDetailViewController(nibName: "NotificationDetailViewController", bundle: nil)
                    notificDetailVC.dictNotification = dictCat as typeAliasDictionary
                    notificDetailVC.isCoupon = true
                    notificDetailVC.couponID = dictCat[RES_couponID] as! String
                    obj_AppDelegate.navigationController?.pushViewController(notificDetailVC, animated: true)
                }
            }
        }
    }
    
    func CouponCell_btnCouponAction(button: UIButton) {
        let tableInd:Int = Int(button.accessibilityLabel!)!
        let item:Int = Int(button.accessibilityIdentifier!)!
        
        let dictCateMain:typeAliasDictionary = arrCategoryMain[tableInd]
        arrCateList  = dictCateMain[RES_categoryList] as! [typeAliasDictionary]
        let dictCat:typeAliasDictionary = arrCateList[item]
        
            if dictCat[RES_isRedirect] as! String  == "1" {
                
                if REDIRECT_SCREEN_TYPE(rawValue: dictCat[RES_redirectScreen] as! String) != nil {
                    obj_AppDelegate.redirectToScreen(_REDIRECT_SCREEN_TYPE: REDIRECT_SCREEN_TYPE(rawValue: dictCat[RES_redirectScreen] as! String)! , dict:dictCat)
                }
            }
                
            else {
                if dictCat[RES_isShowDetail] as! String  == "1" {
                    let notificDetailVC = NotificationDetailViewController(nibName: "NotificationDetailViewController", bundle: nil)
                    notificDetailVC.dictNotification = dictCat as typeAliasDictionary
                    notificDetailVC.isCoupon = true
                    notificDetailVC.couponID = dictCat[RES_couponID] as! String
                    obj_AppDelegate.navigationController?.pushViewController(notificDetailVC, animated: true)
                }
            }
    }
    
}
