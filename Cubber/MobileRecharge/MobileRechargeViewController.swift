//
//  MobileRechargeViewController.swift
//  Cubber
//
//  Created by dnk on 29/08/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit
import ContactsUI

class MobileRechargeViewController: UIViewController, UITextFieldDelegate , UIScrollViewDelegate , UITableViewDelegate,UITableViewDataSource , OperatorViewDelegate , CNContactPickerDelegate , AppNavigationControllerDelegate  {
   
    //MARK:PROPERTIES

    @IBOutlet var scrollViewBG: UIScrollView!
    @IBOutlet var txtMobileNo: UITextField!
    @IBOutlet var txtOperator: UITextField!
    @IBOutlet var txtAmont: UITextField!
    @IBOutlet var btnPrepaid: UIButton!
    @IBOutlet var btnPostpaid: UIButton!
    @IBOutlet var btnTalktimeTopup: UIButton!
    @IBOutlet var btnSpecialRecharge: UIButton!
    @IBOutlet var btnBrowsePlan: UIButton!
    @IBOutlet var viewPrePostpaid: UIView!
    @IBOutlet var viewNote: UIView!
    @IBOutlet var viewTopupSpecial: UIView!
    @IBOutlet var lblRemark: UILabel!
    
    @IBOutlet var tableViewRecentList: UITableView!
    @IBOutlet var constraintBtnProcessTopToViewTalktimeRechargeview: NSLayoutConstraint!
    @IBOutlet var constraintBtnProcessTopToViewAmount: NSLayoutConstraint!
    @IBOutlet var constraintBtnProcessTopToViewRemark: NSLayoutConstraint!
    @IBOutlet var constraintTableViewRecentListHeight: NSLayoutConstraint!
    
    @IBOutlet var constraintViewBtnProceesBottomToSuper: NSLayoutConstraint!
    
    @IBOutlet var constraintViewRecentListBottomToSuper: NSLayoutConstraint!
    
    @IBOutlet var viewRecentList: UIView!
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var _KDAlertView = KDAlertView()
    fileprivate var dictMobileRecharge_SelectedOperator = typeAliasDictionary()
    fileprivate var dictMobileRecharge_SelectedRegion = typeAliasDictionary()
    fileprivate var dictMobileRecharge_SelectedPlan = typeAliasDictionary()
    fileprivate var arrLatestOrders:[typeAliasDictionary] = [typeAliasDictionary]()
    fileprivate var isOrderData:Bool = false
    fileprivate var dateFormat:DateFormatter = DateFormatter()
    var dictOpertaorCategory:typeAliasDictionary!
    fileprivate var isBrowsePlan:Bool = false
    internal var isFillOrder :Bool = false
    internal var dictFillOrder = typeAliasDictionary()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnTalktimeTopup.setImage(UIImage.init(named: "icon_radiouncheck"), for: UIControlState.normal)
        btnSpecialRecharge.setImage(UIImage.init(named: "icon_radiocheck"), for: UIControlState.selected)
        btnTalktimeTopup.setImage(UIImage.init(named: "icon_radiocheck"), for: UIControlState.selected)
        btnSpecialRecharge.setImage(UIImage.init(named: "icon_radiouncheck"), for: UIControlState.normal)

