//
//  GasBillViewController.swift
//  Cubber
//
//  Created by dnk on 01/09/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class GasBillViewController: UIViewController ,UITextFieldDelegate , UIScrollViewDelegate , UITableViewDelegate,UITableViewDataSource , OperatorViewDelegate , CubberTextFieldDelegate , RegionViewDelegate , AppNavigationControllerDelegate {

    //MARK: CONSTANT
    internal let TAG_PLUS: Int = 100
    internal let TAG_LANDLINE_REGION: Int = 2
    
    //MARK: PROPERTIES
    
    @IBOutlet var scrollViewBG: UIScrollView!
    @IBOutlet var viewRecentList: UIView!
    @IBOutlet var viewBillInfo: UIView!
    @IBOutlet var viewAmount: UIView!
    @IBOutlet var viewRemark: UIView!
    @IBOutlet var viewServiceTextFiled: UIView!
    
    @IBOutlet var tableViewRecentList: UITableView!
    
    @IBOutlet var txtOperator: FloatLabelTextField!
    @IBOutlet var txtAmount: FloatLabelTextField!
    
    @IBOutlet var btnGetBillAmount: UIButton!
    @IBOutlet var btnProcess: UIButton!
    
    @IBOutlet var lblRemark: UILabel!
    @IBOutlet var lblConsumerName: UILabel!
    @IBOutlet var lblBillDate: UILabel!
    @IBOutlet var lblBillDueDate: UILabel!
    
    @IBOutlet var constraintTableViewRecentListHeight: NSLayoutConstraint!
    @IBOutlet var constraintviewBGServiceTextField_ElectricityBillHeight: NSLayoutConstraint!
    @IBOutlet var constraintViewRemarkTopToViewServiceTextField: NSLayoutConstraint!
    @IBOutlet var constraintViewRemarkTopToViewBillInfo: NSLayoutConstraint!
    @IBOutlet var constraintViewRecentBottomToSuper: NSLayoutConstraint!
    @IBOutlet var constraintBtnGetBillAmountBottomToSuper: NSLayoutConstraint!
    
    //BILL INFO
    @IBOutlet var viewBillInfo_ViewConsumerName: UIView!
    @IBOutlet var viewBillInfo_ViewBillDate: UIView!
    @IBOutlet var viewBillInfo_ViewBillDueDate: UIView!
    
    @IBOutlet var constraintViewBiillInfo_ViewConsumerNameHeight: NSLayoutConstraint!
    @IBOutlet var constraintViewBiillInfo_ViewBillDateHeight: NSLayoutConstraint!
    @IBOutlet var constraintViewBiillInfo_ViewBillDueDateHeight: NSLayoutConstraint!
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var _KDAlertView = KDAlertView()
    fileprivate var dictElectricityBill_SelectedOperator = typeAliasDictionary()
    fileprivate var dictElectricityBill_SelectedRegion = typeAliasDictionary()
    fileprivate var dictElectricityBill_SelectedPlan = typeAliasDictionary()
    fileprivate var arrLatestOrders:[typeAliasDictionary] = [typeAliasDictionary]()
    fileprivate var dateFormat:DateFormatter = DateFormatter()
    var dictOpertaorCategory:typeAliasDictionary!
    internal var isFillOrder :Bool = false
    internal var dictFillOrder = typeAliasDictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewRecentList.register(UINib.init(nibName: CELL_IDENTIFIER_RECENTLIST_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_RECENTLIST_CELL)
        tableViewRecentList.rowHeight = HEIGHT_RECENTLIST_CELL
        self.viewRecentList.isHidden = true
        self.constraintBtnGetBillAmountBottomToSuper.priority = PRIORITY_HIGH
        self.constraintViewRecentBottomToSuper.priority = PRIORITY_LOW
        self.callGetLatestOrdersService()
        self.resetBillInfo()
        if isFillOrder && !dictFillOrder.isEmpty {
            self.fillOrderFromSlider()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.setNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.SetScreenName(name: F_MODULE_GAS, stclass: F_MODULE_GAS)
        self.sendScreenView(name: F_MODULE_GAS)
        self.registerForKeyboardNotifications()
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
    
    
    
    //MARK: BUTTON METHODS
    @IBAction func btnProcessAction() {
        self.hideKeyboard()
        let stAmount: String = txtAmount.text!.trim()
        if stAmount.characters.isEmpty {
            _KDAlertView.showMessage(message: MSG_TXT_RECHARGE_AMOUNT, messageType: .WARNING)
            return; }
        self.showRechargeView()
    }
    
    
    @IBAction func btnGetBillAmountAction() {
        self.hideKeyboard()
        for viewBG in viewServiceTextFiled.subviews {
            if viewBG.isKind(of: CubberTextField.self) {
               let _CubberTextField = viewBG as! CubberTextField
               _CubberTextField.txtContent.resignFirstResponder()
           }
        }
        self.callGetBillAmountSerivice()
     }
    
    //MARK: CUSTOM METHODS 
    
    func fillOrderFromSlider() {
        
          setValueInOperatorField(dictOperator: dictFillOrder, dictRegion: dictFillOrder.isKeyNull(RES_region) ? typeAliasDictionary() :dictFillOrder, isOrder: true)
        self.btnGetBillAmountAction()
    }
    
    func hideKeyboard() {
        txtAmount.resignFirstResponder()
        txtOperator.resignFirstResponder()
        for viewBG in viewServiceTextFiled.subviews {
            if viewBG.isKind(of: CubberTextField.self) {
                let cubberTxt:CubberTextField = viewBG as! CubberTextField
                cubberTxt.txtContent.resignFirstResponder() }}
    }
    
    func showRechargeView(){
        
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
            gtmModel.name = GTM_GAS_BILL_PAY
            gtmModel.ee_type = "Bill Pay"
            
            let rechargeVC = RechargeViewController(nibName: "RechargeViewController", bundle: nil)
            rechargeVC.mobile_CardOperator = self.dictElectricityBill_SelectedOperator[RES_operatorName] as! String
            rechargeVC.mobile_CardRegionName = self.dictElectricityBill_SelectedRegion.isEmpty || self.dictElectricityBill_SelectedRegion[RES_regionName] == nil ? "0" : self.dictElectricityBill_SelectedRegion[RES_regionName] as! String
            rechargeVC.mobile_CardPrepaidPostpaid = VAL_RECHARGE_POSTPAID_CAPTION
            rechargeVC.cart_PrepaidPostpaid = VAL_RECHARGE_POSTPAID
            rechargeVC.cart_PlanTypeID = "0"
            
            for viewBG in viewServiceTextFiled.subviews {
                if viewBG.isKind(of: CubberTextField.self) {
                    let _CubberTextField = viewBG as! CubberTextField
                    let stContent: String = _CubberTextField.txtContent.text!.trim()
                    
                    if _CubberTextField.txtContent.tag - TAG_PLUS == 0 { rechargeVC.cart_MobileNo = stContent }
                    else if _CubberTextField.txtContent.tag - TAG_PLUS == 1 { rechargeVC.cart_Extra1 = stContent }
                    else if _CubberTextField.txtContent.tag - TAG_PLUS == 2 { rechargeVC.cart_Extra2 = stContent }
                }
            }
            
            rechargeVC.cart_TotalAmount = self.txtAmount.text!.trim()
            rechargeVC.cart_OperatorId = self.dictElectricityBill_SelectedOperator[RES_operatorID] as! String
            rechargeVC.cart_RegionId = self.dictElectricityBill_SelectedRegion.isEmpty || self.dictElectricityBill_SelectedRegion[RES_regionID] == nil ? "0" : self.dictElectricityBill_SelectedRegion[RES_regionID] as! String
            rechargeVC.cart_CategoryId = dictOpertaorCategory[RES_operatorCategoryId] as! String
            rechargeVC.cart_RegionPlanId = "0"
            rechargeVC.cart_PlanValue =  self.txtAmount.text!.trim()
            rechargeVC._RECHARGE_TYPE = RECHARGE_TYPE.GAS_BILL
             rechargeVC.stTitle = dictOpertaorCategory[RES_operatorCategoryName] as! String
            rechargeVC.stImageUrl =  self.dictElectricityBill_SelectedOperator[RES_image] != nil ? self.dictElectricityBill_SelectedOperator[RES_image] as! String : ""
            // SET GTMMODEL DATA FOR ADD TO CART
            
            gtmModel.price = rechargeVC.cart_TotalAmount
            gtmModel.product_Id = DataModel.getUserInfo()[RES_userID] as! String
            gtmModel.brand = rechargeVC.mobile_CardOperator
            gtmModel.category = rechargeVC.mobile_CardPrepaidPostpaid
            gtmModel.variant = rechargeVC.cart_MobileNo
            gtmModel.dimension3 = "\(rechargeVC.mobile_CardOperator):\(rechargeVC.mobile_CardRegionName)"
            gtmModel.dimension4 = "0"
            gtmModel.list = "Gas Bill Section"
            GTMModel.pushProductDetail(gtmModel: gtmModel)
            GTMModel.pushAddToCart(gtmModel: gtmModel)
            self.navigationController?.pushViewController(rechargeVC, animated: true)
            
        }
        else{
            _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .WARNING)
        }
    }
    
    func setValueInOperatorField(dictOperator:typeAliasDictionary , dictRegion:typeAliasDictionary , isOrder:Bool) {
    
        let setDynamicView = { (size: CGSize, txtField: UITextField, viewBG: UIView, constraintHeight: NSLayoutConstraint) in
            txtField.text = dictOperator[RES_operatorName] as? String
            
            var arrTextField = [typeAliasStringDictionary]()
            let arrPlaceholder: Array<String> = (dictOperator[RES_placeholder] as! String).components(separatedBy: "-")
            for stPlaceholder in arrPlaceholder {
                let arrContent: Array<String> = String(stPlaceholder).components(separatedBy: ",")
                var dictContent = typeAliasStringDictionary()
                for stContent in arrContent {
                    if String(stContent).isContainString(RES_min) { let arrValue: Array<String> = String(stContent).components(separatedBy: ":"); dictContent[RES_min] = String(arrValue.last!.trim()) }
                    else if String(stContent).isContainString(RES_max) { let arrValue: Array<String> = String(stContent).components(separatedBy: ":"); dictContent[RES_max] = String(arrValue.last!.trim()) }
                    else if String(stContent).isContainString(RES_type) { let arrValue: Array<String> = String(stContent).components(separatedBy: ":"); dictContent[RES_type] = String(arrValue.last!.trim()) }
                    else { dictContent[RES_placeholder] = String(stContent) }
                }
                arrTextField.append(dictContent)
            }
            
            for view in viewBG.subviews { view.removeFromSuperview() }
            
            var yOrigin: CGFloat = 0
            for i in 0..<arrTextField.count {
                let dict: typeAliasStringDictionary = arrTextField[i]
                let viewContent = CubberTextField.init(frame: CGRect(x: 0, y: yOrigin, width: size.width, height: size.height), dictInfo: dict, tag: i + self.TAG_PLUS)
                viewContent.delegate = self
                viewBG.addSubview(viewContent)
                yOrigin = viewContent.frame.maxY + 8
            }
            constraintHeight.constant = yOrigin - 8
            viewBG.layoutIfNeeded()
        }

        self.dictElectricityBill_SelectedOperator = dictOperator
        self.dictElectricityBill_SelectedRegion = dictRegion
        setDynamicView(self.txtOperator.frame.size, self.txtOperator, self.viewServiceTextFiled, self.constraintviewBGServiceTextField_ElectricityBillHeight)
        
        if !dictRegion.isEmpty {
            for viewBG in self.viewServiceTextFiled.subviews {
                if viewBG.isKind(of: CubberTextField.self) {
                    let _CubberTextField = viewBG as! CubberTextField
                    if _CubberTextField.txtContent.tag - TAG_PLUS == TAG_LANDLINE_REGION {
                        _CubberTextField.txtContent.text = self.dictElectricityBill_SelectedRegion[RES_regionName] as? String
                        _CubberTextField.txtContent.accessibilityLabel = "0"
                    }
                }
            }
        }
        
        for viewBG in self.viewServiceTextFiled.subviews {
            if viewBG.isKind(of: CubberTextField.self) {
                let _CubberTextField = viewBG as! CubberTextField
                if _CubberTextField.txtContent.tag - TAG_PLUS == 0 {
                    if isOrder && dictOperator[RES_mobileNo] != nil
                    {
                        _CubberTextField.txtContent.text = dictOperator[RES_mobileNo]! as? String
                    }
                    else { _CubberTextField.txtContent.becomeFirstResponder() }
                }
                else if _CubberTextField.txtContent.tag - TAG_PLUS == 1 {
                    if isOrder && dictOperator[RES_extra1] != nil {
                        _CubberTextField.txtContent.text = dictOperator[RES_extra1]! as? String
                    }
                }
                else if _CubberTextField.txtContent.tag - TAG_PLUS == 2 {
                    if isOrder && dictOperator[RES_extra2] != nil {
                        _CubberTextField.txtContent.text = dictOperator[RES_extra2]! as? String
                    }
                }
            }
        }
        
        self.resetBillInfo()
    }
    
    fileprivate func setValueInRegionField(_ dictRegion: typeAliasDictionary) {
        self.resetBillInfo()
        self.dictElectricityBill_SelectedRegion = dictRegion
        for viewBG in self.viewServiceTextFiled.subviews {
            if viewBG.isKind(of: CubberTextField.self) {
                let _CubberTextField = viewBG as! CubberTextField
                if _CubberTextField.txtContent.tag - TAG_PLUS == TAG_LANDLINE_REGION {
                    _CubberTextField.txtContent.text = self.dictElectricityBill_SelectedRegion[RES_regionName] as? String
                }
            }
        }
    }
    
    fileprivate func resetBillInfo(){
        
        lblRemark.text = dictOpertaorCategory[RES_remark] as! String == "0" ? "" : dictOpertaorCategory[RES_remark] as! String 
        constraintViewRemarkTopToViewBillInfo.priority = PRIORITY_LOW
        constraintViewRemarkTopToViewServiceTextField.priority = PRIORITY_HIGH
        viewBillInfo.isHidden = true
        viewAmount.isHidden = true
        btnGetBillAmount.isHidden = false
        btnProcess.isHidden = true
        txtAmount.text = ""
        txtAmount.isUserInteractionEnabled = true
        txtAmount.backgroundColor = UIColor.clear
       // self.view.layoutIfNeeded()
    }
    
    fileprivate func setBillInfo(dict:typeAliasDictionary) {
        
        let billId: String = dict[RES_bill_id] as! String
        let billDueDate: String = dict[RES_due_date] as! String
        let billDate:String = dict[RES_bill_date] as! String
        let billAmount: String = dict[RES_bill_amount] as! String
        
        
        if !billId.isEmpty && billId != "0" {
            lblConsumerName.text = billId
            constraintViewBiillInfo_ViewConsumerNameHeight.constant = 30
        }
        else{ constraintViewBiillInfo_ViewConsumerNameHeight.constant = 0}
        
        if !billDueDate.isEmpty && billDueDate != "0" {
            lblBillDueDate.text = billDueDate
            constraintViewBiillInfo_ViewBillDueDateHeight.constant = 30
        }
        else{ constraintViewBiillInfo_ViewBillDueDateHeight.constant = 0}
        
        if !billDate.isEmpty && billDate != "0" {
            lblBillDate.text = billDate
            constraintViewBiillInfo_ViewBillDateHeight.constant = 30
        }
        else{ constraintViewBiillInfo_ViewBillDateHeight.constant = 0}
        
        if !billAmount.isEmpty && Double(billAmount)! != 0 {
            txtAmount.text = billAmount
            txtAmount.isUserInteractionEnabled = false
        }
        else {
            txtAmount.text = ""
            txtAmount.isUserInteractionEnabled = true
        }
        
        constraintViewRemarkTopToViewBillInfo.priority = PRIORITY_HIGH
        constraintViewRemarkTopToViewServiceTextField.priority = PRIORITY_LOW
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { self.view.layoutIfNeeded(); self.btnGetBillAmount.isHidden = true; self.btnProcess.isHidden = false;self.viewBillInfo.isHidden = false; self.viewAmount.isHidden = false }, completion: nil)
        
    }
    
    fileprivate func callGetBillAmountSerivice() {
        
        var number: String = ""
        var topUp: String = "0"
        var special: String = "0"
        
        if self.dictElectricityBill_SelectedOperator.isEmpty {
            _KDAlertView.showMessage(message: MSG_SEL_OPERATOR, messageType: .WARNING)
            return; }
        
        for viewBG in viewServiceTextFiled.subviews {
            if viewBG.isKind(of: CubberTextField.self) {
                let _CubberTextField = viewBG as! CubberTextField
                
                let stContent: String = _CubberTextField.txtContent.text!.trim()
                let stPlaceholder: String = _CubberTextField.txtContent.placeholder!.lowercased() + "."
                if stContent.isEmpty { _KDAlertView.showMessage(message: MSG_TXT + stPlaceholder, messageType: .WARNING);return; }
                else if _CubberTextField.txtContent.accessibilityIdentifier != nil {
                    let stLimit = _CubberTextField.txtContent.accessibilityIdentifier!
                    let arrLimits = stLimit.components(separatedBy: ",")
                    let min: Int = Int(arrLimits[0])!
                    let max = Int(arrLimits[1])!
                    if max > 0 {
                        if !(stContent.characters.count >= min && stContent.characters.count <= max) {_KDAlertView.showMessage(message: MSG_TXT_VALID + stPlaceholder, messageType: .WARNING); return; }
                    }
                    else {
                        if !(stContent.characters.count >= min) {_KDAlertView.showMessage(message: MSG_TXT_VALID + stPlaceholder, messageType: .WARNING); return; }
                    }
                }
                
                if _CubberTextField.txtContent.tag - TAG_PLUS == 0 { number = stContent }
                else if _CubberTextField.txtContent.tag - TAG_PLUS == 1 { topUp = stContent }
                else if _CubberTextField.txtContent.tag - TAG_PLUS == 2 { special = stContent }
            }
        }
        
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_CATEGORY_ID: dictOpertaorCategory[RES_operatorCategoryId] as! String,
                      REQ_SUB_CATEGORY_ID: VAL_RECHARGE_POSTPAID,
                      REQ_OPERATOR_ID: dictElectricityBill_SelectedOperator[RES_operatorID] as! String,
                      REQ_U_MOBILE: number,
                      REQ_AMOUNT: "",
                      REQ_IS_TOPUP: topUp,
                      REQ_IS_SPECIAL: special]
        obj_OperationWeb.callRestApi(methodName: JMETHOD_billAmoutCheck, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
            DataModel.setHeaderToken(dict[RES_token] as! String)
            self.setBillInfo(dict: dict)
           
        }, onFailure: { (code, dict) in
            let message: String = dict[RES_message] as! String
            self._KDAlertView.showMessage(message: message, messageType: .WARNING)
        }) {self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return}
    }

    fileprivate func callGetLatestOrdersService() {
        
        let dicUser  = DataModel.getUserInfo()
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID: dicUser[RES_userID] as! String ,
                      REQ_ORDER_TYPE_ID: VAL_ORDERTYPE_GAS_BILL] as [String : Any]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_GetLatestOrders, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params as! typeAliasStringDictionary, viewActivityParent: .init(), onSuccess: { (dict) in
            DataModel.setHeaderToken(dict[RES_token] as! String)
            self.arrLatestOrders = dict[RES_latest_orders] as! [typeAliasDictionary]
            self.constraintTableViewRecentListHeight.constant = self.tableViewRecentList.rowHeight * CGFloat(self.arrLatestOrders.count)
            self.tableViewRecentList.reloadData()
            self.constraintBtnGetBillAmountBottomToSuper.priority = PRIORITY_LOW
            self.constraintViewRecentBottomToSuper.priority = PRIORITY_HIGH
            self.viewRecentList.isHidden = false
        }, onFailure: { (code, dict) in
            self.viewRecentList.isHidden = true
            self.constraintBtnGetBillAmountBottomToSuper.priority = PRIORITY_HIGH
            self.constraintViewRecentBottomToSuper.priority = PRIORITY_LOW
        }) {self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return}
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
         self.setValueInOperatorField(dictOperator: dictOrder, dictRegion: dictOrder.isKeyNull(RES_region) ? typeAliasDictionary() : dictOrder  , isOrder:true)
    }
    
    
    //MARK: CUBBER TEXTFIELD DELEGATE
    func cubberTextFieldShouldBeginEditing(_ textField: UITextField) {
        
          self.resetBillInfo()
          if textField.tag - TAG_PLUS == TAG_LANDLINE_REGION && textField.accessibilityLabel != nil {
                
                let regionView = RegionView.init(frame: UIScreen.main.bounds, arrRegion: self.dictElectricityBill_SelectedOperator[RES_region] as! [typeAliasDictionary] , title:textField.placeholder!)
                    regionView.delegate  = self
            }
    }
    
    func cubberTextFieldShouldEndEditing(_ textField: UITextField) {
        
    }
    
    func cubberTextFieldShouldReturn(_ textField: UITextField) {
        
    }
    
    func cubberTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) {
        
        let text: String = textField.text!
        let resultingString: String = text.replacingCharacters(in: range.toRange(string: text), with: string)
    }

    
    //MARK: TEXTFIELD DELEGATE
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtOperator {
            self.hideKeyboard()
            let operatorView:OperatorView = OperatorView.init(frame: UIScreen.main.bounds, categoryID: HOME_CATEGORY_TYPE.GAS.rawValue)
            operatorView.delegate = self
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text: String = textField.text!
        let resultingString: String = text.replacingCharacters(in: range.toRange(string: text), with: string)
        
        
     /*   if resultingString.characters.isEmpty
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
            if RET { if resultingString.characters.count  == 10 { self.callSearchMobileOperatorService(resultingString) } }
            if resultingString.characters.count > 10 { return false }
            return RET
        }
            
        else if textField == txtAmont
        {
            var holder: Float = 0.00
            let scan: Scanner = Scanner(string: resultingString)
            let RET: Bool = scan.scanFloat(&holder) && scan.isAtEnd
            let text = textField.text?.trim()
            if string == "." { return false }
            if text?.characters.count == 0 && string == "0"{return false}
            if resultingString.characters.count > 4 { return false }
            self.dictMobileRecharge_SelectedPlan = typeAliasDictionary()
            return RET
        }*/
        
        return true
    }
    
    //MARK: REGIONVIEW DELEGATE
    func onRegionView_Selection(_ dictRegion: typeAliasDictionary) {
        self.setValueInRegionField(dictRegion)
    }

    
    
    //MARK: OPERATORLIOST DELEGATE
    func onOperatorView_Selection(_ dictOperator: typeAliasDictionary, dictRegion: typeAliasDictionary) {
        self.setValueInOperatorField(dictOperator: dictOperator, dictRegion: dictRegion ,isOrder:false)
    }
    
}
