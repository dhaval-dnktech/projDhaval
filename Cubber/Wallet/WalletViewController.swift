//
//  WalletViewController.swift
//  Cubber
//
//  Created by dnk on 01/09/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController , AmountPickUpDelegate , UITextFieldDelegate , AppNavigationControllerDelegate {
    
    //MARK: PROPERTIES
    
    @IBOutlet var indicatorWallet: UIActivityIndicatorView!
    @IBOutlet var usedWalletCircularView: KDCircularProgress!
    @IBOutlet var lblUsedWalletAmount: UILabel!
    @IBOutlet var viewRightNav: UIView!
    @IBOutlet var lblUserWallet: UILabel!
    @IBOutlet var txtAmount: FloatLabelTextField!
    @IBOutlet var lblWalletUsedLimitNote: UILabel!
    
    @IBOutlet var lblWalletLimit: UILabel!
    @IBOutlet var constraintLblWalletWidth: NSLayoutConstraint!
    
    @IBOutlet var constraintViewStatusBarHeight: NSLayoutConstraint!
    
    //MAMRK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate let _KDAlertView = KDAlertView()
    fileprivate var _VKSideMenu = VKSideMenu()
    fileprivate var walletAmountFromService: Double = 0.00
    fileprivate var totalUsedWallet: Double = 0.00
    fileprivate var walletLimit: Double = 0.00
    fileprivate var isShowWalletUpgrade: String = ""
    @IBOutlet var btnUpgradeLimit: UIButton!
    @IBOutlet var viewAmountPickup: AmountPickUp!
    internal var  dictOperatorCategory = typeAliasDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0 , *){self.constraintViewStatusBarHeight.constant = 0}
        else{ self.constraintViewStatusBarHeight.constant = 20 }
        viewAmountPickup.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(recallUserWallet), name: NSNotification.Name(rawValue: NOTIFICATION_RECALL_WALLET), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if DataModel.getUserWalletResponse().isEmpty || obj_AppDelegate.isWalletUpdate { self.callGetUserWalletService() }
        else{ self.setWalletInfo(dict:  DataModel.getUserWalletResponse()) }
        self.setUserProperty(propertyName: F_Wallet_Tab , PropertyValue: F_WALLET_ADDMONEY)
        self.sendScreenView(name: "\(SCREEN_WALLET):\(SCREEN_WALLET_ADDMONEY)")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       self.SetScreenName(name: F_MODULE_WALLET, stclass: F_MODULE_WALLET)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    //MARK: - APP NAVIGATION CONTROLLER DELEGATE
    fileprivate func setNavigationBar() {
        
        obj_AppDelegate.navigationController.setCustomTitle("Wallet")
        obj_AppDelegate.navigationController.setSideMenuButton()
        obj_AppDelegate.navigationController.setRightView(self, view: viewRightNav, totalButtons: 3)
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_SideMenuAction() {
        _VKSideMenu = VKSideMenu()
        self.navigationController?.view.addSubview(self._VKSideMenu)
    }

    func recallUserWallet() {
        if (self.navigationController?.viewControllers.last?.isKind(of: WalletViewController.classForCoder()))! {
            self.callGetUserWalletService()
        }
    }

    //MARK: BUTTON METHODS
    @IBAction func btnSideMenuAction() {
        let _vkSideMenu = VKSideMenu()
        self.navigationController?.view.addSubview(_vkSideMenu)
    }
    
    
    @IBAction func btnAddMoney_UpgradeLimitAction(_ sender: UIButton) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let webPreviewVC = WebPreviewViewController(nibName: "WebPreviewViewController", bundle: nil)
        webPreviewVC.isShowToolBar = false
        webPreviewVC.stUrl = JUpgradeLimit
        webPreviewVC.stTitle = "Wallet Upgrade"
        webPreviewVC.isShowSave = true
        webPreviewVC.stDocName = "KYC.pdf"
        self.navigationController?.pushViewController(webPreviewVC, animated: true)
    }
    
    @IBAction func btnTransactionListAction() {
       
        let walletListVC  = WalletListViewController(nibName: "WalletListViewController", bundle: nil)
        walletListVC.walletAmount = (self.lblUserWallet.text?.trim())!
        self.navigationController?.pushViewController(walletListVC, animated: true)
    }

    @IBAction func btnAddMoney_AddMoneyAction() {
        
        txtAmount.resignFirstResponder()
        var stAmount: String = txtAmount.text!.trim()
        stAmount = Double(stAmount) == 0 ? "" : stAmount
        let dictUser = DataModel.getUserInfo()
        self.trackEvent(category: MAIN_CATEGORY+SCREEN_WALLET, action: SCREEN_WALLET_ADDMONEY, label: "(Mob:\(dictUser[RES_mobileNo]),\(RUPEES_SYMBOL) \(stAmount))", value: nil)
        if stAmount.isEmpty {
          _KDAlertView.showMessage(message: MSG_TXT_AMOUNT, messageType: MESSAGE_TYPE.FAILURE)
            return
        }
        
        let amountValidate: Double = totalUsedWallet + Double(stAmount)!
        if (amountValidate <= walletLimit){ self.showRechargeView(stAmount) }
        else {
            if (isShowWalletUpgrade == "1") {
                _KDAlertView.showMessage(message: "Please upgrade your wallet to increase your wallet limit.", messageType: MESSAGE_TYPE.FAILURE)
                return
            }
            else {
                _KDAlertView.showMessage(message: "You have \(RUPEES_SYMBOL) \(walletLimit) wallet limit. So, you can't add more money in your wallet.", messageType: MESSAGE_TYPE.FAILURE)
                return
            }
        }
    }

    //MARK: CUSTOM METHODS
    
    fileprivate func showRechargeView(_ amount: String) {
        
        var isPaidFees:Bool = false
        if DataModel.getUserWalletResponse()[RES_isPayMemberShipFee] as! String == "1"{
            isPaidFees = true;
        }
        else{
            if obj_AppDelegate.isMemberShipFeesPaid() { isPaidFees = true; }
            else { isPaidFees = false }
        }
        
        if isPaidFees {
            
            let rechargeVC = RechargeViewController(nibName: "RechargeViewController", bundle: nil)
            rechargeVC.mobile_CardOperator = "Add Money"
            rechargeVC.mobile_CardRegionName = ""
            rechargeVC.mobile_CardPrepaidPostpaid = ""
            rechargeVC.cart_PrepaidPostpaid = VAL_RECHARGE_NONE
            rechargeVC.cart_PlanTypeID = "0"
            rechargeVC.cart_MobileNo = ""
            rechargeVC.cart_TotalAmount = amount
            rechargeVC.cart_OperatorId = "0"
            rechargeVC.cart_RegionId = "0"
           // rechargeVC.cart_CategoryId = "0"
            rechargeVC.cart_CategoryId = dictOperatorCategory[RES_operatorCategoryId] as! String
            rechargeVC.cart_RegionPlanId =  "0"
            rechargeVC.cart_PlanValue =  amount
            rechargeVC._RECHARGE_TYPE = RECHARGE_TYPE.ADD_MONEY
            rechargeVC.stImageUrl = dictOperatorCategory[RES_image] as! String
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationController?.pushViewController(rechargeVC, animated: true)
            
            // SET GTMMODEL DATA FOR ADD TO CART
            
            let gtmModel = GTMModel()
            gtmModel.ee_type = GTM_EE_TYPE_WALLET
            gtmModel.name = GTM_ADDMONEY
            gtmModel.price = rechargeVC.cart_TotalAmount
            gtmModel.product_Id = DataModel.getUserInfo()[RES_userID] as! String
            gtmModel.brand = GTM_ADDMONEY
            gtmModel.category = GTM_EE_TYPE_WALLET
            gtmModel.variant = DataModel.getUserInfo()[RES_userMobileNo] as! String
            gtmModel.dimension3 = ""
            gtmModel.dimension4 = ""
            gtmModel.list = "AddMoney Section"
            GTMModel.pushProductDetail(gtmModel: gtmModel)
            GTMModel.pushAddToCart(gtmModel: gtmModel)
        }
        else{
            _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: MESSAGE_TYPE.FAILURE)
            return
        }
    }
    
    
    func setWalletInfo(dict:typeAliasDictionary) {
        
        self.walletAmountFromService = Double(dict[RES_wallet] as! String)!
        let stWallet:String = "\(RUPEES_SYMBOL) \(dict[RES_wallet]!)"
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: stWallet, attributes: [NSFontAttributeName:UIFont(name: FONT_OPEN_SANS_SEMIBOLD, size: 13)!])
        // let location:Int = Int(stWallet.range(of: ".")?.lowerBound)
        let stWallet1 = stWallet.components(separatedBy: ".")
        let loc:Int =  (stWallet1.first?.count)!
        
        myMutableString.addAttribute(NSFontAttributeName,
                                     value: UIFont(name: FONT_OPEN_SANS_SEMIBOLD,size: 11)!,range: NSMakeRange(loc + 1, 2))
        
       // self.lblUserWallet.text = "₹ 12345.00"
        self.lblUserWallet.attributedText = myMutableString
        let width :CGFloat =  self.lblUserWallet.text!.textWidth(25,  textFont: UIFont.init(name: FONT_OPEN_SANS_SEMIBOLD, size: 17)!)
      
       constraintLblWalletWidth.constant =  width < 60 ? 60 :  width+10
        self.lblUserWallet.layer.cornerRadius =  self.lblUserWallet.frame.height/2
        self.lblUserWallet.padding = UIEdgeInsetsMake(0, 5, 0, 5)
        self.viewRightNav.layoutIfNeeded()
        if DataModel.getUsedWalletResponse().isEmpty{  self.callGetUsedWalletService() }
        else { setUsedWalletInfo(dict:DataModel.getUsedWalletResponse()) }
    }
    
    func setUsedWalletInfo(dict:typeAliasDictionary) {
        
        DataModel.setHeaderToken(dict[RES_token] as! String)
        self.totalUsedWallet = Double(dict[RES_total_used_wallet] as! String)!
        self.walletLimit = Double(dict[RES_wallet_limit] as! String)!
        self.isShowWalletUpgrade = dict[RES_is_show_wallet_upgrade] as! String
        let angle:Double = (360 * self.totalUsedWallet )/self.walletLimit
       // self.usedWalletCircularView.angle = angle
        self.usedWalletCircularView.animate(toAngle: angle, duration: 0.5, completion: nil)
        self.lblUsedWalletAmount.text = String(format: "\(RUPEES_SYMBOL) %.2f", self.totalUsedWallet)
        if Int(self.totalUsedWallet) == 0 {
            
        }
        else{
            self.incrementLabel(to: Int(self.totalUsedWallet))
        }
        
        let stWalletLimit =  String(format: "%.2f", self.walletLimit)
         lblWalletLimit.text = "₹ \(stWalletLimit)"
        let stUsedWallet = String(format: "%.2f", self.totalUsedWallet)
        let greenColorAttrib = [NSForegroundColorAttributeName: COLOUR_DARK_GREEN]
        let partOne = NSMutableAttributedString(string: "\(RUPEES_SYMBOL) \(stUsedWallet) of \(stWalletLimit)/", attributes: greenColorAttrib)
        let combination = NSMutableAttributedString.init(string: "You have used ")
        combination.append(partOne)
        combination.append(NSMutableAttributedString.init(string: " month wallet usage limit."))
        self.lblWalletUsedLimitNote.attributedText = combination
        self.btnUpgradeLimit.isHidden = self.isShowWalletUpgrade == "1" ? false : true
        self.lblWalletLimit.layoutIfNeeded()
        self.view.layoutIfNeeded()
        
    }
    
    fileprivate func callGetUserWalletService() {
    
        indicatorWallet.startAnimating()
        let userInfo: typeAliasDictionary = DataModel.getUserInfo()
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID: userInfo[RES_userID] as! String,
                      REQ_DEVICE_TOKEN:DataModel.getUDID()]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_GetUserWallet, methodType:  METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController?.view != nil ? (self.navigationController?.view)! :UIView.init(frame: CGRect.zero), onSuccess: { (dict) in
            self.obj_AppDelegate.isWalletUpdate = false
            DataModel.setHeaderToken(dict[RES_token] as! String)
            DataModel.setUserWalletResponse(dict: dict)
            self.setWalletInfo(dict: dict)
            let dictServiceUpdate:typeAliasDictionary = dict[RES_serviceUpdate] as! typeAliasDictionary
            self.obj_AppDelegate.setServiceUpdateData(dictServiceUpdate: dictServiceUpdate)
            DataModel.setTrustedLogo(dict[RES_trusted_logo] as! String)
            DataModel.setPlanRechargeNote(dict[RES_recharge_plan_note] as! String)
            DataModel.setIsDisplayTLogo(dict[RES_is_display_tlogo] as! String)
            let dictCubberAdminInfo: typeAliasStringDictionary = [RES_cubber_admin: dict[RES_cubber_admin] != nil ? dict[RES_cubber_admin] as! String : "", RES_cubber_mobile_no: dict[RES_cubber_mobile_no] as! String]
            DataModel.setCubberAdminInfo(dictCubberAdminInfo)
            DataModel.setNotificationBadge(dict[RES_notification_count] as! String)
            //self.obj_AppDelegate.setNotificationBadge()
            let stVersions:String = dict[RES_ios_version] as! String
            let arrVersion: [String] = stVersions.components(separatedBy: ",")
            let stAppVersion = DataModel.getAppVersion()
            
            if (dict[RES_is_maintenance] as! String == "1"){
                let _ : String = dict[RES_maintenance_message] as! String
                //    self._VKAlertActionView.showOkAlertView(message, alertType: .DUMMY, object: "", isCallDelegate: false)
                return
            }
            
            if !arrVersion.contains(stAppVersion) {
                var dictAppVersionUpdate = typeAliasStringDictionary()
                dictAppVersionUpdate[RES_ios_update_msg] = dict[RES_ios_update_msg] as? String;
                dictAppVersionUpdate[RES_isComplusory] = dict[RES_isComplusory] as? String
                let _ = UpdateVersionView.init(dictAppVersionUpdate)
            }
            
            /*if !DataModel.getUserInfo().isEmpty {
             DataModel.setInviteFriendMsg(dict[RES_sharing_message] as! String)
             DataModel.setIsSetFriendInvteFriendMessage(true)
             }*/
            
            if (dict[RES_ratingFlag] as! String == "1") {
                DataModel.setIsShowReviewPrompt(true)
            }
            else{ DataModel.setIsShowReviewPrompt(false) }
            
            
            if dict[RES_schedule_maintenance_message] as! String != "" {
                self.obj_AppDelegate.stMaintananceMessage = dict[RES_schedule_maintenance_message] as! String }
            
        }, onFailure: { (code, dict) in
            self.indicatorWallet.stopAnimating()
            
        }) { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return
            self.indicatorWallet.stopAnimating()
        }
    }
    
    fileprivate func callGetUsedWalletService() {
        
        let userInfo: typeAliasDictionary = DataModel.getUserInfo()
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID: userInfo[RES_userID] as! String]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_GetUsedWallet, methodType:  METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController?.view != nil ? (self.navigationController?.view)! :UIView.init(frame: CGRect.zero), onSuccess: { (dict) in
            
            DataModel.setUsedWalletResponse(dict: dict)
            DataModel.setHeaderToken(dict[RES_token] as! String)
            self.totalUsedWallet = Double(dict[RES_total_used_wallet] as! String)!
            self.walletLimit = Double(dict[RES_wallet_limit] as! String)!
            self.isShowWalletUpgrade = dict[RES_is_show_wallet_upgrade] as! String
            self.setUsedWalletInfo(dict: dict)
            
        }, onFailure: { (code, dict) in
            
        }) { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return }
    }
    
    func incrementLabel(to endValue: Int) {
        let duration: Double = 0.5 //seconds
        DispatchQueue.global().async {
            for i in 0 ..< (endValue + 1) {
                let sleepTime = UInt32(duration/Double(endValue) * 1000000.0 )
                usleep(sleepTime)
                if i == endValue  {
                    DispatchQueue.main.async {
                       self.lblUsedWalletAmount.text = String(format: "\(RUPEES_SYMBOL) %.2f", self.totalUsedWallet)
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.lblUsedWalletAmount.text = "\(RUPEES_SYMBOL) \(i).00"
                    }
                }
            }
        }
    }
    
    //MARK: TEXTFIELD DELEGATE
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text: String = textField.text!
        let resultingString: String = text.replacingCharacters(in: range.toRange(string: text), with: string)
         
        if resultingString.isEmpty { return true }
        
        if  textField == txtAmount {
            viewAmountPickup.resetAmountPickUp()
            var holder: Float = 0.00
            let scan: Scanner = Scanner(string: resultingString)
            let RET: Bool = scan.scanFloat(&holder) && scan.isAtEnd
            if string == "." { return false }
            let amountLimit = Int(dictOperatorCategory[RES_amountLimit] as! String)
            if resultingString.count > amountLimit! { return false }
            return RET
        }
        return true
    }

    //MARK: AMOUNT PICK UP DELEGATE
    func amountPickUp_SelectedAmount(_ amount: String) {
        var stAmount = amount
       stAmount = stAmount.replaceWhiteSpace("")
        self.txtAmount.text = stAmount.replace(RUPEES_SYMBOL, withString: "")
    }
}