        btnPrepaid.isSelected = true
        btnPrepaid.backgroundColor = COLOUR_ORANGE
        btnTalktimeTopup.isSelected = false
        btnSpecialRecharge.isSelected = false
        viewTopupSpecial.isHidden = false
        viewNote.isHidden = true
        lblRemark.text = dictOpertaorCategory[RES_remark] as! String == "0" ? "" : dictOpertaorCategory[RES_remark] as! String 
        tableViewRecentList.register(UINib.init(nibName: CELL_IDENTIFIER_RECENTLIST_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_RECENTLIST_CELL)
        tableViewRecentList.rowHeight = HEIGHT_RECENTLIST_CELL
        self.callGetLatestOrdersService()
        self.constraintViewBtnProceesBottomToSuper.priority = PRIORITY_HIGH
        self.constraintViewRecentListBottomToSuper.priority = PRIORITY_LOW
        self.viewRecentList.isHidden = true
         NotificationCenter.default.addObserver(self, selector: #selector(onPlanSelection), name: NSNotification.Name(rawValue: NOTIFICATION_PLAN_VIEW_SELECTION), object: nil)
        txtAmont.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewPrePostpaid.setViewBorder(COLOUR_LIGHT_GRAY, borderWidth: 1, isShadow: false, cornerRadius: 20, backColor: UIColor.white)
        btnBrowsePlan.setViewBorder(COLOUR_DARK_GREEN, borderWidth: 1, isShadow: false, cornerRadius: btnBrowsePlan.frame.height/2, backColor: UIColor.clear)
        if isFillOrder && !dictFillOrder.isEmpty {
            self.fillOrderFromSlider()
        }
        self.SetScreenName(name: F_MODULE_MOBILE, stclass: F_MODULE_MOBILE)
        self.sendScreenView(name: F_MODULE_MOBILE)
        self.registerForKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    
    func setNavigationBar() {
        obj_AppDelegate.navigationController.setCustomTitle("\(dictOpertaorCategory[RES_operatorCategoryName] as! String)")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPrePostpaidAction(_ sender: UIButton) {
        if sender.tag == 0 {
            btnPrepaid.isSelected = true
            btnPostpaid.isSelected = false
            btnPrepaid.backgroundColor = COLOUR_ORANGE
            btnPrepaid.setTitleColor(UIColor.white, for: .normal)
            btnPostpaid.backgroundColor = UIColor.white
            btnPostpaid.setTitleColor(UIColor.black, for: .normal)
            viewTopupSpecial.isHidden = false
            viewNote.isHidden = true
            constraintBtnProcessTopToViewTalktimeRechargeview.priority = PRIORITY_LOW
            constraintBtnProcessTopToViewRemark.priority = PRIORITY_LOW
            constraintBtnProcessTopToViewAmount.priority = PRIORITY_HIGH
        }
        else{
            viewNote.isHidden = false
            btnPrepaid.isSelected = false
            btnPostpaid.isSelected = true
            btnPostpaid.backgroundColor = COLOUR_ORANGE
            btnPostpaid.setTitleColor(UIColor.white, for: .normal)
            btnPrepaid.backgroundColor = UIColor.white
            btnPrepaid.setTitleColor(UIColor.black, for: .normal)
            viewTopupSpecial.isHidden = true
            viewNote.isHidden = false
            
            constraintBtnProcessTopToViewTalktimeRechargeview.priority = PRIORITY_LOW
            constraintBtnProcessTopToViewRemark.priority = PRIORITY_HIGH
            constraintBtnProcessTopToViewAmount.priority = PRIORITY_LOW
        }
         btnBrowsePlan.isHidden =  sender == btnPrepaid ? false : true
        
        if !isOrderData {
            isOrderData = false
            dictMobileRecharge_SelectedPlan = typeAliasDictionary()
            txtAmont.text = ""
            self.setMobileRecharge_TopUpAndSpecialRechargeView()
        }
        self.view.layoutIfNeeded()
    }
    
    @IBAction func btnTalktimeSpecialAction(_ sender: UIButton) {
        
        if sender.tag == 0 {
            btnTalktimeTopup.isSelected = true
            btnSpecialRecharge.isSelected = false
        }
        else{
            btnTalktimeTopup.isSelected = false
            btnSpecialRecharge.isSelected = true
           
        }
    }
    
    @IBAction func btnOperatorCircleAction() {
        self.hideKeyboard()
        let operatorView:OperatorView = OperatorView.init(frame: UIScreen.main.bounds, categoryID: "1")
        operatorView.delegate = self
       
    }
    
    @IBAction func btnContactAddressAction() {
        let peoplePicker = CNContactPickerViewController()
        peoplePicker.delegate = self
        peoplePicker.displayedPropertyKeys = [CNContactGivenNameKey,CNContactPhoneNumbersKey]
        self.present(peoplePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnProcessAction() {

        self.hideKeyboard()
        let stMobileNo: String = txtMobileNo.text!.trim()
        let stAmount: String = txtAmont.text!.trim()
        
        if stMobileNo.characters.isEmpty {
            _KDAlertView.showMessage(message: MSG_TXT_MOBILE_NO, messageType: .WARNING)
             return; }
            
        else if !DataModel.validateMobileNo(stMobileNo) {
            _KDAlertView.showMessage(message: MSG_TXT_MOBILE_NO_VALID, messageType: .WARNING); return; }
        
        if self.dictMobileRecharge_SelectedOperator.isEmpty {
            _KDAlertView.showMessage(message: MSG_SEL_OPERATOR, messageType: .WARNING)
           return; }
        
        if stAmount.characters.isEmpty {
            _KDAlertView.showMessage(message: MSG_TXT_RECHARGE_AMOUNT, messageType: .WARNING)
            return; }
            
        else if Int(stAmount)! < 1 {
             _KDAlertView.showMessage(message: MSG_TXT_RECHARGE_AMOUNT_MAX, messageType: .WARNING)
            return; }
        
        self.showRechargeView()
    }
    @IBAction func btnBrowsePlanAction() {
        if self.dictMobileRecharge_SelectedOperator.isEmpty {
            isBrowsePlan = true
            btnOperatorCircleAction() }
        else {
            self.hideKeyboard()
            let planVC = PlanViewController(nibName: "PlanViewController", bundle: nil)
            planVC.dictOperator = self.dictMobileRecharge_SelectedOperator
            planVC.dictRegion = self.dictMobileRecharge_SelectedRegion
            planVC.stCategoryID = self.dictOpertaorCategory[RES_operatorCategoryId] as! String
            self.navigationController?.pushViewController(planVC, animated: true)
        }
    }
    
    //MARK: CUSTOM METHODS
    
    func fillOrderFromSlider() {
        
        self.dictMobileRecharge_SelectedOperator = dictFillOrder
        self.dictMobileRecharge_SelectedRegion = dictFillOrder
        self.txtOperator.text = dictFillOrder[RES_operatorName] as? String
        self.txtMobileNo.text = dictFillOrder[RES_mobileNo] as? String
        
        isOrderData = true
        if dictFillOrder[RES_subCategoryId] as! String == VAL_RECHARGE_PREPAID {
            self.txtAmont.text = dictFillOrder[RES_amount] as? String
            self.btnPrePostpaidAction(btnPrepaid)
        }
        else{ self.txtAmont.text = ""; self.btnPrePostpaidAction(btnPostpaid) }
        
        self.setMobileRecharge_TopUpAndSpecialRechargeView()
        self.txtAmont.becomeFirstResponder()
      //  self.scrollViewBG.setContentOffset(.zero, animated: true)
    }
    
    internal func onPlanSelection(_ aNotification: Notification) {
        
            self.dictMobileRecharge_SelectedPlan = aNotification.object as! typeAliasDictionary
            if self.dictMobileRecharge_SelectedPlan[RES_PlanValue] != nil { txtAmont.text = self.dictMobileRecharge_SelectedPlan[RES_PlanValue] as? String }
            if !viewTopupSpecial.isHidden {
                let isSpelicalType: String = self.dictMobileRecharge_SelectedPlan[RES_isSpelicalType] as! String
                if isSpelicalType == "1" { self.btnTalktimeSpecialAction(btnSpecialRecharge) }
                else {self.btnTalktimeSpecialAction(btnTalktimeTopup) }
        }
    }
    
    fileprivate func setMobileRecharge_TopUpAndSpecialRechargeView() {
        if !dictMobileRecharge_SelectedOperator.isEmpty {
            
            let isShowPlanTypeSelect: String = dictMobileRecharge_SelectedOperator[RES_isShowPlanTypeSelect] as! String
            if isShowPlanTypeSelect == "1" && btnPrepaid.isSelected {
                    viewTopupSpecial.isHidden = false
                constraintBtnProcessTopToViewTalktimeRechargeview.priority = PRIORITY_HIGH
                constraintBtnProcessTopToViewAmount.priority = PRIORITY_LOW
                constraintBtnProcessTopToViewRemark.priority = PRIORITY_LOW
                btnTalktimeTopup.isSelected = true
                btnSpecialRecharge.isSelected = false
                viewNote.isHidden = true
            }
            else if isShowPlanTypeSelect == "0" && btnPrepaid.isSelected{
                
                constraintBtnProcessTopToViewTalktimeRechargeview.priority = PRIORITY_LOW
                constraintBtnProcessTopToViewAmount.priority = PRIORITY_HIGH
                constraintBtnProcessTopToViewRemark.priority = PRIORITY_LOW
                viewTopupSpecial.isHidden = true
                btnTalktimeTopup.isSelected = false
                btnSpecialRecharge.isSelected = false
            }
            else {
                viewTopupSpecial.isHidden = true
                btnTalktimeTopup.isSelected = false
                btnSpecialRecharge.isSelected = false
            }
        }
    }
    
    fileprivate func callSearchMobileOperatorService(_ mobileNo: String) {
       
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_U_MOBILE: mobileNo,
                      REQ_CATEGORY_ID: HOME_CATEGORY_TYPE.MOBILE.rawValue ]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_SearchMobile, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: UIView.init(), onSuccess: { (dict) in
            DataModel.setHeaderToken(dict[RES_token] as! String)
            var dictOperator: typeAliasDictionary = typeAliasDictionary()
            dictOperator[RES_operatorID] = dict[RES_result]![RES_operatorID] as AnyObject
            dictOperator[RES_operatorName] = dict[RES_result]![RES_operatorName] as AnyObject
            dictOperator[RES_isShowPlanTypeSelect] = dict[RES_result]![RES_isShowPlanTypeSelect] as AnyObject
            
            let dictResult:typeAliasDictionary = dict[RES_result]! as! typeAliasDictionary
            
            if dictResult[RES_subCategoryId] != nil {
                
                if dictResult[RES_subCategoryId] as! String == VAL_RECHARGE_PREPAID {
                    self.btnPrePostpaidAction(self.btnPrepaid)
                }
                else if dictResult[RES_subCategoryId] as! String == VAL_RECHARGE_POSTPAID {
                    self.btnPrePostpaidAction(self.btnPostpaid)
                }
            }
            else { self.btnPrePostpaidAction(self.btnPrepaid) }
            self.onOperatorView_Selection(dictOperator, dictRegion: dict[RES_result] as! typeAliasDictionary)
        }, onFailure: { (code, dict) in
            
        }) { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return }
    }
    
    fileprivate func callGetLatestOrdersService() {
        
        let dicUser  = DataModel.getUserInfo()
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID: dicUser[RES_userID] as! String ,
                      REQ_ORDER_TYPE_ID: VAL_ORDERTYPE_MOBILE] as [String : Any]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_GetLatestOrders, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params as! typeAliasStringDictionary, viewActivityParent: UIView.init(frame: .zero), onSuccess: { (dict) in
            DataModel.setHeaderToken(dict[RES_token] as! String)
            self.arrLatestOrders = dict[RES_latest_orders] as! [typeAliasDictionary]
            self.constraintTableViewRecentListHeight.constant = self.tableViewRecentList.rowHeight * CGFloat(self.arrLatestOrders.count)
            self.viewRecentList.isHidden = false
            self.tableViewRecentList.reloadData()
            self.constraintViewBtnProceesBottomToSuper.priority = PRIORITY_LOW
            self.constraintViewRecentListBottomToSuper.priority = PRIORITY_HIGH
        }, onFailure: { (code, dict) in
            self.constraintViewBtnProceesBottomToSuper.priority = PRIORITY_HIGH
            self.constraintViewRecentListBottomToSuper.priority = PRIORITY_LOW
            self.viewRecentList.isHidden = true
        }) {self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return}
    }
    
    func hideKeyboard() {
        txtAmont.resignFirstResponder()
        txtMobileNo.resignFirstResponder()
        txtOperator.resignFirstResponder()
    }
    
    func showRechargeView() {
        
        var isPaidFees:Bool = false
        if DataModel.getUserWalletResponse()[RES_isPayMemberShipFee] as! String == "1"{
            isPaidFees = true;
        }
        else{
            if obj_AppDelegate.isMemberShipFeesPaid() { isPaidFees = true; }
            else { isPaidFees = false }
        }
        
        if isPaidFees {
            
            // FOR ENCHANCED ECOMMERCE TRACKING // GOOGLE TAG MANAGER
            let gtmModel = GTMModel()
            gtmModel.ee_type = "Recharge"
            gtmModel.name = GTM_MOBILE_RECHARGE
            
            let rechargeVC = RechargeViewController(nibName: "RechargeViewController", bundle: nil)
            rechargeVC.mobile_CardOperator = self.dictMobileRecharge_SelectedOperator[RES_operatorName] as! String
            rechargeVC.mobile_CardRegionName = self.dictMobileRecharge_SelectedRegion.isEmpty || self.dictMobileRecharge_SelectedRegion[RES_regionName] == nil ? "0" : self.dictMobileRecharge_SelectedRegion[RES_regionName] as! String
            rechargeVC.mobile_CardPrepaidPostpaid = (self.btnPrepaid.isSelected ? self.btnPrepaid.currentTitle : self.btnPostpaid.currentTitle)!
            rechargeVC.cart_PrepaidPostpaid = self.btnPrepaid.isSelected ? VAL_RECHARGE_PREPAID : VAL_RECHARGE_POSTPAID
            rechargeVC.cart_PlanTypeID = !self.dictMobileRecharge_SelectedPlan.isEmpty ? self.dictMobileRecharge_SelectedPlan[RES_planTypeId] as! String : "0"
            rechargeVC.cart_MobileNo = self.txtMobileNo.text!.trim() //consumer id
            rechargeVC.cart_TotalAmount = self.txtAmont.text!.trim()
            rechargeVC.cart_OperatorId = self.dictMobileRecharge_SelectedOperator[RES_operatorID] as! String
            rechargeVC.cart_RegionId = self.dictMobileRecharge_SelectedRegion.isEmpty || self.dictMobileRecharge_SelectedRegion[RES_regionID] == nil ? "0" : self.dictMobileRecharge_SelectedRegion[RES_regionID] as! String
            rechargeVC.cart_CategoryId = dictOpertaorCategory[RES_operatorCategoryId] as! String
            rechargeVC.cart_RegionPlanId =  dictMobileRecharge_SelectedPlan.isEmpty ? "0" : dictMobileRecharge_SelectedPlan[RES_regionPlanID] as! String
            rechargeVC.cart_PlanValue =  self.txtAmont.text!.trim()
            
            if !viewTopupSpecial.isHidden {
                rechargeVC.cart_Extra1 = btnTalktimeTopup.isSelected ? "1" : "0"
                rechargeVC.cart_Extra2 = btnSpecialRecharge.isSelected ? "1" : "0"
            }
            else { rechargeVC.cart_Extra1 = "0"; rechargeVC.cart_Extra2 = "0"; }
            
            rechargeVC._RECHARGE_TYPE = RECHARGE_TYPE.MOBILE_RECHARGE
            rechargeVC.stTitle = dictOpertaorCategory[RES_operatorCategoryName] as! String
            rechargeVC.stImageUrl =  self.dictMobileRecharge_SelectedOperator[RES_image] != nil ? self.dictMobileRecharge_SelectedOperator[RES_image] as! String : ""
            
            // SET GTMMODEL DATA FOR ADD TO CART
            
            gtmModel.price = rechargeVC.cart_TotalAmount
            gtmModel.product_Id = DataModel.getUserInfo()[RES_userID] as! String
            gtmModel.brand = rechargeVC.mobile_CardOperator
            gtmModel.category = rechargeVC.mobile_CardPrepaidPostpaid
            gtmModel.variant = rechargeVC.cart_MobileNo
            gtmModel.dimension3 = "\(rechargeVC.mobile_CardOperator):\(rechargeVC.mobile_CardRegionName)"
            gtmModel.dimension4 = "0"
            gtmModel.list = "Mobile Section"
            GTMModel.pushProductDetail(gtmModel: gtmModel)
            GTMModel.pushAddToCart(gtmModel: gtmModel)
            
            self.navigationController?.pushViewController(rechargeVC, animated: true)
        }

        else{
            _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .WARNING)
        }
    }
    
