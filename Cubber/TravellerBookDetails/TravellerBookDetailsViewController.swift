//
//  TravellerBookDetailsViewController.swift
//  Cubber
//
//  Created by dnk on 13/11/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class TravellerBookDetailsViewController: UIViewController,AppNavigationControllerDelegate, UITableViewDelegate , UITableViewDataSource , TravellerDetailViewDelegate , UITextFieldDelegate {
    
    //MARK: PROPERTIES
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var tableViewTraveller: UITableView!
    @IBOutlet var txtTravellerMobileNo: UITextField!
    @IBOutlet var txtTravellerOptionalMobileNo: UITextField!
    @IBOutlet var txtTravellerEmailID: UITextField!
    
    @IBOutlet var txtAddress: FloatLabelTextField!
    @IBOutlet var lblTotalAmount: UILabel!
    @IBOutlet var lblBookAmount: UILabel!
    @IBOutlet var lblVisaNote: UILabel!
    @IBOutlet var btnCheckBoxTermsAndCond: UIButton!
    
    @IBOutlet var constraintTableViewTravellerHeight: NSLayoutConstraint!
    @IBOutlet var constraintTableViewAmountListHeight: NSLayoutConstraint!
    
    @IBOutlet var tableViewAmountList: UITableView!
    @IBOutlet var lblSessionTimer: UILabel!
    
    
    internal var dictFlight = typeAliasDictionary()
    internal var arrAirlinesList = [typeAliasDictionary]()
    internal var arrAirportList = [typeAliasDictionary]()
    internal var depDate = Date()
    internal var returnDate = Date()
    internal var isRoundTrip:Bool = false
    internal var dictDestination = typeAliasDictionary()
    internal var dictSource = typeAliasDictionary()
    internal var noOfAdults = 1
    internal var noOfChild = 0
    internal var noOfInfants = 0
    internal var dictClass = typeAliasDictionary()
    internal var fareDetail = typeAliasDictionary()
    internal var arrAmountList = [typeAliasDictionary]()
    internal var visaNote:String = ""
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var _VKDatePopOver = VKDatePopOver()
    fileprivate var _KDAlertView = KDAlertView()
    internal var arrTravellerList = [typeAliasStringDictionary]()
    fileprivate var timer = Timer()
    fileprivate var secondCounter:Int = 600
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.arrAmountList = fareDetail[RES_amountArrayList] as! [typeAliasDictionary]
        self.tableViewTraveller.register(UINib.init(nibName: CELL_IDENTIFIER_TRAVELLER_DETAIL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_TRAVELLER_DETAIL)
        self.tableViewTraveller.rowHeight = 45
        self.tableViewAmountList.rowHeight = 30
        self.tableViewAmountList.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewAmountList.separatorColor = RGBCOLOR(170, g: 170, b: 170)
        self.tableViewAmountList.register(UINib.init(nibName: CELL_IDENTIFIER_ORDER_DETAIL_SUMMARY_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_ORDER_DETAIL_SUMMARY_CELL)
        timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        self.setTravellerArray()
        self.setContactDetail()
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
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.SetScreenName(name: F_FLIGHT_PASSENGERDETAIL, stclass: F_MODULE_FLIGHT)
        self.sendScreenView(name: F_FLIGHT_PASSENGERDETAIL)
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
    
    //MARK: NAVIGATION METHODS
    func setNavigationBar() {
        obj_AppDelegate.navigationController.setCustomTitle("Traveller Details")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func hideKeyboard() {
        txtTravellerMobileNo.resignFirstResponder()
        txtTravellerOptionalMobileNo.resignFirstResponder()
        txtTravellerEmailID.resignFirstResponder()
    }
  
    //MARK: BUTTON METHODS
    
    @IBAction func btnTermsAndConditionAction() {
        let _ = TermsAndCondView.init(typeAliasDictionary() , isSignUP:true, isPrivacyPolicy:false)
    }
    
    @IBAction func btnAgreeCubberAction() {
        btnCheckBoxTermsAndCond.isSelected = !btnCheckBoxTermsAndCond.isSelected
    }

    @IBAction func btnBookTicketsAction() {
                  
        for dict in arrTravellerList {
            if dict[TRAVELLER_F_NAME]! ==
                "" {
                _KDAlertView.showMessage(message: "Enter traveller details.", messageType: .WARNING)
                return
            }
        }
        
        let stMobileNo:String = (txtTravellerMobileNo.text?.trim())!
        let stAlterMobileNo:String = (txtTravellerOptionalMobileNo.text?.trim())!
        let stEmailID:String = (txtTravellerEmailID.text?.trim())!
        let stAddress:String = (txtAddress.text?.trim())!
        
        if stMobileNo.isEmpty {
            _KDAlertView.showMessage(message: "Enter mobile no.", messageType: .WARNING)
            return
        }
        else if !DataModel.validateMobileNo(stMobileNo) {
            _KDAlertView.showMessage(message: "Enter valid mobile no.", messageType: .WARNING)
            return
        }
        if stAlterMobileNo.isEmpty {
            _KDAlertView.showMessage(message: "Enter alternate mobile no.", messageType: .WARNING)
            return
        }
        else if !DataModel.validateMobileNo(stAlterMobileNo) {
            _KDAlertView.showMessage(message: "Enter valid alternate mobile no.", messageType: .WARNING)
            return
        }
        else if stMobileNo == stAlterMobileNo {
            _KDAlertView.showMessage(message: "Mobile Number and alternate mobile Number can`t be same.", messageType: .WARNING)
            return
        }
        if stEmailID.isEmpty {
            _KDAlertView.showMessage(message: "Enter email id.", messageType: .WARNING)
            return
        }
        else if !DataModel.validateEmail(stEmailID) {
            _KDAlertView.showMessage(message: MSG_TXT_EMAIL_VALID, messageType: .WARNING)
            return
        }
        if stAddress.isEmpty {
            _KDAlertView.showMessage(message: "Enter Address.", messageType: .WARNING)
            return
        }
        if !btnCheckBoxTermsAndCond.isSelected {
            _KDAlertView.showMessage(message: MSG_SEL_TERMS_CONDITIONS, messageType: .WARNING)
            return
        }
       
        var isPaidFees:Bool = false
        if DataModel.getUserWalletResponse()[RES_isPayMemberShipFee] as! String == "1"{
            isPaidFees = true;
        }
        else{
            if obj_AppDelegate.isMemberShipFeesPaid() { isPaidFees = true; }
            else { isPaidFees = false }
        }
        
        if isPaidFees {
            
            var subTotal:String = "0"
            var totalServiceTax:Double = 0.00
            var convinienceFee:String = "0"
            for dict in arrAmountList{
                if dict[RES_Name] as! String == "baseFare" {
                    subTotal = dict[RES_value] as! String
                }
                else if dict[RES_Name] as! String == "surcharge" {
                    totalServiceTax += Double(dict[RES_value] as! String)!
                }
                else if dict[RES_Name] as! String == "taxesAndFees" {
                    totalServiceTax += Double(dict[RES_value] as! String)!
                }
                else if dict[RES_Name] as! String == "meals" {
                    totalServiceTax += Double(dict[RES_value] as! String)!
                }
                else if dict[RES_Name] as! String == "convenienceFees" {
                    convinienceFee = dict[RES_value] as! String
                }
            }
            
            
            let rechargeVC = RechargeViewController(nibName: "RechargeViewController", bundle: nil)
            rechargeVC.cart_subTotal = subTotal
            rechargeVC.cart_totalServiceTax = String(totalServiceTax)
            rechargeVC.cart_CouponCode = "0"
            rechargeVC.cart_CategoryId = "18"
            rechargeVC.cart_RegionId = self.dictSource[RES_regionID] as! String
            rechargeVC.cart_PlanTypeID = self.dictDestination[RES_regionID] as! String
            rechargeVC.cart_DiscountAmount = "0"
            rechargeVC.cart_TotalAmount = fareDetail[RES_TotalAmount] as! String
            rechargeVC.cart_walletUsed = "0"
            rechargeVC.cart_CashBackAmount = "0"
            rechargeVC.cart_CouponMessage = ""
            rechargeVC.cart_couponID = "0"
            rechargeVC._RECHARGE_TYPE = RECHARGE_TYPE.FLIGHT_BOOKING
            rechargeVC.cart_Email = stEmailID
            rechargeVC.cart_MobileNo = stAlterMobileNo
            rechargeVC.cart_totalPassengers = "\(self.arrTravellerList.count)"
            rechargeVC.dictFlight = self.dictFlight
            rechargeVC.arrTravellerList = self.arrTravellerList
            rechargeVC.flightConvinienceFees = convinienceFee
            rechargeVC.passengerAddress = stAddress
            rechargeVC.primaryMobileNo = stMobileNo
            let dictOneWay = dictFlight[RES_OneWay] as! typeAliasDictionary
            var arr = fareDetail[RES_flightArray] as! [typeAliasDictionary]
            var dictFl = arr.first
            let arrOprator = dictFl?[RES_operatorList] as! [typeAliasDictionary]
            rechargeVC.cart_OperatorId = arrOprator.first?[RES_operatorID] as! String
            rechargeVC.flightOperatorName = arrOprator.first?[RES_AirlineName] as! String
           // dictFl?[RES_operatorList] = nil
            arr[0] = dictFl!
            fareDetail[RES_flightArray] = arr as AnyObject?
            rechargeVC.cart_Extra1 = dictOneWay[RES_TrackNo] as! String
            rechargeVC.cart_SubCategory = dictClass[RES_categoryCode] as! String
            rechargeVC.dicFareDetails = fareDetail
            rechargeVC.isInternational = dictSource[RES_countryID] as! String != dictDestination[RES_countryID] as! String ? "1" : "0"
            rechargeVC.dictSource = self.dictSource
            rechargeVC.dictDest = self.dictDestination
            rechargeVC.stImageUrl = dictOneWay[RES_image] as! String

            //GTM CHECKOUT STEP 1
            let _gtmModel = GTMModel()
            _gtmModel.ee_type = GTM_FLIGHT
            _gtmModel.name = rechargeVC.flightOperatorName
            _gtmModel.price =  rechargeVC.cart_subTotal
            _gtmModel.product_Id = arrOprator.first?[RES_AirlineCode] as! String
            _gtmModel.brand = rechargeVC.flightOperatorName
            _gtmModel.category = GTM_FLIGHT
            _gtmModel.variant =  rechargeVC.cart_Extra1
            _gtmModel.option = "Passenger Details"
            _gtmModel.step = 1
            _gtmModel.quantity = self.arrTravellerList.count
            _gtmModel.dimension5 = "\(self.dictSource[RES_regionName] as! String) : \(dictDestination[RES_regionName] as! String)"
            _gtmModel.dimension6 = dictOneWay[RES_DepDate] as! String
            GTMModel.pushCheckoutBus(gtmModel: _gtmModel)
            
            //GTM CHECKOUT STEP 2
            _gtmModel.step = 2
            _gtmModel.option = "Confirm Details"
            GTMModel.pushCheckoutBus(gtmModel: _gtmModel)
                    
            self.navigationController?.pushViewController(rechargeVC, animated: true)        }
            
        else{
            _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .WARNING)
        }
        
    }
    
    //MARK: CUSTOM METHODS
    func setTravellerArray(){

        var dictTraveller:typeAliasStringDictionary = [TRAVELLER_F_NAME:"",
                                                       TRAVELLER_L_NAME:"",
                                                       TRAVELLER_M_NAME:"",
                                                       TRAVELLER_DOB:"",
                                                       TRAVELLER_PASSPORT_NO:"",
                                                       TRAVELLER_VISA_TYPE:"",
                                                       TRAVELLER_PASSPORT_COUNTRY:"",
                                                       TRAVELLER_PASSPORT_EXPIRE_DATE:"",
                                                       TRAVELLER_NATIONALITY:"",
                                                       TRAVELLER_FF_NO:"",
                                                       TRAVELLER_FF_AIRLINE:"",
                                                       TRAVELLER_TITLE:"",
                                                       TRAVELLER_TYPE:"",
                                                       TRAVELLER_NATIONALITY_CODE:"0",
                                                       TRAVELLER_PASSPORT_COUNTRY_CODE:"0",
                                                       TRAVELLER_VISA_TYPE_CODE:"0",
                                                       TRAVELLER_SEQ_NO:"0",
                                                       TRAVELLER_FF_AIRLINE_CODE:"0"]
        for i in 0..<noOfAdults {
            dictTraveller[TRAVELLER_TYPE] = "Adult \(i+1)"
            dictTraveller[TRAVELLER_SEQ_NO] = "\(i+1)"
            dictTraveller[TRAVELLER_CATEGORY_ID] = "1"
            arrTravellerList.append(dictTraveller)
        }
        for i in 0..<noOfChild {
            dictTraveller[TRAVELLER_TYPE] = "Child \(i+1)"
            dictTraveller[TRAVELLER_SEQ_NO] = "\(noOfAdults+i+1)"
            dictTraveller[TRAVELLER_CATEGORY_ID] = "2"
            arrTravellerList.append(dictTraveller)
        }
        for i in 0..<noOfInfants {
            dictTraveller[TRAVELLER_TYPE] = "Infant \(i+1)"
            dictTraveller[TRAVELLER_SEQ_NO] = "\(noOfAdults+noOfChild+i+1)"
            dictTraveller[TRAVELLER_CATEGORY_ID] = "3"
            arrTravellerList.append(dictTraveller)
        }
    }
    
    func setContactDetail() {
        
        let userInfo = DataModel.getUserInfo()
        self.txtTravellerMobileNo.text = userInfo[RES_userMobileNo]! as? String
        self.txtTravellerEmailID.text = userInfo[RES_userEmailId] as! String?
        self.constraintTableViewTravellerHeight.constant = self.tableViewTraveller.rowHeight * CGFloat(noOfInfants+noOfChild+noOfAdults)
        self.constraintTableViewAmountListHeight.constant = self.tableViewAmountList.rowHeight * CGFloat(arrAmountList.count)
        self.tableViewTraveller.layoutIfNeeded()
        self.tableViewAmountList.layoutIfNeeded()
        self.tableViewTraveller.reloadData()
        self.tableViewAmountList.reloadData()
        self.lblTotalAmount.text = (fareDetail[RES_TotalAmount] as! String).setThousandSeperator(decimal: 2)
        self.lblBookAmount.text = self.lblTotalAmount.text
        self.lblVisaNote.attributedText = visaNote.htmlAttributedString
       
    }
    
    func updateCounter() {
    
        secondCounter -= 1
        if secondCounter == 0  {
            self.appNavigationController_BackAction()
        }
        var minutes = String(secondCounter / 60)
        var seconds = String(secondCounter % 60)
        if minutes.characters.count == 1 {
            minutes  = "0\(minutes)"
        }
        if seconds.characters.count == 1 {
            seconds  = "0\(seconds)"
        }
        self.lblSessionTimer.text = "Your Session will expire in  \(minutes):\(seconds)"
    }
    
    //MARK: TABLEVEW DELEGATE
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableView == tableViewAmountList ? arrAmountList.count : arrTravellerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == tableViewAmountList {
            
            let cell : OrderDetailSummaryCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_ORDER_DETAIL_SUMMARY_CELL) as! OrderDetailSummaryCell
            let dict = arrAmountList[indexPath.row]
            cell.lblName.text = dict[RES_displayName]! as? String
            cell.lblValue.text = (dict[RES_value] as! String).setThousandSeperator(decimal: 2)
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell

        }
        else {
        let cell:TravellerDetailCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_TRAVELLER_DETAIL) as! TravellerDetailCell
        let dictTraveller = arrTravellerList[indexPath.row]
        cell.txtTravellerName.placeholder = dictTraveller[TRAVELLER_TYPE]!
        cell.txtTravellerName.text = ""
        var stName = ""
        stName = dictTraveller[TRAVELLER_F_NAME]! == "" ? dictTraveller[TRAVELLER_TYPE]! : stName
        
        if dictTraveller[TRAVELLER_TITLE]! != "" {
            stName += dictTraveller[TRAVELLER_TITLE]!
        }
        if dictTraveller[TRAVELLER_F_NAME]! != "" {
            stName += " \(dictTraveller[TRAVELLER_F_NAME]!)"
        }
        if dictTraveller[TRAVELLER_F_NAME]! != "" {
            stName += " \(dictTraveller[TRAVELLER_M_NAME]!)"
        }
        if dictTraveller[TRAVELLER_L_NAME]! != "" {
            stName += " \(dictTraveller[TRAVELLER_L_NAME]!)"
        }
        
        if stName !=  cell.txtTravellerName.placeholder {
            cell.txtTravellerName.text = stName
        }
        if dictTraveller[TRAVELLER_TYPE]!.isContainString("Adult"){
            cell.iconTraveller.image = #imageLiteral(resourceName: "ic_adult")
        }
        else if dictTraveller[TRAVELLER_TYPE]!.isContainString("Child"){
            cell.iconTraveller.image = #imageLiteral(resourceName: "ic_child")
        }
        else if dictTraveller[TRAVELLER_TYPE]!.isContainString("Infant"){
            cell.iconTraveller.image = #imageLiteral(resourceName: "ic_infant")
        }
        cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let travellerDetailVC = TravellerDetailsViewController(nibName: "TravellerDetailsViewController", bundle: nil)
        travellerDetailVC.arrTravellerList = self.arrTravellerList
        travellerDetailVC.arrAirlineList = self.arrAirlinesList
        travellerDetailVC.index = indexPath.row
        if dictSource[RES_countryID] as! String != dictDestination[RES_countryID] as! String {
         travellerDetailVC.isInternational = true
        }
        else { travellerDetailVC.isInternational = false}
        travellerDetailVC.delegate = self
        travellerDetailVC.depDate = self.depDate
        self.navigationController?.pushViewController(travellerDetailVC, animated: true)
    }
    
    
    //MARK: TRAVELLER_DETAIL DELEGATE
    func TravellerDetailViewDelegate_TravellerList(arrTraveller: [typeAliasStringDictionary]) {
        self.arrTravellerList = arrTraveller
        self.tableViewTraveller.reloadData()
    }
    
    //MARK : TEXTFIELD DELAGATE
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideKeyboard()
        if textField == txtTravellerMobileNo { txtTravellerOptionalMobileNo.becomeFirstResponder() }
        else if textField == txtTravellerOptionalMobileNo { txtTravellerEmailID.becomeFirstResponder() }
        else if textField == txtTravellerEmailID { txtAddress.becomeFirstResponder() }
         else if textField == txtAddress { txtAddress.resignFirstResponder()}
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text: String = textField.text!
        let resultingString: String = text.replacingCharacters(in: range.toRange(string: text), with: string)
        
        if resultingString.isEmpty
        {
            if textField == txtTravellerMobileNo ||  textField == txtTravellerOptionalMobileNo {
            }
            return true
        }

        
        if textField == txtTravellerMobileNo ||  textField == txtTravellerOptionalMobileNo {
            var holder: Float = 0.00
            let scan: Scanner = Scanner(string: resultingString)
            let RET: Bool = scan.scanFloat(&holder) && scan.isAtEnd
            if string == "." { return false }
            if RET { if resultingString.count  == 10 { } }
            if resultingString.count > 10 { return false }
            return RET
        }
        return true
    }
}
