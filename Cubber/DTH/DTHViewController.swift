//
//  MobileRechargeViewController.swift
//  Cubber
//
//  Created by dnk on 29/08/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit
import ContactsUI

class DTHViewController: UIViewController, UITextFieldDelegate , UIScrollViewDelegate , UITableViewDelegate,UITableViewDataSource , OperatorViewDelegate , CNContactPickerDelegate  ,AppNavigationControllerDelegate {
   
    //MARK:PROPERTIES
    
    @IBOutlet var scrollViewBG: UIScrollView!
    @IBOutlet var txtMobileNo: UITextField!
    @IBOutlet var txtOperator: UITextField!
    @IBOutlet var txtAmont: UITextField!
    
    @IBOutlet var btnBrowsePlan: UIButton!
    @IBOutlet var viewNote: UIView!
    @IBOutlet var lblRemark: UILabel!
    
    @IBOutlet var tableViewRecentList: UITableView!
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
    fileprivate var dictDthRecharge_SelectedOperator = typeAliasDictionary()
    fileprivate var dictDthRecharge_SelectedRegion = typeAliasDictionary()
    fileprivate var dictDthRecharge_SelectedPlan = typeAliasDictionary()
    fileprivate var arrLatestOrders:[typeAliasDictionary] = [typeAliasDictionary]()
    fileprivate var isOrderData:Bool = false
    fileprivate var dateFormat:DateFormatter = DateFormatter()
    var dictOpertaorCategory:typeAliasDictionary!
    fileprivate var isBrowsePlan:Bool = false
    internal var isFillOrder :Bool = false
    internal var dictFillOrder = typeAliasDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewNote.isHidden = true
        btnBrowsePlan.isHidden = dictOpertaorCategory[RES_isBrowse] as! String == "1" ? false : true
        lblRemark.text = dictOpertaorCategory[RES_remark] as! String == "0" ? "" : dictOpertaorCategory[RES_remark] as! String 
        tableViewRecentList.register(UINib.init(nibName: CELL_IDENTIFIER_RECENTLIST_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_RECENTLIST_CELL)
        tableViewRecentList.rowHeight = HEIGHT_RECENTLIST_CELL
        self.callGetLatestOrdersService()
        self.constraintViewBtnProceesBottomToSuper.priority = PRIORITY_HIGH
        self.constraintViewRecentListBottomToSuper.priority = PRIORITY_LOW
        self.viewRecentList.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(onPlanSelection), name: NSNotification.Name(rawValue: NOTIFICATION_PLAN_VIEW_SELECTION), object: nil)
        if isFillOrder && !dictFillOrder.isEmpty {
            self.fillOrderFromSlider()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        btnBrowsePlan.setViewBorder(COLOUR_DARK_GREEN, borderWidth: 1, isShadow: false, cornerRadius: btnBrowsePlan.frame.height/2, backColor: UIColor.clear)
        self.SetScreenName(name: F_MODULE_DTH, stclass: F_MODULE_DTH)
        self.sendScreenView(name: F_MODULE_DTH)
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

    
    @IBAction func btnOperatorCircleAction() {
        self.hideKeyboard()
        let operatorView:OperatorView = OperatorView.init(frame: UIScreen.main.bounds, categoryID:HOME_CATEGORY_TYPE.DTH.rawValue)
        operatorView.delegate = self
    }
    
    
    @IBAction func btnBrowsePlanAction() {
        
        if self.dictDthRecharge_SelectedOperator.isEmpty {
            isBrowsePlan = true
            btnOperatorCircleAction() }
        else {
            self.hideKeyboard()
            let planVC = PlanViewController(nibName: "PlanViewController", bundle: nil)
            planVC.dictOperator = self.dictDthRecharge_SelectedOperator
            planVC.dictRegion = self.dictDthRecharge_SelectedRegion
            planVC.stCategoryID = self.dictOpertaorCategory[RES_operatorCategoryId] as! String
            self.navigationController?.pushViewController(planVC, animated: true)
        }

    }
    
    
    @IBAction func btnProcessAction() {
  
        let stMobileNo: String = txtMobileNo.text!.trim()
        let stAmount: String = txtAmont.text!.trim()
        self.hideKeyboard()
        if stMobileNo.characters.isEmpty {
            _KDAlertView.showMessage(message: MSG_TXT + txtMobileNo.placeholder!, messageType: .WARNING)
             return; }
        
        if self.dictDthRecharge_SelectedOperator.isEmpty {
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
    
    
    //MARK: CUSTOM METHODS
    
    func fillOrderFromSlider() {
        
        self.dictDthRecharge_SelectedOperator = dictFillOrder
        self.dictDthRecharge_SelectedRegion = dictFillOrder
        self.txtOperator.text = dictFillOrder[RES_operatorName] as? String
        self.txtMobileNo.text = dictFillOrder[RES_mobileNo] as? String
        if dictFillOrder[RES_amount] != nil {
            self.txtAmont.text = dictFillOrder[RES_amount] as? String
        }
        else{
            self.txtAmont.text = ""
        }
        self.txtAmont.becomeFirstResponder()
    }
    
    
    internal func onPlanSelection(_ aNotification: Notification) {
        
        self.dictDthRecharge_SelectedPlan = aNotification.object as! typeAliasDictionary
        if self.dictDthRecharge_SelectedPlan[RES_PlanValue] != nil { txtAmont.text = self.dictDthRecharge_SelectedPlan[RES_PlanValue] as? String }
        
    }
    
    fileprivate func callGetLatestOrdersService() {
        
        let dicUser  = DataModel.getUserInfo()
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID: dicUser[RES_userID] as! String ,
                      REQ_ORDER_TYPE_ID: VAL_ORDERTYPE_DTH] as [String : Any]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_GetLatestOrders, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params as! typeAliasStringDictionary, viewActivityParent: UIView.init(frame: .zero), onSuccess: { (dict) in
            DataModel.setHeaderToken(dict[RES_token] as! String)
            self.arrLatestOrders = dict[RES_latest_orders] as! [typeAliasDictionary]
            self.constraintTableViewRecentListHeight.constant = self.tableViewRecentList.rowHeight * CGFloat(self.arrLatestOrders.count)
            self.viewRecentList.isHidden = false
            self.tableViewRecentList.reloadData()
            self.constraintViewBtnProceesBottomToSuper.priority = PRIORITY_LOW
            self.constraintViewRecentListBottomToSuper.priority = PRIORITY_HIGH
        }, onFailure: { (code, dict) in
            self.viewRecentList.isHidden = true
            self.constraintViewBtnProceesBottomToSuper.priority = PRIORITY_HIGH
            self.constraintViewRecentListBottomToSuper.priority = PRIORITY_LOW
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

            gtmModel.name = GTM_DTH_RECHARGE
            gtmModel.ee_type = "Recharge"
            
            let rechargeVC = RechargeViewController(nibName: "RechargeViewController", bundle: nil)
            rechargeVC.mobile_CardOperator = self.dictDthRecharge_SelectedOperator[RES_operatorName] as! String
            rechargeVC.mobile_CardRegionName = self.dictDthRecharge_SelectedRegion.isEmpty || self.dictDthRecharge_SelectedRegion[RES_regionName] == nil ? "0" : self.dictDthRecharge_SelectedRegion[RES_regionName] as! String
            rechargeVC.mobile_CardPrepaidPostpaid = VAL_RECHARGE_PREPAID_CAPTION
            rechargeVC.cart_PrepaidPostpaid = VAL_RECHARGE_PREPAID
            rechargeVC.cart_PlanTypeID = !self.dictDthRecharge_SelectedPlan.isEmpty ? self.dictDthRecharge_SelectedPlan[RES_planTypeId] as! String : "0"
            rechargeVC.cart_MobileNo = self.txtMobileNo.text!.trim()
            rechargeVC.cart_TotalAmount = self.txtAmont.text!.trim()
            rechargeVC.cart_OperatorId = self.dictDthRecharge_SelectedOperator[RES_operatorID] as! String
            rechargeVC.cart_RegionId = self.dictDthRecharge_SelectedRegion.isEmpty || self.dictDthRecharge_SelectedRegion[RES_regionID] == nil ? "0" : self.dictDthRecharge_SelectedRegion[RES_regionID] as! String
            rechargeVC.cart_CategoryId = dictOpertaorCategory[RES_operatorCategoryId] as! String
            rechargeVC.cart_RegionPlanId =  dictDthRecharge_SelectedPlan.isEmpty ? "0" : dictDthRecharge_SelectedPlan[RES_regionPlanID] as! String
            rechargeVC.cart_PlanValue =  self.txtAmont.text!.trim()
            rechargeVC._RECHARGE_TYPE = RECHARGE_TYPE.DTH_RECHARGE
             rechargeVC.stTitle = dictOpertaorCategory[RES_operatorCategoryName] as! String
            
            rechargeVC.stImageUrl =  self.dictDthRecharge_SelectedOperator[RES_image] != nil ? self.dictDthRecharge_SelectedOperator[RES_image] as! String : ""
            // SET GTMMODEL DATA FOR ADD TO CART
            
            gtmModel.ee_type = GTM_EE_TYPE_RECHARGE
            gtmModel.price = rechargeVC.cart_TotalAmount
            gtmModel.product_Id = DataModel.getUserInfo()[RES_userID] as! String
            gtmModel.brand = rechargeVC.mobile_CardOperator
            gtmModel.category = rechargeVC.mobile_CardPrepaidPostpaid
            gtmModel.variant = rechargeVC.cart_MobileNo
            gtmModel.dimension3 = "\(rechargeVC.mobile_CardOperator):\(rechargeVC.mobile_CardRegionName)"
            gtmModel.dimension4 = "0"
            gtmModel.list = "DTH Section"
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
        self.dictDthRecharge_SelectedOperator = dictOrder
        self.dictDthRecharge_SelectedRegion = dictOrder
        self.txtOperator.text = dictOrder[RES_operatorName] as? String
        self.txtMobileNo.text = dictOrder[RES_mobileNo] as? String
        self.txtAmont.text = dictOrder[RES_amount] as? String
        self.txtAmont.becomeFirstResponder()
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
        
        
        if textField == txtMobileNo { txtAmont.becomeFirstResponder() }
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
          return true
        }

        
        if textField == txtAmont
        {
            var holder: Float = 0.00
            let scan: Scanner = Scanner(string: resultingString)
            let RET: Bool = scan.scanFloat(&holder) && scan.isAtEnd
            let text = textField.text?.trim()
            if string == "." { return false }
            if text?.count == 0 && string == "0"{ return false}
            let amountLimit = Int(dictOpertaorCategory[RES_amountLimit] as! String)
            if resultingString.count > amountLimit! { return false }
            self.dictDthRecharge_SelectedPlan = typeAliasDictionary()
            return RET
        }
        
        return true
    }
    
    //MARK: OPERATORVIEW DELEGATE
    func onOperatorView_Selection(_ dictOperator: typeAliasDictionary, dictRegion: typeAliasDictionary) {
        self.dictDthRecharge_SelectedOperator = dictOperator
        self.dictDthRecharge_SelectedRegion = dictRegion
        self.txtOperator.text = dictOperator[RES_operatorName] as? String
        self.txtMobileNo.placeholder = dictOperator[RES_placeholder] as? String
        self.txtMobileNo.text = ""
        self.txtAmont.text = ""
        self.dictDthRecharge_SelectedPlan = typeAliasDictionary()
        self.txtMobileNo.becomeFirstResponder()
    }
   
}