    //MARK: UITABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return arrLatestOrders.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell: RecentListCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_RECENTLIST_CELL) as! RecentListCell;
            let dictRecent:typeAliasDictionary = arrLatestOrders[indexPath.row]
        
            cell.lblNumber.text = dictRecent[RES_mobileNo] as! String?
            cell.lblLastRecharge.text = ""
            if  dictRecent[RES_subCategoryId] as! String == "1" { cell.btnAmount.setTitle("\(RUPEES_SYMBOL) \(dictRecent[RES_amount]!)", for: .normal)}
            else{ cell.btnAmount.setTitle("Pay Bill", for: .normal) }
        
            cell.lblLastRecharge.text = dictRecent[RES_note] as! String?

            cell.activityIndicator.startAnimating()
            cell.imageViewOperator.sd_setImage(with: (dictRecent[RES_image] as! String).convertToUrl()) { (image, error, type, url) in
            if image == nil {
                cell.imageViewOperator.image = #imageLiteral(resourceName: "logo_nav")
            }
            else{
                cell.imageViewOperator.image  = image
            }
                cell.activityIndicator.stopAnimating()
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
    }

    //MARK: UITABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return HEIGHT_RECENTLIST_CELL }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        let dictOrder = arrLatestOrders[indexPath.row]
        self.dictMobileRecharge_SelectedOperator = dictOrder
        self.dictMobileRecharge_SelectedRegion = dictOrder
        self.txtOperator.text = dictOrder[RES_operatorName] as? String
        self.txtMobileNo.text = dictOrder[RES_mobileNo] as? String
        
