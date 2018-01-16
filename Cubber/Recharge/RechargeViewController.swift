//
//  RechargeViewController.swift
//  Cubber
//
//  Created by dnk on 01/09/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class RechargeViewController: UIViewController , UITextFieldDelegate , ApplyPromocodeViewDelegate, AppNavigationControllerDelegate , GiveUpListViewDelegate {

    //MARK: PROPERTIES
    @IBOutlet var lblUserShortName: UILabel!
    @IBOutlet var imageViewProfile: UIImageView!
    @IBOutlet var scrollViewBG: UIScrollView!
    @IBOutlet var btnSegment_UseWallet: UIButton!
    @IBOutlet var btnSegment_Promocode: UIButton!
    @IBOutlet var lblRechargeInfo_UserName: UILabel!
    @IBOutlet var lblRechargeInfo_RechargeType: UILabel!
    
    @IBOutlet var btnProcessToPay: UIButton!
    
    @IBOutlet var constraintViewPromoTopToViewRechargeInfo: NSLayoutConstraint!
    
    @IBOutlet var constarintViewPromoTopToViewSegment: NSLayoutConstraint!
    
    @IBOutlet var constraintViewWalletBottomToSuper: NSLayoutConstraint!
    
    @IBOutlet var constraintViewPromocodeBottomToSuper: NSLayoutConstraint!
    
    //PROMOCODE
    
    @IBOutlet var scrollViewPromoCode: UIScrollView!
    @IBOutlet var viewPromocode: UIView!
    @IBOutlet var btnPromoCode_CommissionLevel: UIButton!
    @IBOutlet var lblPromocode_PromocodeCodeInfo: UILabel!
    @IBOutlet var viewPromocode_ApplyPromocodeBG: UIView!
    @IBOutlet var txtPromocode_PromoCode: FloatLabelTextField!
    @IBOutlet var btnPromocode_ApplyPromocode: UIButton!
    @IBOutlet var viewPromoCode_RechargeInfo: UIView!
    @IBOutlet var viewPromoCodeInfoBG: UIView!
    
    @IBOutlet var lblPromocode_RechargeDescription: UILabel!
    @IBOutlet var lblPromocode_RechargeAmount: UILabel!
    @IBOutlet var lblPromocode_CommissionInfo: UILabel!
    @IBOutlet var viewPromoCodeDetail: UIView!
    @IBOutlet var lblPromoCode_CouponName: UILabel!
    
    @IBOutlet var constraintPromoCode_ViewPromocodeTopToSuper: NSLayoutConstraint!
    @IBOutlet var constraintPromoCode_ViewPromoCodeTopTobtnCommissionLevel: NSLayoutConstraint!
    @IBOutlet var constraintLblWalletCommissionInfoTopToLblRechargeDesc: NSLayoutConstraint!
    @IBOutlet var constraintLblWalletCommissionInfoTopToLblWalletAmount: NSLayoutConstraint!
    
    @IBOutlet var constraintViewPromocodeRechargeInfoTopToSuper: NSLayoutConstraint!
    
    @IBOutlet var constraintViewPromoCodeRechargeInfoTopToBtnCommission: NSLayoutConstraint!
    
    @IBOutlet var constraintViewPromocodeRechargeInfoTopToViewApplyPromoCode: NSLayoutConstraint!
    
    @IBOutlet var constraintoPromocode_ViewApplyPromocodeHeight: NSLayoutConstraint!
    
    @IBOutlet var constraintPromcode_lblPromocodeInfoHeight: NSLayoutConstraint!
   
    
    //WALLET
    @IBOutlet var viewWallet: UIView!
    @IBOutlet var btnUseWallet_CommissionLevel: UIButton!
    @IBOutlet var viewUseWallet_RechargeInfo: UIView!
    @IBOutlet var lblUseWallet_RechargeDescription: UILabel!
    @IBOutlet var lblUseWallet_RechargeAmount: UILabel!
    @IBOutlet var btnUseWalletAmount: UIButton!
    @IBOutlet var lblUseWallet_RemainingAmount: UILabel!
    @IBOutlet var lblUseWallet_UsedWalletAmount: UILabel!
    @IBOutlet var lblUseWallet_CommissionInfo: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var constraintWallet_ViewRechargeInfoTopToSuper: NSLayoutConstraint!
    @IBOutlet var constraintWallet_ViewRechargeInfoTopTobtnCommissionLevel: NSLayoutConstraint!

    @IBOutlet var viewSegment_Wallet_PromoCode: UIView!
    @IBOutlet var btnGiveUpCashBack: UIButton!
    @IBOutlet var constraintBtnProcessToBtnGiveUp: NSLayoutConstraint!
    @IBOutlet var constraintBtnProcessTopToScrollView: NSLayoutConstraint!

    
    
    
    internal var _RECHARGE_TYPE: RECHARGE_TYPE = .DUMMY
    
    //MARK: VARIABLES
    
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate let _KDAlertView = KDAlertView()
    fileprivate var dictUserInfo: typeAliasDictionary = DataModel.getUserInfo()
    fileprivate var isUserWalletServiceCalled: Bool = false
    fileprivate var userPayAmount: Double = 0
    fileprivate var walletAmountFromService: Double = 0
    fileprivate var usedWallet: Double = 0.0
    fileprivate var stOrderType: String = ""
    fileprivate var finalPaidAmount: Double = 0.0
    fileprivate var arrCommissionLevel = [typeAliasStringDictionary]()
    fileprivate var arrCouponList = [typeAliasDictionary]()
    fileprivate var arrGiveUpList = [typeAliasDictionary]()
    internal var selectedGiveupId:String = ""
    internal var givupOperatorCategoryId:String = ""
    internal var isGiveUp:String = "0"
    internal var isNeverShow: Bool = false
    fileprivate var giveUpNote:String = ""
    fileprivate var giveUpTerms:String = ""
    
    fileprivate var isDistributedCommission:Bool = true
    fileprivate var _gtmModel = GTMModel()
    
    //MOBILE RECHARGE INFO
    internal var mobile_CardOperator: String = ""
    internal var mobile_CardRegionName: String = ""
    internal var mobile_CardPrepaidPostpaid: String = ""
    
    //CART DATA
    internal var cart_PrepaidPostpaid: String = "0"
    internal var cart_PlanTypeID: String = "0"
    internal var cart_MobileNo: String = "0"
    internal var cart_TotalAmount: String = "0"
    
    internal var cart_CouponCode: String = "0"
    internal var cart_CouponMessage: String = "0"
    internal var cart_CashBackAmount: String = "0"
    internal var cart_DiscountAmount: String = "0"
    
    internal var cart_Extra1: String = ""
    internal var cart_Extra2: String = ""
    
    internal var cart_OperatorId: String = "0"
    internal var cart_RegionId: String = "0"
    internal var cart_CategoryId: String = "0"
    internal var cart_RegionPlanId: String = "0"
    internal var cart_PlanValue: String = "0"
    internal var cart_ItemQty: String = "0"
    internal var cart_ItemCashBackAmount: String = "0"
    internal var cart_ItemDiscountAmount: String = "0"
    internal var cart_ItemServiceTax:String = "0"
    internal var cart_ItemSeatName:String = ""
    internal var cart_ItemSeatCategoryID:String = ""
    internal var cart_ItemSeatType:String = ""
    internal var cart_Amount:String = "0"
    
    internal var cart_SubCategory:String = "1"
    internal var cart_totalServiceTax:String = "0"
    internal var cart_totalPassengers:String = "0"
    internal var cart_journeyDate:String = ""
    internal var cart_subTotal:String = "0"
    internal var cart_paidAmount:String = "0"
    internal var cart_walletUsed:String = "0"
    internal var cart_couponID:String = "0"
    internal var cart_arrayPassengerDetail = [typeAliasStringDictionary]()
    internal var cart_arrselectedSeats = [typeAliasStringDictionary]()
    internal var cart_Email:String = ""
    internal var cart_DictBoardingPoint = typeAliasStringDictionary()
    fileprivate var dictCartAfterApplyCoupon = typeAliasDictionary()
    internal var dictRoute = typeAliasDictionary()
    internal var dictEvent = typeAliasDictionary()
    internal var cart_arrPassData = [typeAliasDictionary]()
    internal var cart_passengerName:String = ""
    internal var stTitle = ""
    internal var stImageUrl = ""
    
    //DONATE MONEY
    internal var donateeName:String = ""
    
    //FLIGHT VARAIBLES
    
    internal var dictFlight = typeAliasDictionary()
    internal var dictSource = typeAliasDictionary()
    internal var dictDest = typeAliasDictionary()
    internal var flightClass:String = ""
    internal var flightOperatorName:String = ""
    internal var dicFareDetails:typeAliasDictionary = typeAliasDictionary()
    internal var arrTravellerList = [typeAliasStringDictionary]()
    internal var flightConvinienceFees:String = "0"
    internal var passengerAddress:String = "0"
    internal var primaryMobileNo:String = "0"
    internal var isInternational:String = "0"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        lblPromocode_PromocodeCodeInfo.isHidden = true
        viewPromoCode_RechargeInfo.isHidden = false
        viewPromoCodeDetail.isHidden = true
        stOrderType = String(self._RECHARGE_TYPE.rawValue)
        self.setLoginInfo()
        
        switch _RECHARGE_TYPE {
            
        case RECHARGE_TYPE.MEMBERSHIP_FEES:

            stTitle = obj_AppDelegate.membershipTitle
            viewSegment_Wallet_PromoCode.isHidden = false
            constraintPromoCode_ViewPromocodeTopToSuper.priority = PRIORITY_HIGH
            constraintPromoCode_ViewPromoCodeTopTobtnCommissionLevel.priority = PRIORITY_LOW
            constraintWallet_ViewRechargeInfoTopToSuper.priority = PRIORITY_HIGH
            constraintWallet_ViewRechargeInfoTopTobtnCommissionLevel.priority = PRIORITY_LOW
            btnPromoCode_CommissionLevel.isHidden = true
            
            self.cart_PlanValue = self.cart_TotalAmount
            self.lblRechargeInfo_UserName.text = "\(dictUserInfo[RES_userFirstName]!) \(dictUserInfo[RES_userLastName]!)"
            self.lblRechargeInfo_RechargeType.text = "\(obj_AppDelegate.membershipTitle)"
            self.userPayAmount = Double(cart_TotalAmount)!
            let stUserPayAmount = String.init(format: "%.2f", self.userPayAmount)
            self.lblPromocode_RechargeAmount.text = "\(RUPEES_SYMBOL) \(stUserPayAmount)"
            self.lblUseWallet_RechargeAmount.text = "\(RUPEES_SYMBOL) \(stUserPayAmount)"
            btnPromoCode_CommissionLevel.isHidden = true
            lblPromocode_RechargeDescription.text = "Pay \(obj_AppDelegate.membershipTitle) of \(dictUserInfo[RES_userFirstName]!) \(dictUserInfo[RES_userLastName]!)"
            
            lblUseWallet_RechargeDescription.text = "Pay \(obj_AppDelegate.membershipTitle) of \(dictUserInfo[RES_userFirstName]!) \(dictUserInfo[RES_userLastName]!)"
            
            btnUseWallet_CommissionLevel.isHidden = true
            lblUseWallet_UsedWalletAmount.isHidden = true
            lblUseWallet_RemainingAmount.isHidden = true
            
            _gtmModel.ee_type = "Bill Pay"
            _gtmModel.name = obj_AppDelegate.membershipTitle
            self.view.layoutIfNeeded()

            break
        case RECHARGE_TYPE.MOBILE_RECHARGE:
            
            stTitle = stTitle == "" ?  "Mobile" : stTitle
            self.lblRechargeInfo_UserName.text = cart_MobileNo
            self.lblRechargeInfo_RechargeType.text = "\(self.mobile_CardOperator) \(self.mobile_CardRegionName) \(self.mobile_CardPrepaidPostpaid)"
            
            
            if self.cart_PrepaidPostpaid == VAL_RECHARGE_PREPAID { lblPromocode_RechargeDescription.text = "Recharge of \(self.mobile_CardOperator) Mobile \(self.cart_MobileNo)"
                lblUseWallet_RechargeDescription.text = "Recharge of \(self.mobile_CardOperator) Mobile \(self.cart_MobileNo)"
            }
            else { lblPromocode_RechargeDescription.text = "Bill Payment of \(self.mobile_CardOperator) Mobile \(self.cart_MobileNo)"
                lblUseWallet_RechargeDescription.text = "Recharge of \(self.mobile_CardOperator) Mobile \(self.cart_MobileNo)"
            }
            
            self.userPayAmount = Double(cart_TotalAmount)!
            let stUserPayAmount = String.init(format: "%.2f", self.userPayAmount)
            self.lblPromocode_RechargeAmount.text = "\(RUPEES_SYMBOL) \(stUserPayAmount)"
            self.lblUseWallet_RechargeAmount.text = "\(RUPEES_SYMBOL) \(stUserPayAmount)"
            
            _gtmModel.ee_type = GTM_EE_TYPE_RECHARGE
            _gtmModel.name = GTM_MOBILE_RECHARGE
            break
            
        case RECHARGE_TYPE.DTH_RECHARGE:
            
             stTitle = stTitle == "" ?  "DTH" : stTitle
            viewSegment_Wallet_PromoCode.isHidden = false
            self.lblRechargeInfo_UserName.text = cart_MobileNo
            
            var stRechargeInfo: String = self.mobile_CardOperator
            if self.mobile_CardRegionName != "0" { stRechargeInfo = stRechargeInfo + " " + self.mobile_CardRegionName }
            self.lblRechargeInfo_RechargeType.text = stRechargeInfo
            
            self.userPayAmount = Double(cart_TotalAmount)!
            let stUserPayAmount = String.init(format: "%.2f", self.userPayAmount)
            self.lblPromocode_RechargeAmount.text = "\(RUPEES_SYMBOL) \(stUserPayAmount)"
            self.lblUseWallet_RechargeAmount.text = "\(RUPEES_SYMBOL) \(stUserPayAmount)"
            
            lblPromocode_RechargeDescription.text = "Recharge of \(self.mobile_CardOperator) DTH \(self.cart_MobileNo)"
            lblUseWallet_RechargeDescription.text = "Recharge of \(self.mobile_CardOperator) DTH \(self.cart_MobileNo)"
            
            _gtmModel.ee_type = GTM_EE_TYPE_RECHARGE
            _gtmModel.name = GTM_DTH_RECHARGE

            break
            
        case RECHARGE_TYPE.ELECTRICITY_BILL, RECHARGE_TYPE.GAS_BILL, RECHARGE_TYPE.LANDLINE_BROABAND , RECHARGE_TYPE.INSURANCE:
            if _RECHARGE_TYPE == .ELECTRICITY_BILL {
                stTitle = stTitle == "" ?  "Electricity Bill" : stTitle
                _gtmModel.ee_type = GTM_EE_TYPE_BILL
                _gtmModel.name = GTM_ELE_BILL_PAY
            }
            else if _RECHARGE_TYPE == .GAS_BILL {
                stTitle = stTitle == "" ?  "GAS Bill" : stTitle
                _gtmModel.ee_type = GTM_EE_TYPE_BILL
                _gtmModel.name = GTM_GAS_BILL_PAY
            }
            else if _RECHARGE_TYPE == .LANDLINE_BROABAND {
                
                stTitle = stTitle == "" ?  "Landline/Broadband" : stTitle
                _gtmModel.ee_type = GTM_EE_TYPE_BILL
                _gtmModel.name = GTM_LANDLINE_BILL_PAY
            }
            else if _RECHARGE_TYPE == .INSURANCE {
                stTitle = stTitle == "" ?  "Insurance" : stTitle
                _gtmModel.ee_type = GTM_EE_TYPE_BILL
                _gtmModel.name = GTM_INSUARANCE_BILL_PAY
            }
            
            var stRechargeInfo: String = self.mobile_CardOperator
            if self.mobile_CardRegionName != "0" { stRechargeInfo = stRechargeInfo + " " + self.mobile_CardRegionName }
            self.lblRechargeInfo_RechargeType.text = stRechargeInfo
            self.userPayAmount = Double(cart_TotalAmount)!
            let stUserPayAmount = String.init(format: "%.2f", self.userPayAmount)
            self.lblPromocode_RechargeAmount.text = "\(RUPEES_SYMBOL) \(stUserPayAmount)"
            self.lblUseWallet_RechargeAmount.text = "\(RUPEES_SYMBOL) \(stUserPayAmount)"
            lblPromocode_RechargeDescription.text = "Bill Payment for \(self.mobile_CardOperator)  \(self.cart_MobileNo)"
            lblUseWallet_RechargeDescription.text = "Bill Payment for \(self.mobile_CardOperator)  \(self.cart_MobileNo)"
            break
        case RECHARGE_TYPE.ADD_MONEY:
            
             stTitle = "Add Money"
            
            self.lblRechargeInfo_UserName.text = "\(dictUserInfo[RES_userFirstName]!) \(dictUserInfo[RES_userLastName]!)"
            self.lblRechargeInfo_RechargeType.text = "\(self.mobile_CardOperator) \(self.mobile_CardRegionName) \(self.mobile_CardPrepaidPostpaid)"
            self.userPayAmount = Double(cart_TotalAmount)!

            viewSegment_Wallet_PromoCode.isHidden = true
            
            constraintPromoCode_ViewPromocodeTopToSuper.priority = PRIORITY_HIGH
            constraintPromoCode_ViewPromoCodeTopTobtnCommissionLevel.priority = PRIORITY_LOW
            constraintWallet_ViewRechargeInfoTopToSuper.priority = PRIORITY_HIGH
            constraintWallet_ViewRechargeInfoTopTobtnCommissionLevel.priority = PRIORITY_LOW
            btnPromoCode_CommissionLevel.isHidden = true
            
            lblPromocode_RechargeDescription.text = "Add Money"
            let stUserPayAmount = String.init(format: "%.2f", self.userPayAmount)
            self.lblPromocode_RechargeAmount.text = "\(RUPEES_SYMBOL) \(stUserPayAmount)"
             
            constarintViewPromoTopToViewSegment.priority = PRIORITY_LOW
            constraintViewPromoTopToViewRechargeInfo.priority = PRIORITY_HIGH
            
            self.view.layoutIfNeeded()
            break
            
        case RECHARGE_TYPE.DATA_CARD:
            
             stTitle = stTitle == "" ?  "Datacard" : stTitle

            _gtmModel.ee_type = GTM_EE_TYPE_RECHARGE
            _gtmModel.name = GTM_DATACARD_RECHARGE
            
            viewSegment_Wallet_PromoCode.isHidden = false
            
            self.lblRechargeInfo_UserName.text = cart_MobileNo
            self.lblRechargeInfo_RechargeType.text = "\(self.mobile_CardOperator) \(self.mobile_CardRegionName) \(self.mobile_CardPrepaidPostpaid)"
             self.userPayAmount = Double(cart_TotalAmount)!
             let stUserPayAmount = String.init(format: "%.2f", self.userPayAmount)
             self.lblPromocode_RechargeAmount.text = "\(RUPEES_SYMBOL) \(stUserPayAmount)"
             self.lblUseWallet_RechargeAmount.text = "\(RUPEES_SYMBOL) \(stUserPayAmount)"
            
            if self.cart_PrepaidPostpaid == VAL_RECHARGE_PREPAID { lblPromocode_RechargeDescription.text = "Recharge of \(self.mobile_CardOperator) \(self.cart_MobileNo)"
                lblUseWallet_RechargeDescription.text = "Recharge of \(self.mobile_CardOperator) \(self.cart_MobileNo)"
            }
            else { lblPromocode_RechargeDescription.text = "Bill Payment of \(self.mobile_CardOperator) \(self.cart_MobileNo)"
                lblUseWallet_RechargeDescription.text = "Bill Payment of \(self.mobile_CardOperator) \(self.cart_MobileNo)"
            }
            
            break
        case RECHARGE_TYPE.BUS_BOOKING:
            
             stTitle = "Bus Booking"
            viewSegment_Wallet_PromoCode.isHidden = false

             self.lblRechargeInfo_UserName.text = cart_MobileNo
            self.lblRechargeInfo_RechargeType.text = dictRoute[RES_RouteName] as? String
             self.userPayAmount = Double(cart_TotalAmount)!
             let stUserPayAmount = String.init(format: "%.2f", self.userPayAmount)
             self.lblPromocode_RechargeAmount.text = "\(RUPEES_SYMBOL) \(stUserPayAmount)"
             self.lblUseWallet_RechargeAmount.text = "\(RUPEES_SYMBOL) \(stUserPayAmount)"
            
            lblPromocode_RechargeDescription.text = "Bus ticket booking of \(dictRoute[RES_CompanyName] as! String) from \(dictRoute[RES_FromCityName] as! String) to \(dictRoute[RES_ToCityName] as! String) ."
            
            lblUseWallet_RechargeDescription.text = "Bus ticket booking of \(dictRoute[RES_CompanyName] as! String) from \(dictRoute[RES_FromCityName] as! String) to \(dictRoute[RES_ToCityName] as! String) ."
            
            let params = ["cart":self.createCartForBusBooking(false),
                      RES_userId:DataModel.getUserInfo()[RES_userID]!] as [String : Any]
        self.FIRLogEvent(name: F_MODULE_BUS, parameters: params as! [String : NSObject])
           break
            
        case RECHARGE_TYPE.EVENT:
            
            stTitle = "Event"
            _gtmModel.ee_type = GTM_EVENT
            _gtmModel.name = GTM_EVENT
            
            viewSegment_Wallet_PromoCode.isHidden = false
            self.lblRechargeInfo_UserName.text = ""
            self.lblRechargeInfo_RechargeType.text = dictEvent[RES_operatorName] as? String
            self.userPayAmount = Double(cart_TotalAmount)!
            let stUserPayAmount = String.init(format: "%.2f", self.userPayAmount)
            self.lblPromocode_RechargeAmount.text = "\(RUPEES_SYMBOL) \(stUserPayAmount)"
            self.lblUseWallet_RechargeAmount.text = "\(RUPEES_SYMBOL) \(stUserPayAmount)"
            lblPromocode_RechargeDescription.text = "Event ticket booking of \(dictEvent[RES_operatorName] as! String) ."
            lblUseWallet_RechargeDescription.text = "Event ticket booking of \(dictEvent[RES_operatorName] as! String) ."
            break
            
        case RECHARGE_TYPE.FLIGHT_BOOKING:
            
             stTitle = "Flight Booking"
            _gtmModel.ee_type = GTM_FLIGHT
            _gtmModel.name = GTM_FLIGHT
            
            viewSegment_Wallet_PromoCode.isHidden = false
            self.lblRechargeInfo_UserName.text = ""
            self.lblRechargeInfo_RechargeType.text = flightOperatorName
            self.userPayAmount = Double(cart_TotalAmount)!
            let stUserPayAmount = String.init(format: "%.2f", self.userPayAmount)
            self.lblPromocode_RechargeAmount.text = "\(RUPEES_SYMBOL) \(stUserPayAmount)"
            self.lblUseWallet_RechargeAmount.text = "\(RUPEES_SYMBOL) \(stUserPayAmount)"
            lblPromocode_RechargeDescription.text = "Flight ticket booking from \(dictSource[RES_regionName]!) to \(dictDest[RES_regionName]!)."
            lblUseWallet_RechargeDescription.text = "Flight ticket booking from \(dictSource[RES_regionName]!) to \(dictDest[RES_regionName]!)."
            break
        case RECHARGE_TYPE.DONATE_MONEY:
            
            stTitle = stTitle == "" ?  "Donate Money" : stTitle
            _gtmModel.ee_type = GTM_EE_TYPE_DONATE_MONEY
            _gtmModel.name = GTM_EE_TYPE_DONATE_MONEY
            
            viewSegment_Wallet_PromoCode.isHidden = false
            constraintPromoCode_ViewPromocodeTopToSuper.priority = PRIORITY_HIGH
            constraintPromoCode_ViewPromoCodeTopTobtnCommissionLevel.priority = PRIORITY_LOW
            constraintWallet_ViewRechargeInfoTopToSuper.priority = PRIORITY_HIGH
            constraintWallet_ViewRechargeInfoTopTobtnCommissionLevel.priority = PRIORITY_LOW
            btnPromoCode_CommissionLevel.isHidden = true
            btnUseWallet_CommissionLevel.isHidden = true

            self.lblRechargeInfo_RechargeType.text = stTitle
            self.userPayAmount = Double(cart_TotalAmount)!
            let stUserPayAmount = String.init(format: "%.2f", self.userPayAmount)
            self.lblPromocode_RechargeAmount.text = "\(RUPEES_SYMBOL) \(stUserPayAmount)"
            self.lblUseWallet_RechargeAmount.text = "\(RUPEES_SYMBOL) \(stUserPayAmount)"
            lblPromocode_RechargeDescription.text = "Donate money to \(self.donateeName)"
            lblUseWallet_RechargeDescription.text = "Donate  money to \(self.donateeName)"
            break
        default:
            break
        }
        self.calculatePaidAmount()
        if _RECHARGE_TYPE == .ADD_MONEY  {self.btnPrePostpaidAction(btnSegment_Promocode); }
        else { self.btnPrePostpaidAction(btnSegment_UseWallet) }
        self.btnPromoCode_CommissionLevelAction()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.registerForKeyboardNotifications()
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK: KEYBOARD
    fileprivate func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
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
    

    
    fileprivate func setNavigationBar(){
    
        obj_AppDelegate.navigationController.setCustomTitle(stTitle)
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: BUTTON METHODS
    
    func setLoginInfo() {
        
        let userInfo: typeAliasDictionary = DataModel.getUserInfo()
        
        if !stImageUrl.isEmpty {
            imageViewProfile.sd_setImage(with: NSURL.init(string: stImageUrl) as URL!, placeholderImage: UIImage(named: "icon_user"))
            imageViewProfile.isHidden = false
            lblUserShortName.isHidden = true
        }
        else if !obj_AppDelegate.stRechargeImage.isEmpty{
            imageViewProfile.sd_setImage(with: NSURL.init(string: obj_AppDelegate.stRechargeImage) as URL!, placeholderImage: UIImage(named: "icon_user"))
            imageViewProfile.isHidden = false
            lblUserShortName.isHidden = true
        }
        else {
            imageViewProfile.isHidden = false
            imageViewProfile.image = #imageLiteral(resourceName: "logo")
            lblUserShortName.isHidden = true
        }
        
       /* let stFirstName: String = userInfo[RES_userFirstName] as! String
        let stLastName: String = userInfo[RES_userLastName] as! String
        var userFullName:String = stFirstName
        
        let startIndex = stFirstName.characters.index(stFirstName.startIndex, offsetBy: 0)
        let range = startIndex..<stFirstName.characters.index(stFirstName.startIndex, offsetBy: 1)
        let stFN = stFirstName.substring( with: range )
        var stLN:String = ""
        if !stLastName.isEmpty { stLN = stLastName.substring( with: range ); userFullName += " " + stLastName; }
        lblUserShortName.text = (stFN + stLN).uppercased()*/
    }
    
    @IBAction func btnPromoCode_ApplyCouponAction() {
        
        let para = [RES_orderTypeID : stOrderType,
                    "Cart":_RECHARGE_TYPE == .BUS_BOOKING ?  self.createCartForBusBooking(false)  : self.createCart(false),
                    FIR_SELECT_CONTENT:"Apply Coupon"
        ]
        var module = F_HOME_TAB
        switch _RECHARGE_TYPE {
        case .MOBILE_RECHARGE:module = F_HOME_MOBILE ; break
        case .ADD_MONEY:module = F_WALLET_ADDMONEY ;break
        case.DTH_RECHARGE:module = F_HOME_DTH ;break
        case .MEMBERSHIP_FEES:module = F_MEMBERSHIP_FEES ;break
        case .ELECTRICITY_BILL:module = F_HOME_ELE ;break
        case.GAS_BILL:module = F_HOME_GAS ;break
        case .LANDLINE_BROABAND:module = F_HOME_LANDLINE ;break
        case .DATA_CARD:module = F_HOME_DATACARD ;break
        case.INSURANCE:module = F_HOME_INSURANCE ;break
        case .BUS_BOOKING:module = F_BUS_BOOKING ;break
            
        default:
            break
        }
        self.FIRLogEvent(name: module, parameters: para as [String : NSObject])
        self.sendEventTracking(isApplyCoupon: true)
        txtPromocode_PromoCode.resignFirstResponder()
        self.dictCartAfterApplyCoupon = typeAliasDictionary()
        let stCouponCode: String = txtPromocode_PromoCode.text!.trim()
        if stCouponCode.isEmpty {
            _KDAlertView.showMessage(message: MSG_TXT_PROMO_CODE, messageType: .WARNING);return;
        }
        
        cart_CouponCode = stCouponCode
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_CART:_RECHARGE_TYPE == .BUS_BOOKING ?  self.createCartForBusBooking(false)  : self.createCart(false),
                      REQ_USER_ID:DataModel.getUserInfo()[RES_userID] as! String,
                      REQ_ORDER_TYPE_ID:stOrderType,
                      REQ_DEVICE_TYPE:VAL_DEVICE_TYPE,
                      REQ_DEVICE_ID:DataModel.getUDID()]
        
        self.obj_OperationWeb.callRestApi(methodName: JMETHOD_AppliedCoupon, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
            
            let message: String = dict[RES_message] as! String
            self.dictCartAfterApplyCoupon = dict[RES_coupon_cart] as! typeAliasDictionary
            self._KDAlertView.showMessage(message: message, messageType: .WARNING)

            self.cart_CouponMessage = self.dictCartAfterApplyCoupon[RES_COUPON_MSG] as! String
            self.lblPromocode_PromocodeCodeInfo.text = self.cart_CouponMessage
            let height = self.lblPromocode_PromocodeCodeInfo.text?.textHeight(self.lblPromocode_PromocodeCodeInfo.frame.width, textFont: self.lblPromocode_PromocodeCodeInfo.font)
            self.constraintPromcode_lblPromocodeInfoHeight.constant = height!
            self.lblPromocode_PromocodeCodeInfo.isHidden = false
            self.viewPromocode_ApplyPromocodeBG.isHidden = true
            self.viewPromoCodeDetail.isHidden = false
            self.lblPromoCode_CouponName.text = self.dictCartAfterApplyCoupon[RES_COUPON_CODE] as? String
            self.cart_DiscountAmount = self.dictCartAfterApplyCoupon[RES_DISCOUNT_AMOUNT] as! String
            self.finalPaidAmount = (Double(self.dictCartAfterApplyCoupon[RES_PAID_AMOUNT] as! String))!
            self.viewPromoCodeInfoBG.isHidden = false
            self.viewPromoCodeInfoBG.layoutIfNeeded()
            self.viewPromoCodeInfoBG.layer.cornerRadius =  self.viewPromoCodeInfoBG.frame.height/2
            self.viewPromoCodeInfoBG.layoutIfNeeded()
            
            if self._RECHARGE_TYPE != .ADD_MONEY && self._RECHARGE_TYPE != .DONATE_MONEY  {
                self.constraintoPromocode_ViewApplyPromocodeHeight.constant = 1
                self.constraintPromoCode_ViewPromoCodeTopTobtnCommissionLevel.priority = PRIORITY_HIGH
                self.constraintViewPromocodeRechargeInfoTopToSuper.priority = PRIORITY_LOW
                self.constraintViewPromocodeRechargeInfoTopToViewApplyPromoCode.priority = PRIORITY_LOW
            }
            else {
                self.constraintoPromocode_ViewApplyPromocodeHeight.constant = 1
                self.constraintPromoCode_ViewPromoCodeTopTobtnCommissionLevel.priority = PRIORITY_LOW
                self.constraintViewPromocodeRechargeInfoTopToSuper.priority = PRIORITY_HIGH
                self.constraintViewPromocodeRechargeInfoTopToViewApplyPromoCode.priority = PRIORITY_LOW
            }
            self.viewPromocode.layoutIfNeeded()
            
            let stFinalAmt = self.finalPaidAmount == 0 ? "" : "\(RUPEES_SYMBOL) \(String.init(format: "%.2f", self.finalPaidAmount))"
            self.btnProcessToPay.setTitle("Proceed To Pay \(stFinalAmt)", for: .normal)
            print("Cart : Coupon : \(self.dictCartAfterApplyCoupon)")
            
        }, onFailure: { (code, dict) in
            self.cart_CouponCode = "0"
            self.cart_CouponMessage = "0"
            self.cart_DiscountAmount = "0"
            let message: String = dict[RES_message] as! String
            self._KDAlertView.showMessage(message: message, messageType: .WARNING)
        }) {   self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return    }
    }
    
    @IBAction func btnPromoCode_CouponDeleteAction() {
        
        self.lblPromocode_PromocodeCodeInfo.text = ""
        self.lblPromocode_PromocodeCodeInfo.isHidden = true
        self.viewPromocode_ApplyPromocodeBG.isHidden = false
        self.viewPromoCodeDetail.isHidden = true
        self.lblPromoCode_CouponName.text = ""
        txtPromocode_PromoCode.text = ""
        
        self.cart_CouponCode = "0"
        self.cart_CouponMessage = "0"
        self.cart_DiscountAmount = "0"
        self.cart_CashBackAmount = "0"
        self.cart_ItemCashBackAmount = "0"
        self.cart_ItemDiscountAmount = "0"
        
        if  _RECHARGE_TYPE == .DONATE_MONEY {
            
            self.constraintoPromocode_ViewApplyPromocodeHeight.constant = 45
            constraintPromoCode_ViewPromoCodeTopTobtnCommissionLevel.priority = PRIORITY_LOW
            constraintViewPromocodeRechargeInfoTopToSuper.priority = PRIORITY_LOW
            constraintViewPromocodeRechargeInfoTopToViewApplyPromoCode.priority = PRIORITY_HIGH
            
            constraintPromoCode_ViewPromocodeTopToSuper.priority = PRIORITY_HIGH
            constraintPromoCode_ViewPromoCodeTopTobtnCommissionLevel.priority = PRIORITY_LOW
            constraintWallet_ViewRechargeInfoTopToSuper.priority = PRIORITY_HIGH
            constraintWallet_ViewRechargeInfoTopTobtnCommissionLevel.priority = PRIORITY_LOW
            btnPromoCode_CommissionLevel.isHidden = true
            btnUseWallet_CommissionLevel.isHidden = true
            
        }
        else if _RECHARGE_TYPE != .ADD_MONEY  {
            
             self.constraintoPromocode_ViewApplyPromocodeHeight.constant = 45
            constraintPromoCode_ViewPromoCodeTopTobtnCommissionLevel.priority = PRIORITY_HIGH
            constraintViewPromocodeRechargeInfoTopToSuper.priority = PRIORITY_LOW
            constraintViewPromocodeRechargeInfoTopToViewApplyPromoCode.priority = PRIORITY_HIGH
            
          /*  constraintPromoCode_ViewPromocodeTopToSuper.priority = PRIORITY_LOW
            constraintPromoCode_ViewPromoCodeTopTobtnCommissionLevel.priority = PRIORITY_HIGH
            constraintWallet_ViewRechargeInfoTopToSuper.priority = PRIORITY_LOW
            constraintWallet_ViewRechargeInfoTopTobtnCommissionLevel.priority = PRIORITY_HIGH*/
            btnPromoCode_CommissionLevel.isHidden = false
            
        }
       
        else {
            
            self.constraintoPromocode_ViewApplyPromocodeHeight.constant = 45
            constraintPromoCode_ViewPromoCodeTopTobtnCommissionLevel.priority = PRIORITY_LOW
            constraintViewPromocodeRechargeInfoTopToSuper.priority = PRIORITY_LOW
            constraintViewPromocodeRechargeInfoTopToViewApplyPromoCode.priority = PRIORITY_HIGH
            constraintPromoCode_ViewPromocodeTopToSuper.priority = PRIORITY_HIGH
            constraintPromoCode_ViewPromoCodeTopTobtnCommissionLevel.priority = PRIORITY_LOW
            constraintWallet_ViewRechargeInfoTopToSuper.priority = PRIORITY_HIGH
            constraintWallet_ViewRechargeInfoTopTobtnCommissionLevel.priority = PRIORITY_LOW
            btnPromoCode_CommissionLevel.isHidden = true
        }
        self.viewPromocode.layoutIfNeeded()

        self.calculatePaidAmount()
        
        if !self.dictCartAfterApplyCoupon.isEmpty {
            self.dictCartAfterApplyCoupon[RES_COUPON_ID] = "0" as AnyObject?
            self.dictCartAfterApplyCoupon[RES_COUPON_CODE] = self.cart_CouponCode as AnyObject?
            self.dictCartAfterApplyCoupon[RES_COUPON_MSG] = self.cart_CouponMessage as AnyObject?
            self.dictCartAfterApplyCoupon[RES_DISCOUNT_AMOUNT] = self.cart_DiscountAmount as AnyObject?
            self.dictCartAfterApplyCoupon[RES_CASHBACK_AMOUNT] = self.cart_CashBackAmount as AnyObject?
            self.dictCartAfterApplyCoupon[RES_PAID_AMOUNT] = "\(self.finalPaidAmount)" as AnyObject?
            
            var arrItems: Array<typeAliasDictionary> = self.dictCartAfterApplyCoupon[RES_ITEMS] as! Array<typeAliasDictionary>
            for i in 0..<arrItems.count {
                var dict: typeAliasDictionary = arrItems[i]
                dict[RES_ITEM_CASHBACK] = "0" as AnyObject?
                dict[RES_ITEM_DISCOUNT] = "0" as AnyObject?
                arrItems[i] = dict
            }
            self.dictCartAfterApplyCoupon[RES_ITEMS] = arrItems as AnyObject?
        }
        
        print("Cart : Delete : \(self.dictCartAfterApplyCoupon)")
    }
    
    @IBAction func btnWallet_UserAmountAction() {
        self.btnUseWalletAmount.isSelected = !self.btnUseWalletAmount.isSelected
        
        if btnUseWalletAmount.isSelected {
            
            if !self.dictCartAfterApplyCoupon.isEmpty {
                
                let paidAmount: Double = (Double(self.dictCartAfterApplyCoupon[RES_PAID_AMOUNT] as! String))!
                
                if self.walletAmountFromService > paidAmount {
                    
                    let stPaidAmount = String.init(format: "%.2f", paidAmount)
                    self.lblUseWallet_UsedWalletAmount.text = "- \(RUPEES_SYMBOL) \(stPaidAmount)"
                    
                    let walletAmount: Double = self.walletAmountFromService - paidAmount
                    let stWalletAmount = String(format: "%.2f", walletAmount)
                    self.lblUseWallet_RemainingAmount.text = "\(RUPEES_SYMBOL) \(stWalletAmount) (Remaining Wallet)"
                    usedWallet = Double(paidAmount)
                }
                else {
                    
                     let stUsedWallet = String.init(format: "%.2f", self.walletAmountFromService)
                    self.lblUseWallet_UsedWalletAmount.text = "- \(RUPEES_SYMBOL) \(stUsedWallet)"
                    self.lblUseWallet_RemainingAmount.text = "\(RUPEES_SYMBOL) 0.00 (Remaining Wallet)"
                    usedWallet = self.walletAmountFromService
                }
            }
            else {
                
                if self.walletAmountFromService > self.userPayAmount {
                    
                    let stUsedWalletAmount = String.init(format: "%.2f", self.userPayAmount)
                    self.lblUseWallet_UsedWalletAmount.text = "- \(RUPEES_SYMBOL) \(stUsedWalletAmount)"
                    
                    let walletAmount: Double = self.walletAmountFromService - self.userPayAmount
                    self.lblUseWallet_RemainingAmount.text = "\(RUPEES_SYMBOL) \(String(format: "%.2f", walletAmount)) (Remaining Wallet)"
                    usedWallet = Double(self.userPayAmount)
                }
                else {
                     let stUsedWallet = String.init(format: "%.2f", self.walletAmountFromService)
                    self.lblUseWallet_UsedWalletAmount.text = "- \(RUPEES_SYMBOL) \(stUsedWallet)"
                    self.lblUseWallet_RemainingAmount.text = "\(RUPEES_SYMBOL) 0.00 (Remaining Wallet)"
                    usedWallet = self.walletAmountFromService
                }
            }
            self.lblUseWallet_UsedWalletAmount.isHidden = false
            self.calculatePaidAmount()
        }
        else {
            self.lblUseWallet_UsedWalletAmount.text = "0.00"
            self.lblUseWallet_UsedWalletAmount.isHidden = true
            let stUsedWallet = String.init(format: "%.2f", self.walletAmountFromService)
            self.lblUseWallet_RemainingAmount.text = "\(RUPEES_SYMBOL) \(stUsedWallet) (Remaining Wallet)"
            usedWallet = 0.0
            
            if !self.dictCartAfterApplyCoupon.isEmpty {
                self.calculatePaidAmount()
                self.dictCartAfterApplyCoupon[RES_WALLET_USED] = "0" as AnyObject?
                self.dictCartAfterApplyCoupon[RES_PAID_AMOUNT] = "\(self.finalPaidAmount)" as AnyObject?
            }
            else { self.calculatePaidAmount() }
        }
    }
    
    @IBAction func btnPromoCode_CommissionLevelAction() {
        
        if self.arrCommissionLevel.count == 0 {
            let userInfo: typeAliasDictionary = DataModel.getUserInfo()
            
            var params = [REQ_HEADER:DataModel.getHeaderToken(),
                          REQ_AMOUNT: _RECHARGE_TYPE == .BUS_BOOKING ? cart_TotalAmount:  self.cart_PlanValue,
                          REQ_OPERATOR_CATEGORY_ID:self.cart_CategoryId,
                          CART_SUB_CATEGORY_ID:self.cart_PrepaidPostpaid,
                          CART_OPERATOR_ID:self.cart_OperatorId,
                          REQ_ORDER_TYPE_ID:self.stOrderType,
                          REQ_DEVICE_TYPE:VAL_DEVICE_TYPE,
                          CART_REGION_ID:self.cart_RegionId,
                          CART_PLAN_TYPE_ID:self.cart_PlanTypeID,
                          REQ_USER_ID: userInfo[RES_userID] as! String,
                          ]
            
            if isDistributedCommission {
              //  lblWallet_Empty.isHidden = true
                params[REQ_isDestributedCommision] = "1"
                params[REQ_U_MOBILE] = DataModel.getUserInfo()[RES_userMobileNo] as? String
                if self.cart_Extra1 != "" {
                    params[CART_EXTRA_1] = self.cart_Extra1
                }
                if self.cart_Extra2 != "" {
                    params[CART_EXTRA_2] = self.cart_Extra2
                }
            }
            
            obj_OperationWeb.callRestApi(methodName: JMETHOD_CommissionLevelGraph, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
                
                if self.isDistributedCommission {
                    
                    //GIVE UP DATA
                    self.isGiveUp = dict.isKeyNull(RES_isGiveup)  ? "0" : String(describing: dict[RES_isGiveup]!)
                    self.isNeverShow = dict.isKeyNull(RES_isNeverShow)  ? false : String(describing: dict[RES_isNeverShow]!) == "1" ? true : false
                    
                    //CHANGE BEFORE LIVE
                    
                    if DataModel.getIsGiveUpApp() == "1" && self.isGiveUp  == "0" &&  !self.isNeverShow && !DataModel.getUserWalletResponse().isEmpty && DataModel.getUserWalletResponse()[RES_isReferrelActive] as! String == "1" {
                        
                        self.btnGiveUpCashBack.isHidden = false
                        self.arrGiveUpList = dict[RES_giveupAccount] as! [typeAliasDictionary]
                        self.givupOperatorCategoryId = dict.isKeyNull(RES_giveUpOperatorCategoryId) ? "" : dict[RES_giveUpOperatorCategoryId] as! String
                        self.selectedGiveupId = dict.isKeyNull(RES_giveupId) ? "0" : dict[RES_giveupId] as! String
                        self.giveUpNote = dict.isKeyNull(RES_giveupNote) ? "" : dict[RES_giveupNote] as! String
                        self.giveUpTerms = dict.isKeyNull(RES_giveupTerm) ? "" : dict[RES_giveupTerm] as! String
                        self.btnGiveUpCashBack.isSelected =  self.selectedGiveupId == "0" ? false : true 
                        self.btnGiveUpCashBack.backgroundColor = self.btnGiveUpCashBack.isSelected  ? COLOUR_DARK_GREEN :UIColor.lightGray
                        self.isNeverShow = false
                        self.constraintBtnProcessTopToScrollView.priority = PRIORITY_LOW
                        self.constraintBtnProcessToBtnGiveUp.priority = PRIORITY_HIGH
                    }
                   else {
                        self.btnGiveUpCashBack.isHidden = true
                        self.constraintBtnProcessTopToScrollView.priority = PRIORITY_HIGH
                        self.constraintBtnProcessToBtnGiveUp.priority = PRIORITY_LOW
                    }
                    
                    self.arrCouponList = dict[RES_couponListData] as! Array<typeAliasDictionary>
                    if self._RECHARGE_TYPE == .ADD_MONEY {
                        
                    }
                    else {
                        
                        self.walletAmountFromService = Double(dict[RES_wallet] as! String)!
                        if Double(self.walletAmountFromService) == 0 { self.lblUseWallet_RemainingAmount.text = "0.00";
                            self.btnUseWalletAmount.isHidden = true; self.lblUseWallet_RemainingAmount.isHidden = true ; self.btnUseWalletAmount.isHidden = true ;self.lblUseWallet_RemainingAmount.isHidden = true ; self.lblUseWallet_UsedWalletAmount.isHidden = true ;self.btnUseWalletAmount.isSelected = true
                            self.btnWallet_UserAmountAction()
                            self.constraintLblWalletCommissionInfoTopToLblRechargeDesc.priority = PRIORITY_HIGH
                            self.constraintLblWalletCommissionInfoTopToLblWalletAmount.priority = PRIORITY_LOW
                        }
                            
                        else {
                            let  walletAmount = String(format: "%.2f", self.walletAmountFromService)
                            self.lblUseWallet_RemainingAmount.text = "\(RUPEES_SYMBOL) \(walletAmount)"; self.btnUseWalletAmount.isHidden = false ;self.lblUseWallet_RemainingAmount.isHidden = false ;self.lblUseWallet_UsedWalletAmount.isHidden = false ;
                            self.btnUseWalletAmount.isSelected = false
                            self.btnWallet_UserAmountAction()
                            self.constraintLblWalletCommissionInfoTopToLblRechargeDesc.priority = PRIORITY_LOW
                            self.constraintLblWalletCommissionInfoTopToLblWalletAmount.priority = PRIORITY_HIGH
                        }
                        self.activityIndicator.stopAnimating()
                        let stCommission:String = DataModel.getUserInfo()[RES_isReferrelActive] as! String == "0" ? dict[RES_forNonPrime] as! String : dict[RES_forPrime] as! String
                        self.lblUseWallet_CommissionInfo.text = stCommission
                        self.lblUseWallet_CommissionInfo.textColor = DataModel.getUserInfo()[RES_isReferrelActive] as! String == "1" ? COLOUR_DARK_GREEN : COLOUR_ORDER_STATUS_FAILURE
                        self.lblPromocode_CommissionInfo.text = stCommission
                        self.lblPromocode_CommissionInfo.textColor = DataModel.getUserInfo()[RES_isReferrelActive] as! String == "1" ? COLOUR_DARK_GREEN : COLOUR_ORDER_STATUS_FAILURE
                        
                        if stCommission == "" {
                            self.constraintWallet_ViewRechargeInfoTopToSuper.priority = PRIORITY_HIGH
                            self.constraintWallet_ViewRechargeInfoTopTobtnCommissionLevel.priority = PRIORITY_LOW
                            self.constraintPromoCode_ViewPromocodeTopToSuper.priority = PRIORITY_HIGH
                            self.constraintPromoCode_ViewPromoCodeTopTobtnCommissionLevel.priority = PRIORITY_LOW
                            self.btnPromoCode_CommissionLevel.isHidden = true
                            self.btnUseWallet_CommissionLevel.isHidden = true
                        }
                        else if self._RECHARGE_TYPE != .MEMBERSHIP_FEES {
                            self.constraintPromoCode_ViewPromocodeTopToSuper.priority = PRIORITY_LOW
                            self.constraintPromoCode_ViewPromoCodeTopTobtnCommissionLevel.priority = PRIORITY_HIGH
                            self.constraintWallet_ViewRechargeInfoTopToSuper.priority = PRIORITY_LOW
                            self.constraintWallet_ViewRechargeInfoTopTobtnCommissionLevel.priority = PRIORITY_HIGH
                            self.btnPromoCode_CommissionLevel.isHidden = false
                            self.btnUseWallet_CommissionLevel.isHidden = false
                        }
                    }
                }
                else {
                    self.arrCommissionLevel = dict[RES_commision_graph] as! Array<typeAliasStringDictionary>
                    self.showCommisionLevel()
                }
                self.isDistributedCommission = false
                
            }, onFailure: { (code, dict) in
                if self.isDistributedCommission {
                    let message: String = dict[RES_message] as! String
                    self._KDAlertView.showMessage(message: message, messageType: .WARNING)
                    let _ = self.navigationController?.popViewController(animated: true)
                }

                else{
                    let message: String = dict[RES_message] as! String
                    self._KDAlertView.showMessage(message: message, messageType: .WARNING)
                }
                
                self.isDistributedCommission = false
            }, onTokenExpire: { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);
                 let _ = self.navigationController?.popViewController(animated: true)
            })
        }
        else { self.showCommisionLevel() }
    }
    
    @IBAction func btnPrePostpaidAction(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            btnSegment_UseWallet.isSelected = true
            btnSegment_Promocode.isSelected = false
            btnSegment_UseWallet.backgroundColor = COLOUR_ORANGE
            btnSegment_UseWallet.setTitleColor(UIColor.white, for: .normal)
            btnSegment_Promocode.backgroundColor = UIColor.white
            btnSegment_Promocode.setTitleColor(COLOUR_TEXT_GRAY, for: .normal)
            viewWallet.isHidden = false
            viewPromocode.isHidden = true
            constraintViewWalletBottomToSuper.priority = PRIORITY_HIGH
            constraintViewPromocodeBottomToSuper.priority = PRIORITY_LOW
         }
        else {
            btnSegment_UseWallet.isSelected = false
            btnSegment_Promocode.isSelected = true
            btnSegment_Promocode.backgroundColor = COLOUR_ORANGE
            btnSegment_Promocode.setTitleColor(UIColor.white, for: .normal)
            btnSegment_UseWallet.backgroundColor = UIColor.white
            btnSegment_UseWallet.setTitleColor(COLOUR_TEXT_GRAY, for: .normal)
            viewWallet.isHidden = true
            viewPromocode.isHidden = false
            constraintViewWalletBottomToSuper.priority = PRIORITY_LOW
            constraintViewPromocodeBottomToSuper.priority = PRIORITY_HIGH
            if !self.arrCouponList.isEmpty && self.viewPromoCodeDetail.isHidden { self.showApplyPrmoView() }
        }
        self.view.layoutIfNeeded()
    }

    @IBAction func btnProcessToPayAction() {
        
        let para = [RES_orderTypeID : stOrderType,
                    "Cart":_RECHARGE_TYPE == .BUS_BOOKING ?  self.createCartForBusBooking(false)  : self.createCart(false),
                    FIR_SELECT_CONTENT:"Add Order"
        ]
        var module = F_HOME_TAB
        switch _RECHARGE_TYPE {
        case .MOBILE_RECHARGE:module = F_HOME_MOBILE ; break
        case .ADD_MONEY:module = F_WALLET_ADDMONEY ;break
        case.DTH_RECHARGE:module = F_HOME_DTH ;break
        case .MEMBERSHIP_FEES:module = F_MEMBERSHIP_FEES ;break
        case .ELECTRICITY_BILL:module = F_HOME_ELE ;break
        case.GAS_BILL:module = F_HOME_GAS ;break
        case .LANDLINE_BROABAND:module = F_HOME_LANDLINE ;break
        case .DATA_CARD:module = F_HOME_DATACARD ;break
        case.INSURANCE:module = F_HOME_INSURANCE ;break
        case .BUS_BOOKING:module = F_BUS_BOOKING ;break
            
        default:
            break
        }
        self.FIRLogEvent(name: module, parameters: para as [String : NSObject])
        
        self.sendEventTracking(isApplyCoupon: false)
        
        
        
        // SET GTM CHECKOUT MODEL
        if  _RECHARGE_TYPE == .EVENT {
            
            _gtmModel.name = GTM_EVENT_BOOKING
            _gtmModel.price = cart_subTotal
            _gtmModel.product_Id = dictUserInfo[RES_userID] as! String
            _gtmModel.brand = self.dictEvent[RES_operatorName] as! String
            _gtmModel.category = self.dictEvent[RES_venue] as! String
            _gtmModel.variant = self.dictEvent[RES_operatorName] as! String
            _gtmModel.option = "Proceed to Pay"
            _gtmModel.step = 3
            _gtmModel.dimension4 = "0"
            _gtmModel.dimension3 = self.dictEvent[RES_regionID] as! String
            _gtmModel.dimension10 = "\(self.usedWallet)"
            _gtmModel.dimension11 = "\(self.cart_DiscountAmount)"
            _gtmModel.dimension12 = "\(self.cart_CouponCode == "0" ? "" : self.cart_CouponCode)"
            GTMModel.pushCheckout(gtmModel: _gtmModel)
            
        }
        else if _RECHARGE_TYPE != .BUS_BOOKING && _RECHARGE_TYPE != .ADD_MONEY {
            
            _gtmModel.price = self.cart_TotalAmount
            _gtmModel.product_Id = dictUserInfo[RES_userID] as! String
            _gtmModel.brand = self.mobile_CardOperator
            _gtmModel.category = self.mobile_CardPrepaidPostpaid
            _gtmModel.variant = self.cart_MobileNo
            _gtmModel.option = "Proceed to Pay"
            _gtmModel.step = 1
            _gtmModel.dimension3 = self.mobile_CardOperator != "0"  ? "\(self.mobile_CardOperator):\(self.mobile_CardRegionName)" : ""
            _gtmModel.dimension4 = "0"
            _gtmModel.quantity = 1
            _gtmModel.dimension10 = "\(self.usedWallet)"
            _gtmModel.dimension11 = "\(self.cart_DiscountAmount)"
            _gtmModel.dimension12 = "\(self.cart_CouponCode == "0" ? "" : self.cart_CouponCode)"
            GTMModel.pushCheckout(gtmModel: _gtmModel)
        }
        else if  _RECHARGE_TYPE == .ADD_MONEY {
            
            _gtmModel.ee_type = GTM_EE_TYPE_WALLET
            _gtmModel.price = self.cart_TotalAmount
            _gtmModel.product_Id = dictUserInfo[RES_userID] as! String
            _gtmModel.name = GTM_ADDMONEY
            _gtmModel.brand = GTM_ADDMONEY
            _gtmModel.category = GTM_EE_TYPE_WALLET
            _gtmModel.variant = DataModel.getUserInfo()[RES_userMobileNo] as! String
            _gtmModel.option = "Proceed to Pay"
            _gtmModel.step = 1
            _gtmModel.quantity = 1
            _gtmModel.dimension10 = "\(self.usedWallet)"
            _gtmModel.dimension11 = "\(self.cart_DiscountAmount)"
            _gtmModel.dimension12 = "\(self.cart_CouponCode == "0" ? "" : self.cart_CouponCode)"
            GTMModel.pushCheckoutWallet(gtmModel: _gtmModel)
        }
        else if  _RECHARGE_TYPE == .DONATE_MONEY {
            
            _gtmModel.name = GTM_DONATE_MONEY
            _gtmModel.price = self.cart_TotalAmount
            _gtmModel.product_Id = dictUserInfo[RES_userID] as! String
            _gtmModel.brand = GTM_DONATE_MONEY
            _gtmModel.category = GTM_EE_TYPE_WALLET
            _gtmModel.variant = self.cart_MobileNo
            _gtmModel.option = "Proceed to Pay"
            _gtmModel.step = 1
            _gtmModel.quantity = 1
            _gtmModel.dimension10 = "\(self.usedWallet)"
            _gtmModel.dimension11 = "\(self.cart_DiscountAmount)"
            _gtmModel.dimension12 = "\(self.cart_CouponCode == "0" ? "" : self.cart_CouponCode)"
            GTMModel.pushCheckoutWallet(gtmModel: _gtmModel)
        }
            
        else if _RECHARGE_TYPE == .BUS_BOOKING {
            
            _gtmModel.ee_type = GTM_BUS
            _gtmModel.name = GTM_BUS_BOOKING
            _gtmModel.price = self.cart_TotalAmount
            _gtmModel.product_Id = dictUserInfo[RES_userID] as! String
            _gtmModel.brand = self.dictRoute[RES_CompanyName] as! String
            _gtmModel.category =  "\(self.dictRoute[RES_FromCityName] as! String) To \(dictRoute[RES_ToCityName] as! String)"
            _gtmModel.variant = self.dictRoute[RES_ArrangementName] as! String
            _gtmModel.option = "Proceed to Pay"
            _gtmModel.step = 3
            _gtmModel.quantity = cart_arrselectedSeats.count
            _gtmModel.dimension5 = "\(self.dictRoute[RES_FromCityName] as! String) : \(dictRoute[RES_ToCityName] as! String)"
            _gtmModel.dimension6 = dictRoute[RES_BookingDate] as! String
            _gtmModel.dimension10 = "\(self.usedWallet)"
            _gtmModel.dimension11 = "\(self.cart_DiscountAmount)"
            _gtmModel.dimension12 = "\(self.cart_CouponCode == "0" ? "" : self.cart_CouponCode)"
            GTMModel.pushCheckoutBus(gtmModel: _gtmModel)
        }
        
        else if _RECHARGE_TYPE == .FLIGHT_BOOKING {
            
             let dictOneWay = self.dictFlight[RES_OneWay] as! typeAliasDictionary
            _gtmModel.ee_type = GTM_FLIGHT
            _gtmModel.name = GTM_FLIGHT_BOOKING
            _gtmModel.price = self.cart_TotalAmount
            _gtmModel.product_Id = dictUserInfo[RES_userID] as! String
            _gtmModel.brand = self.flightOperatorName
            _gtmModel.category = "\(self.dictSource[RES_regionName] as! String) To \(dictDest[RES_regionName] as! String)"
            _gtmModel.variant = self.cart_Extra1
            _gtmModel.option = "Proceed to Pay"
            _gtmModel.step = 3
            _gtmModel.quantity = self.arrTravellerList.count
            _gtmModel.dimension5 = "\(self.dictSource[RES_regionName] as! String) : \(dictDest[RES_regionName] as! String)"
            _gtmModel.dimension6 = dictOneWay[RES_DepDate] as! String
            _gtmModel.dimension10 = "\(self.usedWallet)"
            _gtmModel.dimension11 = "\(self.cart_DiscountAmount)"
            _gtmModel.dimension12 = "\(self.cart_CouponCode == "0" ? "" : self.cart_CouponCode)"
            GTMModel.pushCheckoutBus(gtmModel: _gtmModel)
        }
        
        var params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_CART:_RECHARGE_TYPE == .BUS_BOOKING ?  self.createCartForBusBooking(false)  : self.createCart(false),
                      REQ_USER_ID:dictUserInfo[RES_userID] as! String,
                      REQ_ORDER_TYPE_ID:stOrderType,
                      REQ_DEVICE_TYPE:VAL_DEVICE_TYPE,
                      REQ_ISNEVERGIVEUP:self.isNeverShow ? "1" : "0",
                      REQ_GIVEUPID:self.selectedGiveupId ]
        if self.btnGiveUpCashBack.isHidden || !self.btnGiveUpCashBack.isSelected {
            params[REQ_ISGIVEUP] = "0"
        }
        else if self.btnGiveUpCashBack.isSelected {
              params[REQ_ISGIVEUP] = "1"
        }
        else{
            params[REQ_ISGIVEUP] = "1"
        }
        
        print("Recharge Para : \(params)")
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_AddOrder, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
            
            DataModel.setUserWalletResponse(dict: typeAliasDictionary())
            DataModel.setUsedWalletResponse(dict: typeAliasDictionary())
            /*NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFICATION_RELOAD_WALLET), object: nil) //POST NOTIFICATION*/
            
            let dictOrderInfo: typeAliasDictionary = dict[RES_order]![RES_order_detail] as! typeAliasDictionary
            let orderAmount: Double = (Double(dictOrderInfo[RES_orderAmount] as! String))!
            if orderAmount == 0 {

                if self._RECHARGE_TYPE == RECHARGE_TYPE.MEMBERSHIP_FEES {
                    self.dictUserInfo[RES_isMemberFeesPay] = "1" as AnyObject
                    self.dictUserInfo[RES_memberShipFees] = DataModel.getMemberShipFees() as AnyObject
                    DataModel.setUserInfo(self.dictUserInfo)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFICATION_MEMBERSHIP_FEE_PAID), object: nil) //POST NOTIFICATION
                    self.SetScreenName(name: F_MEMBERSHIP_FEES, stclass: F_MEMBERSHIP_FEES)
                }
                let orderDetailVC = OrderDetailViewController(nibName: "OrderDetailViewController", bundle: nil)
                orderDetailVC.dictOrderDetail = dictOrderInfo
                orderDetailVC.orderId = dictOrderInfo[RES_orderID] as! String
                orderDetailVC.isOrderDetailFromOrderHistory = false
                orderDetailVC._RECHARGE_TYPE = self._RECHARGE_TYPE
                orderDetailVC.isShowAppReview = true
                orderDetailVC.eventVenue = self.dictEvent.isKeyNull(RES_venue) ? "Not Defined" :self.dictEvent[RES_venue] as! String
                self.navigationController?.pushViewController(orderDetailVC, animated: true)
            }
            else {
                let paymentVC = PaymentViewController(nibName: "PaymentViewController", bundle: nil)
                paymentVC.orderId = dictOrderInfo[RES_orderID] as! String
                paymentVC.dictOrderInfo = dictOrderInfo
                paymentVC._RECHARGE_TYPE = self._RECHARGE_TYPE
                paymentVC.eventVenue = self.dictEvent.isKeyNull(RES_venue) ? "Not Defined" :self.dictEvent[RES_venue] as! String
                self.navigationController?.pushViewController(paymentVC, animated: true)
            }
            self.isUserWalletServiceCalled = true
            
        }, onFailure: { (code, dict) in
            let message: String = dict[RES_message] as! String
            self._KDAlertView.showMessage(message: message, messageType: .WARNING)
            self.isUserWalletServiceCalled = true
           // let _ = self.navigationController?.popViewController(animated: true)
        }) { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return }
    }
    
    
    @IBAction func btnGiveUpCashBackAction() {
        let _giveUpListView = GiveUpListView.init(frame:UIScreen.main.bounds, arrList: self.arrGiveUpList, selectedId: self.selectedGiveupId, isNeverShow: self.isNeverShow , giveUpNote:self.giveUpNote , giveUpTerms:self.giveUpTerms,lblTitle:"",giveUpCategoryId:givupOperatorCategoryId)
        _giveUpListView.delegate = self
        self.view.addSubview(_giveUpListView)
    }
    
    //MARK: CUSTOM METHODS
    
    func showApplyPrmoView() {
        let applyCodeVC = ApplyPromocodeViewController(nibName: "ApplyPromocodeViewController", bundle: nil)
        applyCodeVC.arrCoupon = self.arrCouponList as [typeAliasDictionary]
        applyCodeVC.stCart = _RECHARGE_TYPE == .BUS_BOOKING ?  self.createCartForBusBooking(false)  : self.createCart(false)
        applyCodeVC.stOrderType = self.stOrderType
        applyCodeVC.delegate = self
        self.navigationController?.pushViewController(applyCodeVC, animated: true)
    }
    
    func sendEventTracking(isApplyCoupon:Bool) {
        
        let   SCREEN_NAME = isApplyCoupon ? SCREEN_OFFERANDPROMOCODE : PROCESSTORECHARGE
        let APPLY_COUPON = isApplyCoupon ? APPLYCOUPON : ADDORDER
        
        switch _RECHARGE_TYPE {
        case .MOBILE_RECHARGE:
            self.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_HOME)", action: "\(SCREEN_HOME_MOBILE):\(SCREEN_NAME):", label: "\(APPLY_COUPON):\(self.createCart(isApplyCoupon))", value: nil)
            break
        case .DATA_CARD:
            self.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_HOME)", action: "\(SCREEN_HOME_DATACARD):\(SCREEN_NAME):", label: "\(APPLY_COUPON):\(self.createCart(isApplyCoupon))", value: nil)
            break
        case .DTH_RECHARGE:
            self.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_HOME)", action: "\(SCREEN_HOME_DTH):\(SCREEN_NAME):", label: "\(APPLY_COUPON):\(self.createCart(isApplyCoupon))", value: nil)
            break
        case .GAS_BILL:
            self.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_HOME)", action: "\(SCREEN_HOME_GASBILL):\(SCREEN_NAME):", label: "\(APPLY_COUPON):\(self.createCart(isApplyCoupon))", value: nil)
            break
        case .ELECTRICITY_BILL:
            self.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_HOME)", action: "\(SCREEN_HOME_ELEBILL):\(SCREEN_NAME):", label: "\(APPLY_COUPON):\(self.createCart(isApplyCoupon))", value: nil)
            break
        case .INSURANCE:
            self.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_HOME)", action: "\(SCREEN_HOME_INSURANCE):\(SCREEN_NAME):", label: "\(APPLY_COUPON):\(self.createCart(isApplyCoupon))", value: nil)
            break
        case .LANDLINE_BROABAND:
            self.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_HOME)", action: "\(SCREEN_HOME_LANDLINE_BROADBAND):\(SCREEN_NAME):", label: "\(APPLY_COUPON):\(self.createCart(isApplyCoupon))", value: nil)
            break
        case .BUS_BOOKING:
            self.trackEvent(category: "\(MAIN_CATEGORY):\(SCREEN_HOME)", action: "\(SCREEN_HOME_LANDLINE_BROADBAND):\(SCREEN_NAME):", label: "\(APPLY_COUPON):\(self.createCartForBusBooking(isApplyCoupon)))", value: nil)
            break
        default:
            break
        }
    }
    
    fileprivate func createCartForBusBooking(_ isApplyCoupon: Bool) -> String {
        
        if self.dictCartAfterApplyCoupon.isEmpty {
            
            var arrItems = [typeAliasDictionary]()
            for i in 0..<cart_arrselectedSeats.count {
                let dictSeat = cart_arrselectedSeats[i]
                let dictPass  = cart_arrayPassengerDetail[i]
                
                let dictItem = [CART_REGION_PLAN_ID: cart_DictBoardingPoint[BOARDING_POINT_ID]!,
                                CART_AMOUNT: dictSeat[RES_BaseFare]!,
                                CART_QTY:"1",
                                CART_ITEM_CASHBACK:"0",
                                CART_ITEM_DISCOUNT:"0",
                                CART_SERVICE_TAX:dictSeat[RES_ServiceTax]!,
                                CART_SEAT_NAME:"\(dictSeat[RES_SeatNo]!),\(dictPass[PASSENGER_GENDER]!)",
                    CART_PASSENGER_NAME:dictPass[PASSENGER_NAME]!,
                    CART_SEAT_CATEGORY_ID:dictSeat[RES_SeatCategory]!,
                    CART_SEAT_TYPE:dictSeat[RES_SeatType]!,
                    ]
                arrItems.append(dictItem as typeAliasDictionary)
            }
            
            var dictCart = typeAliasDictionary()
            dictCart[CART_SUB_CATEGORY_ID] = "1" as AnyObject
            dictCart[CART_PLAN_TYPE_ID] = cart_PlanTypeID as AnyObject
            dictCart[CART_U_MOBILE] = cart_MobileNo as AnyObject
            dictCart[REQ_U_EMAIL] = cart_Email as AnyObject
            dictCart[CART_SUB_TOTAL] = cart_subTotal as AnyObject
            dictCart[CART_COUPON_CODE] = cart_CouponCode as AnyObject
            dictCart[CART_COUPON_MSG] = cart_CouponMessage as AnyObject
            dictCart[CART_CASHBACK_AMOUNT] = cart_CashBackAmount as AnyObject
            dictCart[CART_DISCOUNT_AMOUNT] = cart_DiscountAmount as AnyObject
            dictCart[CART_TOTAL_SERVICE_TAX] = String(cart_totalServiceTax) as AnyObject?
            dictCart[CART_TOTAL_PASSENGERS] = String(cart_arrayPassengerDetail.count) as AnyObject?
            dictCart[CART_JOURNEY_DATE] = String(cart_journeyDate) as AnyObject?
            dictCart[CART_EXTRA_1] = cart_Extra1 as AnyObject
            dictCart[CART_EXTRA_2] = cart_Extra2 as AnyObject
            dictCart[CART_WALLET_USED] = usedWallet as AnyObject
            dictCart[CART_OPERATOR_ID] = cart_OperatorId as AnyObject
            dictCart[CART_REGION_ID] = cart_RegionId as AnyObject
            dictCart[CART_CATEGORY_ID] = cart_CategoryId as AnyObject
            dictCart[CART_PAID_AMOUNT] =  "\(self.finalPaidAmount)" as AnyObject
            dictCart[CART_ITEMS] = arrItems as AnyObject
            print("Cart : \(dictCart)")
            return dictCart.convertToJSonString()
        }
            //  else { return dictCartAfterApplyCoupon.convertToJSonString() } //CART_WALLET_USED: usedWallet,
            
        else {
            
            let arrItemRes:[typeAliasStringDictionary] = dictCartAfterApplyCoupon[RES_ITEMS] as! [typeAliasStringDictionary]
            var arrItems: Array<typeAliasDictionary> = [typeAliasDictionary]()
            for i in 0..<arrItemRes.count {
                
                let dictItemRes:typeAliasStringDictionary = arrItemRes[i]
                
                let dictItem = [CART_REGION_PLAN_ID: dictItemRes[RES_REGION_PLAN_ID],
                                CART_AMOUNT: dictItemRes[RES_AMOUNT],
                                CART_QTY:"1",
                                CART_ITEM_CASHBACK:"0",
                                CART_ITEM_DISCOUNT:"0",
                                CART_SERVICE_TAX:dictItemRes[RES_SERVICE_TAX]!,
                                CART_SEAT_NAME:dictItemRes[RES_SEAT_NAME]!,
                                CART_PASSENGER_NAME:dictItemRes[RES_PASSENGER_NAME]!,
                                CART_SEAT_CATEGORY_ID:dictItemRes[RES_SEAT_CATEGORY_ID]!,
                                CART_SEAT_TYPE:dictItemRes[RES_SEAT_TYPE]!,
                                ]
                
                arrItems.append(dictItem as typeAliasDictionary)
            }
            
            var dictCart = typeAliasDictionary()
            
            dictCart[CART_SUB_CATEGORY_ID] = dictCartAfterApplyCoupon[RES_SUB_CATEGORY_ID] as AnyObject
            dictCart[CART_PLAN_TYPE_ID] = dictCartAfterApplyCoupon[RES_PLAN_TYPE_ID]  as AnyObject
            dictCart[CART_U_MOBILE] = dictCartAfterApplyCoupon[RES_U_MOBILE]  as AnyObject
            dictCart[CART_SUB_TOTAL] = dictCartAfterApplyCoupon[RES_SUB_TOTAL]  as AnyObject
            dictCart[CART_COUPON_CODE] = dictCartAfterApplyCoupon[RES_COUPON_CODE]  as AnyObject
            dictCart[CART_COUPON_MSG] = dictCartAfterApplyCoupon[RES_COUPON_MSG]  as AnyObject
            dictCart[CART_CASHBACK_AMOUNT] = dictCartAfterApplyCoupon[RES_CASHBACK_AMOUNT]  as AnyObject
            dictCart[CART_DISCOUNT_AMOUNT] = dictCartAfterApplyCoupon[RES_DISCOUNT_AMOUNT]  as AnyObject
            dictCart[CART_COUPON_ID]  = dictCartAfterApplyCoupon[RES_COUPON_ID]
            dictCart[CART_EXTRA_1] = dictCartAfterApplyCoupon[RES_EXTRA1]  as AnyObject
            dictCart[CART_EXTRA_2] = dictCartAfterApplyCoupon[RES_EXTRA2]  as AnyObject
            dictCart[CART_WALLET_USED] = dictCartAfterApplyCoupon[RES_WALLET_USED]  as AnyObject
            dictCart[CART_OPERATOR_ID] = dictCartAfterApplyCoupon[RES_OPERATOR_ID]  as AnyObject
            dictCart[CART_REGION_ID] = dictCartAfterApplyCoupon[RES_REGION_ID]  as AnyObject
            dictCart[CART_CATEGORY_ID] = dictCartAfterApplyCoupon[RES_CATEGORY_ID]  as AnyObject
            dictCart[CART_PAID_AMOUNT] = dictCartAfterApplyCoupon[RES_PAID_AMOUNT] as AnyObject
            
            dictCart[CART_TOTAL_PASSENGERS] = dictCartAfterApplyCoupon[RES_TOTAL_PASSENGERS] as AnyObject
            dictCart[CART_TOTAL_SERVICE_TAX] = dictCartAfterApplyCoupon[RES_TOTAL_SERVICE_TAX] as AnyObject
            dictCart[CART_JOURNEY_DATE] = dictCartAfterApplyCoupon[RES_JOURNEY_DATE] as AnyObject
            dictCart[REQ_U_EMAIL] = dictCartAfterApplyCoupon[RES_U_EMAIL] as AnyObject
            dictCart[CART_ITEMS] = arrItems as AnyObject
            
            print("Cart : \(dictCart)")
            return dictCart.convertToJSonString()
        }
    }
    
    fileprivate func createCart(_ isApplyCoupon: Bool) -> String {
        
        //FLIGHT CART
        
        if self._RECHARGE_TYPE == .FLIGHT_BOOKING {
            
            dicFareDetails.removeValue(forKey: "operatorList")
        
            if self.dictCartAfterApplyCoupon.isEmpty {
                
                var arrItems = [typeAliasDictionary]()
                
                for i in 0..<arrTravellerList.count {
                    
                    let dictPass = arrTravellerList[i]
                    var dictItem = typeAliasDictionary()
                    dictItem[CART_REGION_PLAN_ID] = (dictPass[TRAVELLER_FF_NO]! == "" ? "0" : "\(dictPass[TRAVELLER_FF_AIRLINE_CODE]!) \(dictPass[TRAVELLER_FF_NO]!))") as AnyObject
                    dictItem[CART_AMOUNT] = "0" as AnyObject
                    dictItem[CART_QTY] = dictPass[TRAVELLER_SEQ_NO]! as AnyObject
                    dictItem[CART_AMOUNT] = "0" as AnyObject
                    dictItem[CART_ITEM_CASHBACK] = "0" as AnyObject
                    dictItem[CART_ITEM_DISCOUNT] = "0" as AnyObject
                    dictItem[CART_SEAT_TYPE] = dictPass[TRAVELLER_DOB]! as AnyObject
                    dictItem[CART_PASSENGER_NAME] = dictPass[TRAVELLER_F_NAME]! as AnyObject
                    dictItem[CART_PASSENGER_TITLE] = dictPass[TRAVELLER_TITLE_CODE]! as AnyObject
                    dictItem[CART_SEAT_CATEGORY_ID] = dictPass[TRAVELLER_CATEGORY_ID]! as AnyObject
                    dictItem[CART_SEAT_NAME] = dictPass[TRAVELLER_L_NAME]! as AnyObject
                    if dictPass[TRAVELLER_M_NAME] != "" && dictPass[TRAVELLER_M_NAME] != "0" {
                        dictItem[CART_SEAT_NAME] = "\(dictPass[TRAVELLER_M_NAME]!) \(dictPass[TRAVELLER_L_NAME]!)" as AnyObject
                    }
                    else { dictItem[CART_SEAT_NAME] = dictPass[TRAVELLER_L_NAME]! as AnyObject             }
                    dictItem[CART_PASSPORT_NO] = (dictPass[TRAVELLER_PASSPORT_NO]! == "" ? "0" : dictPass[TRAVELLER_PASSPORT_NO]!) as AnyObject
                    dictItem[CART_PASSPORT_ISSUE_COUNTRY] = (dictPass[TRAVELLER_PASSPORT_COUNTRY_CODE]! == "" ? "0" : dictPass[TRAVELLER_PASSPORT_COUNTRY_CODE]!) as AnyObject
                    dictItem[CART_PASSPORT_EXP_DATE] = (dictPass[TRAVELLER_PASSPORT_EXPIRE_DATE]! == "" ? "0" : dictPass[TRAVELLER_PASSPORT_EXPIRE_DATE]!) as AnyObject
                    dictItem[CART_NATIONALITY] = (dictPass[TRAVELLER_NATIONALITY_CODE]! == "" ? "0" : dictPass[TRAVELLER_NATIONALITY_CODE]!) as AnyObject
                    dictItem[CART_SERVICE_TAX] = "0" as AnyObject
                    dictItem[CART_VISA_TYPE] = (dictPass[TRAVELLER_VISA_TYPE]! == "" ? "0" : dictPass[TRAVELLER_VISA_TYPE]!) as AnyObject
                   arrItems.append(dictItem as typeAliasDictionary)
                }
                
                var dictCart = typeAliasDictionary()
                dictCart[CART_SUB_CATEGORY_ID] = cart_SubCategory as AnyObject
                dictCart[CART_PLAN_TYPE_ID] = cart_PlanTypeID as AnyObject
                dictCart[CART_U_MOBILE] = cart_MobileNo as AnyObject
                dictCart[CART_PHONE] = primaryMobileNo as AnyObject
                dictCart[REQ_U_EMAIL] = cart_Email as AnyObject
                dictCart[CART_SUB_TOTAL] = cart_subTotal as AnyObject
                dictCart[CART_COUPON_CODE] = cart_CouponCode as AnyObject
                dictCart[CART_COUPON_MSG] = cart_CouponMessage as AnyObject
                dictCart[CART_CASHBACK_AMOUNT] = cart_CashBackAmount as AnyObject
                dictCart[CART_DISCOUNT_AMOUNT] = cart_DiscountAmount as AnyObject
                dictCart[CART_TOTAL_SERVICE_TAX] = String(cart_totalServiceTax) as AnyObject?
                dictCart[CART_TOTAL_PASSENGERS] = cart_totalPassengers as AnyObject?
                dictCart[CART_EXTRA_1] = cart_Extra1 as AnyObject
                dictCart[CART_EXTRA_2] = dicFareDetails.convertToJSonString() as AnyObject
                dictCart[CART_WALLET_USED] = usedWallet as AnyObject
                dictCart[CART_OPERATOR_ID] = cart_OperatorId as AnyObject
                dictCart[CART_REGION_ID] = cart_RegionId as AnyObject
                dictCart[CART_CATEGORY_ID] = cart_CategoryId as AnyObject
                dictCart[CART_PAID_AMOUNT] =  "\(self.finalPaidAmount)" as AnyObject
                dictCart[CART_CONVENIENCE_FEE] = flightConvinienceFees as AnyObject
                dictCart[CART_IS_INTERNATIONAL] = self.isInternational as AnyObject?
                dictCart[CART_PASSENGER_ADDRESS] = self.passengerAddress as AnyObject?
                dictCart[CART_ITEMS] = arrItems as AnyObject
                print("Cart : \(dictCart)")
                return dictCart.convertToJSonString()
            }
               
            else {
                
                let arrItemRes:[typeAliasDictionary] = dictCartAfterApplyCoupon[RES_ITEMS] as! [typeAliasDictionary]
                var arrItems: Array<typeAliasDictionary> = [typeAliasDictionary]()
                for i in 0..<arrItemRes.count {
                    
                    let dictItemRes:typeAliasDictionary = arrItemRes[i]
                    
                    let dictItem = [CART_REGION_PLAN_ID: dictItemRes[RES_REGION_PLAN_ID]!,
                                    CART_AMOUNT: dictItemRes[RES_AMOUNT]!,
                                    CART_QTY:dictItemRes[RES_QTY]!,
                                    CART_ITEM_CASHBACK:"0",
                                    CART_ITEM_DISCOUNT:"0",
                                    CART_SEAT_TYPE:dictItemRes[RES_SEAT_TYPE]!,
                                    CART_PASSENGER_NAME:dictItemRes[RES_PASSENGER_NAME]!,
                                    CART_PASSENGER_TITLE:dictItemRes[RES_PASSENGER_TITLE]!,
                                    CART_SEAT_CATEGORY_ID:dictItemRes[RES_SEAT_CATEGORY_ID]!,
                                    CART_SEAT_NAME:dictItemRes[RES_SEAT_NAME]!,
                                    CART_PASSPORT_NO:dictItemRes[RES_PASSPORT_NO]! as! String == "" ? "0" : dictItemRes[RES_PASSPORT_NO]!,
                                    CART_PASSPORT_ISSUE_COUNTRY:dictItemRes[RES_PASSPORT_ISSUE_COUNTRY]! as! String as! String == "" ? "0" : dictItemRes[RES_PASSPORT_ISSUE_COUNTRY]!,
                                    CART_PASSPORT_EXP_DATE:dictItemRes[RES_PASSPORT_EXP_DATE]! as! String == "" ? "0" : dictItemRes[RES_PASSPORT_EXP_DATE]!,
                                    CART_NATIONALITY:dictItemRes[RES_NATIONALITY]! as! String == "" ? "0" : dictItemRes[RES_NATIONALITY]!,
                                    CART_SERVICE_TAX:"0",
                                    CART_VISA_TYPE:dictItemRes[RES_VISA_TYPE]! as! String == "" ? "0" : dictItemRes[RES_VISA_TYPE]!,
                                    
                                    ] as [String : Any]
                  arrItems.append(dictItem as typeAliasDictionary)
                }
                
                var dictCart = typeAliasDictionary()
                
                dictCart[CART_SUB_CATEGORY_ID] = dictCartAfterApplyCoupon[RES_SUB_CATEGORY_ID] as AnyObject
                dictCart[CART_PLAN_TYPE_ID] = dictCartAfterApplyCoupon[RES_PLAN_TYPE_ID]  as AnyObject
                dictCart[CART_U_MOBILE] = dictCartAfterApplyCoupon[RES_U_MOBILE]  as AnyObject
                dictCart[CART_SUB_TOTAL] = dictCartAfterApplyCoupon[RES_SUB_TOTAL]  as AnyObject
                dictCart[CART_COUPON_CODE] = dictCartAfterApplyCoupon[RES_COUPON_CODE]  as AnyObject
                dictCart[CART_COUPON_MSG] = dictCartAfterApplyCoupon[RES_COUPON_MSG]  as AnyObject
                dictCart[CART_CASHBACK_AMOUNT] = dictCartAfterApplyCoupon[RES_CASHBACK_AMOUNT]  as AnyObject
                dictCart[CART_DISCOUNT_AMOUNT] = dictCartAfterApplyCoupon[RES_DISCOUNT_AMOUNT]  as AnyObject
                dictCart[CART_COUPON_ID]  = dictCartAfterApplyCoupon[RES_COUPON_ID]
                dictCart[CART_EXTRA_1] = dictCartAfterApplyCoupon[RES_EXTRA1]  as AnyObject
                dictCart[CART_EXTRA_2] = dictCartAfterApplyCoupon[RES_EXTRA2]  as AnyObject
                dictCart[CART_WALLET_USED] = usedWallet  as AnyObject
                dictCart[CART_OPERATOR_ID] = dictCartAfterApplyCoupon[RES_OPERATOR_ID]  as AnyObject
                dictCart[CART_REGION_ID] = dictCartAfterApplyCoupon[RES_REGION_ID]  as AnyObject
                dictCart[CART_CATEGORY_ID] = dictCartAfterApplyCoupon[RES_CATEGORY_ID]  as AnyObject
                dictCart[CART_PAID_AMOUNT] = self.finalPaidAmount as AnyObject
                dictCart[CART_PHONE] = dictCartAfterApplyCoupon[RES_PHONE] as AnyObject
                dictCart[CART_CONVENIENCE_FEE] = dictCartAfterApplyCoupon[RES_CONVENIENCE_FEE] as AnyObject
                dictCart[CART_TOTAL_PASSENGERS] = dictCartAfterApplyCoupon[RES_TOTAL_PASSENGERS] as AnyObject
                dictCart[CART_TOTAL_SERVICE_TAX] = dictCartAfterApplyCoupon[RES_TOTAL_SERVICE_TAX] as AnyObject
                dictCart[CART_IS_INTERNATIONAL] = dictCartAfterApplyCoupon[RES_IS_INTERNATIONAL] as AnyObject
                dictCart[CART_PASSENGER_ADDRESS] = dictCartAfterApplyCoupon[RES_PASSENGER_ADDRESS] as AnyObject
               // dictCart[CART_JOURNEY_DATE] = dictCartAfterApplyCoupon[RES_JOURNEY_DATE] as AnyObject
                dictCart[REQ_U_EMAIL] = dictCartAfterApplyCoupon[RES_U_EMAIL] as AnyObject
                dictCart[CART_ITEMS] = arrItems as AnyObject
                
                print("Cart : \(dictCart)")
                return dictCart.convertToJSonString()
            }

        }
        
        //EVENT CART
        
        else if self._RECHARGE_TYPE == .EVENT {
            
            if self.dictCartAfterApplyCoupon.isEmpty {
                
                var arrItems = [typeAliasDictionary]()
                
                for i in 0..<cart_arrPassData.count {
                    
                    let dictPass = cart_arrPassData[i]
                    if Int(dictPass[KEY_QUANTITY] as! String)! > 0 {
                        
                        var dictItem = typeAliasDictionary()
                        dictItem[CART_REGION_PLAN_ID] = dictPass[RES_eventScheduleID]!
                        dictItem[CART_AMOUNT] = dictPass[RES_price]!
                        dictItem[CART_QTY] = dictPass[KEY_QUANTITY]!
                        dictItem[CART_ITEM_CASHBACK] = "0" as AnyObject
                        dictItem[CART_ITEM_DISCOUNT] = "0" as AnyObject
                        dictItem[CART_SERVICE_TAX] = dictPass[RES_convenienceAmt]!
                        dictItem[CART_PASSENGER_NAME] = cart_passengerName as AnyObject
                        dictItem[CART_SEAT_CATEGORY_ID] = dictPass[RES_packageID]!
                        dictItem[CART_TICKET_DATE] = dictPass[RES_date]!
                        arrItems.append(dictItem as typeAliasDictionary)
                    }
                }
                
                var dictCart = typeAliasDictionary()
                dictCart[CART_SUB_CATEGORY_ID] = "0" as AnyObject
                dictCart[CART_PLAN_TYPE_ID] = cart_PlanTypeID as AnyObject
                dictCart[CART_U_MOBILE] = cart_MobileNo as AnyObject
                dictCart[CART_PHONE] = cart_MobileNo as AnyObject
                dictCart[REQ_U_EMAIL] = cart_Email as AnyObject
                dictCart[CART_SUB_TOTAL] = cart_subTotal as AnyObject
                dictCart[CART_COUPON_CODE] = cart_CouponCode as AnyObject
                dictCart[CART_COUPON_MSG] = cart_CouponMessage as AnyObject
                dictCart[CART_CASHBACK_AMOUNT] = cart_CashBackAmount as AnyObject
                dictCart[CART_DISCOUNT_AMOUNT] = cart_DiscountAmount as AnyObject
                dictCart[CART_TOTAL_SERVICE_TAX] = String(cart_totalServiceTax) as AnyObject?
                dictCart[CART_TOTAL_PASSENGERS] = "1" as AnyObject?
                dictCart[CART_EXTRA_1] = cart_Extra1 as AnyObject
                dictCart[CART_EXTRA_2] = cart_Extra2 as AnyObject
                dictCart[CART_WALLET_USED] = usedWallet as AnyObject
                dictCart[CART_OPERATOR_ID] = cart_OperatorId as AnyObject
                dictCart[CART_REGION_ID] = cart_RegionId as AnyObject
                dictCart[CART_CATEGORY_ID] = cart_CategoryId as AnyObject
                dictCart[CART_PAID_AMOUNT] =  "\(self.finalPaidAmount)" as AnyObject
                dictCart[CART_ITEMS] = arrItems as AnyObject
                return dictCart.convertToJSonString()
            }
                
            else {
                
                let arrItemRes:[typeAliasDictionary] = dictCartAfterApplyCoupon[RES_ITEMS] as! [typeAliasDictionary]
                var arrItems: Array<typeAliasDictionary> = [typeAliasDictionary]()
                for i in 0..<arrItemRes.count {
                    
                    let dictItemRes:typeAliasDictionary = arrItemRes[i] as! typeAliasDictionary
                    var dictItem = typeAliasDictionary()
                    dictItem[CART_REGION_PLAN_ID] = dictItemRes[RES_REGION_PLAN_ID] as AnyObject
                    dictItem[CART_AMOUNT] = dictItemRes[RES_AMOUNT] as AnyObject
                    dictItem[CART_QTY] = dictItemRes[RES_QTY] as AnyObject
                    dictItem[CART_ITEM_CASHBACK] = "0" as AnyObject
                    dictItem[CART_ITEM_DISCOUNT] = "0" as AnyObject
                    dictItem[CART_SERVICE_TAX] = dictItemRes[RES_SERVICE_TAX]! as AnyObject
                    dictItem[CART_PASSENGER_NAME] = dictItemRes[RES_PASSENGER_NAME]! as AnyObject
                    dictItem[CART_SEAT_CATEGORY_ID] = dictItemRes[RES_SEAT_CATEGORY_ID]! as AnyObject
                    dictItem[CART_TICKET_DATE] = dictItemRes[RES_TICKET_DATE]! as AnyObject
                    arrItems.append(dictItem as typeAliasDictionary)
                }
                
                var dictCart = typeAliasDictionary()
                
                dictCart[CART_SUB_CATEGORY_ID] = dictCartAfterApplyCoupon[RES_SUB_CATEGORY_ID] as AnyObject
                dictCart[CART_PLAN_TYPE_ID] = dictCartAfterApplyCoupon[RES_PLAN_TYPE_ID]  as AnyObject
                dictCart[CART_U_MOBILE] = dictCartAfterApplyCoupon[RES_U_MOBILE]  as AnyObject
                dictCart[CART_SUB_TOTAL] = dictCartAfterApplyCoupon[RES_SUB_TOTAL]  as AnyObject
                dictCart[CART_COUPON_CODE] = dictCartAfterApplyCoupon[RES_COUPON_CODE]  as AnyObject
                dictCart[CART_COUPON_MSG] = dictCartAfterApplyCoupon[RES_COUPON_MSG]  as AnyObject
                dictCart[CART_CASHBACK_AMOUNT] = dictCartAfterApplyCoupon[RES_CASHBACK_AMOUNT]  as AnyObject
                dictCart[CART_DISCOUNT_AMOUNT] = dictCartAfterApplyCoupon[RES_DISCOUNT_AMOUNT]  as AnyObject
                dictCart[CART_COUPON_ID]  = dictCartAfterApplyCoupon[RES_COUPON_ID]
                dictCart[CART_EXTRA_1] = dictCartAfterApplyCoupon[RES_EXTRA1]  as AnyObject
                dictCart[CART_EXTRA_2] = dictCartAfterApplyCoupon[RES_EXTRA2]  as AnyObject
                dictCart[CART_WALLET_USED] = usedWallet  as AnyObject
                dictCart[CART_OPERATOR_ID] = dictCartAfterApplyCoupon[RES_OPERATOR_ID]  as AnyObject
                dictCart[CART_REGION_ID] = dictCartAfterApplyCoupon[RES_REGION_ID]  as AnyObject
                dictCart[CART_CATEGORY_ID] = dictCartAfterApplyCoupon[RES_CATEGORY_ID]  as AnyObject
                dictCart[CART_PAID_AMOUNT] = self.finalPaidAmount as AnyObject
                
                dictCart[CART_TOTAL_PASSENGERS] = dictCartAfterApplyCoupon[RES_TOTAL_PASSENGERS] as AnyObject
                dictCart[CART_TOTAL_SERVICE_TAX] = dictCartAfterApplyCoupon[RES_TOTAL_SERVICE_TAX] as AnyObject
                dictCart[REQ_U_EMAIL] = dictCartAfterApplyCoupon[RES_U_EMAIL] as AnyObject
                dictCart[CART_ITEMS] = arrItems as AnyObject
                return dictCart.convertToJSonString()
            }
            
        }

            
        else {  //SIMPLE CART
        
            if self.dictCartAfterApplyCoupon.isEmpty {
                let dictItem = [CART_REGION_PLAN_ID: cart_RegionPlanId,
                                CART_AMOUNT: cart_PlanValue,
                                CART_QTY:"1",
                                CART_ITEM_CASHBACK:"0",
                                CART_ITEM_DISCOUNT:"0"]
                let arrItems: Array<typeAliasDictionary> = [dictItem as typeAliasDictionary]
                var dictCart = typeAliasDictionary()
                dictCart[CART_SUB_CATEGORY_ID] = cart_PrepaidPostpaid as AnyObject
                dictCart[CART_PLAN_TYPE_ID] = cart_PlanTypeID as AnyObject
                dictCart[CART_U_MOBILE] = cart_MobileNo as AnyObject
                dictCart[CART_SUB_TOTAL] = cart_TotalAmount as AnyObject
                dictCart[CART_COUPON_CODE] = cart_CouponCode as AnyObject
                dictCart[CART_COUPON_MSG] = cart_CouponMessage as AnyObject
                dictCart[CART_CASHBACK_AMOUNT] = cart_CashBackAmount as AnyObject
                dictCart[CART_DISCOUNT_AMOUNT] = cart_DiscountAmount as AnyObject
                dictCart[CART_EXTRA_1] = cart_Extra1 as AnyObject
                dictCart[CART_EXTRA_2] = cart_Extra2 as AnyObject
                dictCart[CART_WALLET_USED] = usedWallet as AnyObject
                dictCart[CART_OPERATOR_ID] = cart_OperatorId as AnyObject
                dictCart[CART_REGION_ID] = cart_RegionId as AnyObject
                dictCart[CART_CATEGORY_ID] = cart_CategoryId as AnyObject
                dictCart[CART_PAID_AMOUNT] =  "\(self.finalPaidAmount)" as AnyObject
                dictCart[CART_ITEMS] = arrItems as AnyObject
                print("Cart : \(dictCart)")
                return dictCart.convertToJSonString()
            }
            else {
                
                let arrItemRes:[typeAliasDictionary] = dictCartAfterApplyCoupon[RES_ITEMS] as! [typeAliasDictionary]
                var arrItems: Array<typeAliasDictionary> = [typeAliasDictionary]()
                for i in 0..<arrItemRes.count {
                    let dictItemRes:typeAliasDictionary = arrItemRes[i]
                    
                    let dictItem = [CART_REGION_PLAN_ID: dictItemRes[RES_REGION_PLAN_ID] as! String,
                                    CART_AMOUNT: dictItemRes[RES_AMOUNT] as! String,
                                    CART_QTY:"1",
                                    CART_ITEM_CASHBACK:"0",
                                    CART_ITEM_DISCOUNT:"0"] as [String : Any]
                    arrItems.append(dictItem as typeAliasDictionary)
                }
                
                var dictCart = typeAliasDictionary()
                
                dictCart[CART_SUB_CATEGORY_ID] = dictCartAfterApplyCoupon[RES_SUB_CATEGORY_ID] as AnyObject
                dictCart[CART_PLAN_TYPE_ID] = dictCartAfterApplyCoupon[RES_PLAN_TYPE_ID]  as AnyObject
                dictCart[CART_U_MOBILE] = dictCartAfterApplyCoupon[RES_U_MOBILE]  as AnyObject
                dictCart[CART_SUB_TOTAL] = dictCartAfterApplyCoupon[RES_SUB_TOTAL]  as AnyObject
                dictCart[CART_COUPON_CODE] = dictCartAfterApplyCoupon[RES_COUPON_CODE]  as AnyObject
                dictCart[CART_COUPON_MSG] = dictCartAfterApplyCoupon[RES_COUPON_MSG]  as AnyObject
                dictCart[CART_CASHBACK_AMOUNT] = dictCartAfterApplyCoupon[RES_CASHBACK_AMOUNT]  as AnyObject
                dictCart[CART_DISCOUNT_AMOUNT] = dictCartAfterApplyCoupon[RES_DISCOUNT_AMOUNT]  as AnyObject
                dictCart[CART_COUPON_ID]  = dictCartAfterApplyCoupon[RES_COUPON_ID]
                dictCart[CART_EXTRA_1] = dictCartAfterApplyCoupon[RES_EXTRA1]  as AnyObject
                dictCart[CART_EXTRA_2] = dictCartAfterApplyCoupon[RES_EXTRA2]  as AnyObject
                dictCart[CART_WALLET_USED] = usedWallet  as AnyObject
                dictCart[CART_OPERATOR_ID] = dictCartAfterApplyCoupon[RES_OPERATOR_ID]  as AnyObject
                dictCart[CART_REGION_ID] = dictCartAfterApplyCoupon[RES_REGION_ID]  as AnyObject
                dictCart[CART_CATEGORY_ID] = dictCartAfterApplyCoupon[RES_CATEGORY_ID]  as AnyObject
                dictCart[CART_PAID_AMOUNT] = self.finalPaidAmount as AnyObject
                dictCart[CART_ITEMS] = arrItems as AnyObject
                return dictCart.convertToJSonString()
            }
        }
    }
    
    fileprivate func showCommisionLevel() {
        txtPromocode_PromoCode.resignFirstResponder()
        _ = CommissionGraph.init(arrData: arrCommissionLevel)
    }

    fileprivate func calculatePaidAmount() {
        
       finalPaidAmount = Double(cart_TotalAmount)! - (Double(cart_DiscountAmount)! + Double(usedWallet))
       let stFinalAmt = self.finalPaidAmount == 0 ? "" : "\(RUPEES_SYMBOL) \(String.init(format: "%.2f", self.finalPaidAmount))"
        self.btnProcessToPay.setTitle("Proceed To Pay \(stFinalAmt)", for: .normal)
    }
    
    //MARK: APPLY PROMOCODE DELEGATE
    
    func ApplyPromoCodeView_btnApplyAction(dict:typeAliasDictionary) {
        
        let _:String = dict[RES_message] as! String
        self.dictCartAfterApplyCoupon = dict[RES_coupon_cart] as! typeAliasDictionary
        
        self.cart_CouponMessage = self.dictCartAfterApplyCoupon[RES_COUPON_MSG] as! String
        self.lblPromocode_PromocodeCodeInfo.text = self.cart_CouponMessage
        let height = self.lblPromocode_PromocodeCodeInfo.text?.textHeight(self.lblPromocode_PromocodeCodeInfo.frame.width, textFont: self.lblPromocode_PromocodeCodeInfo.font)
        self.constraintPromcode_lblPromocodeInfoHeight.constant = height!
        self.lblPromocode_PromocodeCodeInfo.isHidden = false
        self.viewPromoCodeInfoBG.isHidden = false
        self.viewPromoCodeInfoBG.layoutIfNeeded()
        self.viewPromoCodeInfoBG.layer.cornerRadius =  self.viewPromoCodeInfoBG.frame.height/2
        self.viewPromocode_ApplyPromocodeBG.isHidden = true
        self.viewPromoCodeDetail.isHidden = false
        self.viewPromoCodeInfoBG.layoutIfNeeded()
        self.lblPromoCode_CouponName.text = self.dictCartAfterApplyCoupon[RES_COUPON_CODE] as? String
        self.cart_DiscountAmount = self.dictCartAfterApplyCoupon[RES_DISCOUNT_AMOUNT] as! String
        self.finalPaidAmount = (Double(self.dictCartAfterApplyCoupon[RES_PAID_AMOUNT] as! String))!
        
        if _RECHARGE_TYPE != .ADD_MONEY && _RECHARGE_TYPE != .DONATE_MONEY  {
         self.constraintoPromocode_ViewApplyPromocodeHeight.constant = 1
         constraintPromoCode_ViewPromoCodeTopTobtnCommissionLevel.priority = PRIORITY_HIGH
         constraintViewPromocodeRechargeInfoTopToSuper.priority = PRIORITY_LOW
         constraintViewPromocodeRechargeInfoTopToViewApplyPromoCode.priority = PRIORITY_LOW
        }
        else {
            self.constraintoPromocode_ViewApplyPromocodeHeight.constant = 1
            constraintPromoCode_ViewPromoCodeTopTobtnCommissionLevel.priority = PRIORITY_LOW
            constraintViewPromocodeRechargeInfoTopToSuper.priority = PRIORITY_HIGH
            constraintViewPromocodeRechargeInfoTopToViewApplyPromoCode.priority = PRIORITY_LOW
            constraintViewWalletBottomToSuper.priority = PRIORITY_LOW
            constraintViewPromocodeBottomToSuper.priority = PRIORITY_HIGH
        }
        self.viewPromocode.layoutIfNeeded()
        self.viewWallet.layoutIfNeeded()
        let stFinalAmt = self.finalPaidAmount == 0 ? "" : "\(RUPEES_SYMBOL) \(String.init(format: "%.2f", self.finalPaidAmount))"
        self.btnProcessToPay.setTitle("Proceed To Pay \(stFinalAmt)", for: .normal)
        print("Cart : Coupon : \(self.dictCartAfterApplyCoupon)")
    }
    
    //MARK: TEXTFIELD DELEGATE
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtPromocode_PromoCode {
            if !self.arrCouponList.isEmpty{ self.showApplyPrmoView() ; return false}
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtPromocode_PromoCode.resignFirstResponder()
        return true
    }
    
    //MARK: GIVE UP LIST VIEW DELEGATE
    
    func GiveUpListView_SelectedData(id: String, isNeverShow: Bool) {
        self.selectedGiveupId = id
        self.isNeverShow = isNeverShow
        if self.selectedGiveupId != "" && self.selectedGiveupId != "0" {
            btnGiveUpCashBack.backgroundColor = COLOUR_DARK_GREEN
            btnGiveUpCashBack.isSelected = true
        }
        else{
            btnGiveUpCashBack.backgroundColor = COLOUR_LIGHT_GRAY
            btnGiveUpCashBack.isSelected = false
        }
    }
    
    
}