        isOrderData = true
        if dictOrder[RES_subCategoryId] as! String == VAL_RECHARGE_PREPAID {
            self.txtAmont.text = dictOrder[RES_amount] as? String
            self.btnPrePostpaidAction(btnPrepaid)
        }
        else{ self.txtAmont.text = ""; self.btnPrePostpaidAction(btnPostpaid) }
        self.setMobileRecharge_TopUpAndSpecialRechargeView()
        self.txtAmont.becomeFirstResponder()
        self.scrollViewBG.setContentOffset(.zero, animated: true)
        
    /*    var isPaidFees:Bool = false
        if DataModel.getUserWalletResponse()[RES_isPayMemberShipFee] as! String == "1"{
            isPaidFees = true;
        }
        else{
            if obj_AppDelegate.isMemberShipFeesPaid() { isPaidFees = true; }
            else { isPaidFees = false }
        }
        
        if isPaidFees {
            
            let rechargeVC = RechargeViewController(nibName: "RechargeViewController", bundle: nil)
            rechargeVC.mobile_CardOperator = self.dictMobileRecharge_SelectedOperator[RES_operatorName] as! String
            rechargeVC.mobile_CardRegionName = self.dictMobileRecharge_SelectedRegion.isEmpty || self.dictMobileRecharge_SelectedRegion[RES_regionName] == nil ? "0" : self.dictMobileRecharge_SelectedRegion[RES_regionName] as! String
            
            rechargeVC.mobile_CardPrepaidPostpaid = (dictOrder[RES_subCategoryId] as! String == "1" ? self.btnPrepaid.currentTitle : self.btnPostpaid.currentTitle)!
            
            rechargeVC.cart_PrepaidPostpaid = dictOrder[RES_subCategoryId] as! String
            
            rechargeVC.cart_PlanTypeID = dictOrder[RES_planTypeId] as! String
            
            rechargeVC.cart_MobileNo =  dictOrder[RES_mobileNo] as! String //consumer id
            rechargeVC.cart_TotalAmount =  dictOrder[RES_amount] as! String
            
            rechargeVC.cart_OperatorId = self.dictMobileRecharge_SelectedOperator[RES_operatorID] as! String
            
            rechargeVC.cart_RegionId = self.dictMobileRecharge_SelectedRegion.isEmpty || self.dictMobileRecharge_SelectedRegion[RES_regionID] == nil ? "0" : self.dictMobileRecharge_SelectedRegion[RES_regionID] as! String
            rechargeVC.cart_CategoryId = dictOpertaorCategory[RES_operatorCategoryId] as! String
            rechargeVC.cart_RegionPlanId =  dictOrder[RES_regionPlanID] == nil ? "0" : dictOrder[RES_regionPlanID] as! String
            
            rechargeVC.cart_PlanValue =   dictOrder[RES_amount] as! String
            
            rechargeVC.cart_Extra1 =  dictOrder[RES_extra1] as! String
            rechargeVC.cart_Extra2 = dictOrder[RES_extra2] as! String
            
            rechargeVC._RECHARGE_TYPE = RECHARGE_TYPE.MOBILE_RECHARGE
            
            self.navigationController?.pushViewController(rechargeVC, animated: true)
        }
            
        else{
            _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .WARNING)
        }*/

    }
    
    //MARK: UITEXTFIELD DELEGATE
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
         if textField == txtOperator {
            self.btnOperatorCircleAction()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        if textField == txtMobileNo { txtOperator.becomeFirstResponder() }
        else if textField == txtOperator { txtAmont.becomeFirstResponder() }
        else if textField == txtAmont { txtAmont.resignFirstResponder() }
    
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
   
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text: String = textField.text!
        let resultingString: String = text.replacingCharacters(in: range.toRange(string: text), with: string)
        if resultingString.isEmpty
        {
            if textField == txtMobileNo {
                self.dictMobileRecharge_SelectedOperator = typeAliasDictionary()
                self.dictMobileRecharge_SelectedRegion = typeAliasDictionary()
                self.txtOperator.text = ""
            }
                
            return true
        }
        
        if textField == txtMobileNo  {
            var holder: Float = 0.00
            let scan: Scanner = Scanner(string: resultingString)
            let RET: Bool = scan.scanFloat(&holder) && scan.isAtEnd
            if string == "." { return false }
            if RET { if resultingString.count  == 10 { self.callSearchMobileOperatorService(resultingString) } }
            if resultingString.count > 10 { return false }
            return RET
        }
            
        else if textField == txtAmont
        {
            var holder: Float = 0.00
            let scan: Scanner = Scanner(string: resultingString)
            let RET: Bool = scan.scanFloat(&holder) && scan.isAtEnd
            let text = textField.text?.trim()
            if string == "." { return false }
            if text?.count == 0 && string == "0"{return false}
            let amountLimit = Int(dictOpertaorCategory[RES_amountLimit] as! String)
            if resultingString.count > amountLimit! { return false }
            self.dictMobileRecharge_SelectedPlan = typeAliasDictionary()
            return RET
        }
        
        return true
    }
    
    //MARK: OPERATORVIEW DELEGATE
    func onOperatorView_Selection(_ dictOperator: typeAliasDictionary, dictRegion: typeAliasDictionary) {
        self.dictMobileRecharge_SelectedOperator = dictOperator
        self.dictMobileRecharge_SelectedRegion = dictRegion
        self.txtOperator.text = dictOperator[RES_operatorName] as? String
        self.setMobileRecharge_TopUpAndSpecialRechargeView()
        if isBrowsePlan {
            btnBrowsePlanAction()
            isBrowsePlan = false
        }
    }
    
    //MARK: CONTACT PICKER DELEGATE
    
   
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        
        for number in contactProperty.contact.phoneNumbers {
            if number.label == contactProperty.label {
                let phone :CNPhoneNumber = number.value
                var selectedPhone:String = String(describing: phone.value(forKey: "digits")!)
                selectedPhone = selectedPhone.extractPhoneNo()
                if selectedPhone.characters.count > 10 {
                    _KDAlertView.showMessage(message: MSG_TXT_MOBILE_NO_VALID, messageType: .WARNING)
                    return
                }
                else{
                 txtMobileNo.text = selectedPhone
                 self.callSearchMobileOperatorService(selectedPhone)
                }
            }
        }
    }
    
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        
    }
}
