//
//  TravellerDetailsViewController.swift
//  Cubber
//
//  Created by dnk on 10/11/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

protocol TravellerDetailViewDelegate {
    func TravellerDetailViewDelegate_TravellerList(arrTraveller:[typeAliasStringDictionary])
}

class TravellerDetailsViewController: UIViewController, AppNavigationControllerDelegate, VKDatePopoverDelegate {

    //MARK:PROPERTIES
    
    @IBOutlet var viewTitleChildren: UIView!
    
    @IBOutlet var viewTitleAdult: UIView!
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtMiddleName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var txtDateofBirth: UITextField!
    @IBOutlet var txtPassportNumber: UITextField!
    @IBOutlet var txtVisaType: UITextField!
    @IBOutlet var txtPassportCounrty: UITextField!
    @IBOutlet var txtExpireDate: UITextField!
    @IBOutlet var txtPassengerNationality: UITextField!
    @IBOutlet var txtFlayerFFNumber: UITextField!
    @IBOutlet var txtFlayerAirlines: UITextField!
    @IBOutlet var btnFrequentFlayer: UIButton!
    @IBOutlet var btnPrefixCollection: [UIButton]!
    @IBOutlet var btnPrefixChildCollection: [UIButton]!
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewVisaDetail: UIView!
    @IBOutlet var viewFlayerDetail: UIView!
    @IBOutlet var constraintBtnFrequentFlayerTopToViewVisaDetail: NSLayoutConstraint!
    @IBOutlet var constraintBtnFrequentFlayerTopToViewDateofBirth: NSLayoutConstraint!
    @IBOutlet var constraintBtnFrequentFlayerBottomToSuperView: NSLayoutConstraint!
    @IBOutlet var constraintViewFlayerDetailToSuperView: NSLayoutConstraint!
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var _VKDatePopOver = VKDatePopOver()
    fileprivate var _KDAlertView = KDAlertView()
    
    var delegate:TravellerDetailViewDelegate? = nil
    var arrVisaType = [typeAliasDictionary]()
    var arrCountry = [typeAliasDictionary]()
    var txtDate:UITextField = UITextField()
    var stCountryId: String = "0"
    var stVisaTypeId: String = "0"
    var stPassportCountryId: String = "0"
    var stAirlineCode: String = "0"
    var dictSelectedCountry = typeAliasDictionary()
    var dictSelectedVisa = typeAliasDictionary()
    
    internal var arrTravellerList = [typeAliasStringDictionary]()
    internal var arrAirlineList = [typeAliasDictionary]()
    var dictTraveller = typeAliasStringDictionary()
    
    internal var index = 0
    internal var isInternational:Bool = false
    internal var depDate:Date?
    fileprivate var dob = Date()
    fileprivate var expireDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnFrequentFlayer.isSelected = false
        constraintViewFlayerDetailToSuperView.priority = PRIORITY_LOW
        constraintBtnFrequentFlayerBottomToSuperView.priority = PRIORITY_HIGH
        if isInternational { self.callGetVisaTypeList() }
        self.setTravellerDetail()
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
        self.SetScreenName(name: F_FLIGHT_ADD_PASSENGER, stclass: F_MODULE_FLIGHT)
        self.sendScreenView(name: F_FLIGHT_ADD_PASSENGER)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
    
    func setNavigationBar() {
        
        obj_AppDelegate.navigationController.setCustomTitle("Add Traveller")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func hideKeyboard() {
        txtFirstName.resignFirstResponder()
        txtMiddleName.resignFirstResponder()
        txtLastName.resignFirstResponder()
        txtDateofBirth.resignFirstResponder()
        txtPassportNumber.resignFirstResponder()
        txtVisaType.resignFirstResponder()
        txtPassportCounrty.resignFirstResponder()
        txtExpireDate.resignFirstResponder()
        txtPassengerNationality.resignFirstResponder()
        txtFlayerFFNumber.resignFirstResponder()
        txtFlayerAirlines.resignFirstResponder()
    }

    @IBAction func btnFrequentFlayerAction() {
        btnFrequentFlayer.isSelected = !btnFrequentFlayer.isSelected
        if btnFrequentFlayer.isSelected {
            constraintViewFlayerDetailToSuperView.priority = PRIORITY_HIGH
            constraintBtnFrequentFlayerBottomToSuperView.priority = PRIORITY_LOW
            viewFlayerDetail.isHidden = false
            txtFlayerFFNumber.becomeFirstResponder()
            UIView.animate(withDuration: 0.5, delay: 0.1, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        else{
            constraintViewFlayerDetailToSuperView.priority = PRIORITY_LOW
            constraintBtnFrequentFlayerBottomToSuperView.priority = PRIORITY_HIGH
            self.hideKeyboard()
            viewFlayerDetail.isHidden = true
            UIView.animate(withDuration: 0.5, delay: 0.1, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    @IBAction func btnAddTravellerAction() {
        
        var stTitle:String = ""
        for btn in btnPrefixCollection {
            if btn.isSelected {
                stTitle = btn.title(for: .normal)!
                break
            }
        }
        let stFirstName:String = (txtFirstName.text?.trim())!
        let stMiddleName:String = (txtMiddleName.text?.trim())!
        let stLastName:String = (txtLastName.text?.trim())!
        let stDob:String = (txtDateofBirth.text?.trim())!
        let stPassportNumber:String = (txtPassportNumber.text?.trim())!
        let stPassportCountry:String = (txtPassportCounrty.text?.trim())!
        let stVisaType:String = (txtVisaType.text?.trim())!
        let stNationality:String = (txtPassengerNationality.text?.trim())!
        let stFFNumber = (txtFlayerFFNumber.text?.trim())!
        let stFFAirline = (txtFlayerAirlines.text?.trim())!
        let stExpireDate = (txtExpireDate.text?.trim())!
        
        if stTitle.isEmpty{
            _KDAlertView.showMessage(message: "Select title.", messageType: MESSAGE_TYPE.WARNING)
            return
        }
        
        if stFirstName.isEmpty{
            _KDAlertView.showMessage(message: MSG_TXT_FIRST_NAME, messageType: MESSAGE_TYPE.WARNING)
            return
        }
        if stLastName.isEmpty{
            _KDAlertView.showMessage(message: MSG_TXT_LAST_NAME, messageType: MESSAGE_TYPE.WARNING)
            return
        }
        if stDob.isEmpty{
            _KDAlertView.showMessage(message: MSG_TXT_DOB, messageType: MESSAGE_TYPE.WARNING)
            return
        }
        else {
            
            let age:Int = Calendar.current.dateComponents([.year], from: dob, to: Date()).year!
            if dictTraveller[TRAVELLER_TYPE]!.contains("Adult") && age  < 12 {
                _KDAlertView.showMessage(message: "Adult should be at least 12 years old.", messageType: MESSAGE_TYPE.WARNING)
                return
            }
            else if dictTraveller[TRAVELLER_TYPE]!.contains("Child") && ( age
                >= 12 || age < 2 ){
                _KDAlertView.showMessage(message: "Child should be between 2-12 years. ", messageType: MESSAGE_TYPE.WARNING)
                return
            }
            else if dictTraveller[TRAVELLER_TYPE]!.contains("Infant") && age > 2 {
                _KDAlertView.showMessage(message: "Infant can not be more than 2 years. ", messageType: MESSAGE_TYPE.WARNING)
                return
            }
            
        }
        
        if isInternational {
                        
            if stPassportNumber.isEmpty{
                _KDAlertView.showMessage(message: MSG_TXT_PASSPORT_NUMBER, messageType: MESSAGE_TYPE.WARNING)
                return
            }
            else if !stPassportNumber.isAlphanumeric {
                _KDAlertView.showMessage(message: MSG_TXT_VALID_PASSPORT_NUMBER, messageType: MESSAGE_TYPE.WARNING)
                return
            }
            
            if stVisaType.isEmpty || stVisaType == "0" {
                _KDAlertView.showMessage(message: MSG_TXT_VISA_TYPE, messageType: .WARNING)
            }
            
            if stPassportCountry.isEmpty{
                _KDAlertView.showMessage(message: MSG_TXT_PASSPORT_COUNTRY, messageType: MESSAGE_TYPE.WARNING)
                return
            }
            if stExpireDate.isEmpty{
                _KDAlertView.showMessage(message: MSG_TXT_PASSPORT_EXPIRE_DATE, messageType: MESSAGE_TYPE.WARNING)
                return
            }
            else {
                if depDate != nil && Calendar.current.compare(depDate!, to: expireDate, toGranularity: .day) != .orderedAscending {
                    _KDAlertView.showMessage(message: "Passport Expire date can`t be earlier than journey date.", messageType: MESSAGE_TYPE.WARNING)
                    return
                }
            }
            if stNationality.isEmpty {
                _KDAlertView.showMessage(message: "Select Nationality.", messageType: MESSAGE_TYPE.WARNING)
                return
            }
        }
        
        if !viewFlayerDetail.isHidden {
            if stFFNumber.isEmpty {
                _KDAlertView.showMessage(message: "Enter Frequent Flayer Number.", messageType: MESSAGE_TYPE.WARNING)
                return
            }
            else if !stFFNumber.isAlphanumeric {
                _KDAlertView.showMessage(message: "Enter valid Frequent Flayer Number.", messageType: MESSAGE_TYPE.WARNING)
                return
            }
            else if stAirlineCode.isEmpty || stAirlineCode == "0" {
                _KDAlertView.showMessage(message: "Select Airline.", messageType: MESSAGE_TYPE.WARNING)
                return
            }
        }
        
        dictTraveller[TRAVELLER_F_NAME] = stFirstName
        dictTraveller[TRAVELLER_M_NAME] = stMiddleName
        dictTraveller[TRAVELLER_L_NAME] = stLastName
        dictTraveller[TRAVELLER_DOB] = stDob
        dictTraveller[TRAVELLER_PASSPORT_NO] = stPassportNumber
        dictTraveller[TRAVELLER_PASSPORT_COUNTRY] = stPassportCountry
        dictTraveller[TRAVELLER_VISA_TYPE] = stVisaType
        dictTraveller[TRAVELLER_NATIONALITY] = stNationality
        dictTraveller[TRAVELLER_PASSPORT_EXPIRE_DATE] = stExpireDate
        dictTraveller[TRAVELLER_FF_NO] = stFFNumber
        dictTraveller[TRAVELLER_FF_AIRLINE] = stFFAirline
        dictTraveller[TRAVELLER_TITLE] = stTitle
        dictTraveller[TRAVELLER_TITLE_CODE] = stTitle == "Master" ? "Mr." : stTitle
        dictTraveller[TRAVELLER_NATIONALITY_CODE] = self.stCountryId
        dictTraveller[TRAVELLER_PASSPORT_COUNTRY_CODE] = self.stPassportCountryId
        dictTraveller[TRAVELLER_VISA_TYPE_CODE] = self.stVisaTypeId
        dictTraveller[TRAVELLER_FF_AIRLINE_CODE] = stAirlineCode
        arrTravellerList[index] = dictTraveller
        
        self.delegate?.TravellerDetailViewDelegate_TravellerList(arrTraveller: self.arrTravellerList)
        self.appNavigationController_BackAction()
    }
    
    @IBAction func btnPrefixAction(_ sender: UIButton) {
        for btn:UIButton in btnPrefixCollection {
            btn.isSelected = !btn.isSelected
            if sender.tag == btn.tag {
                btn.isSelected = true
            }
            else{
                btn.isSelected = false
            }
        }
    }
    
    func setTravellerDetail(){
        
        if isInternational {
            self.constraintBtnFrequentFlayerTopToViewVisaDetail.priority = PRIORITY_HIGH
            self.constraintBtnFrequentFlayerTopToViewDateofBirth.priority = PRIORITY_LOW
            self.viewVisaDetail.isHidden = false
        }
        else {
            self.constraintBtnFrequentFlayerTopToViewVisaDetail.priority = PRIORITY_LOW
            self.constraintBtnFrequentFlayerTopToViewDateofBirth.priority = PRIORITY_HIGH
            self.viewVisaDetail.isHidden = true
        }
        
        self.view.layoutIfNeeded()
        dictTraveller = arrTravellerList[index]
        if (dictTraveller[TRAVELLER_TYPE]!.contains("Adult")){
            viewTitleAdult.isHidden = false
            viewTitleChildren.isHidden = true
            if dictTraveller[TRAVELLER_TITLE] == "Mr."{
                for btn in btnPrefixCollection {
                    if btn.tag == 0 {self.btnPrefixAction(btn);break}
                }
            }
            else if dictTraveller[TRAVELLER_TITLE] == "Mrs."{
                for btn in btnPrefixCollection {
                    if btn.tag == 1 {self.btnPrefixAction(btn);break}
                }
            }
            else if dictTraveller[TRAVELLER_TITLE] == "Miss."{
                for btn in btnPrefixCollection {
                    if btn.tag == 2 {self.btnPrefixAction(btn);break}
                }
            }
        }
        else {
            viewTitleAdult.isHidden = true
            viewTitleChildren.isHidden = false
            if dictTraveller[TRAVELLER_TITLE] == "Master" {
                for btn in btnPrefixCollection {
                    if btn.tag == 3 {self.btnPrefixAction(btn);break}
                }
            }
            else if dictTraveller[TRAVELLER_TITLE] == "Miss."{
                for btn in btnPrefixCollection {
                    if btn.tag == 4 {self.btnPrefixAction(btn);break}
                }
            }
        }
        txtFirstName.text           = dictTraveller[TRAVELLER_F_NAME]!
        txtMiddleName.text          = dictTraveller[TRAVELLER_M_NAME]!
        txtLastName.text            = dictTraveller[TRAVELLER_L_NAME]!
        txtDateofBirth.text         = dictTraveller[TRAVELLER_DOB]!
        if dictTraveller[TRAVELLER_DOB] != "" {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            dob =  dateFormat.date(from: dictTraveller[TRAVELLER_DOB]!)!
        }
        if isInternational {
            txtPassportNumber.text  = dictTraveller[TRAVELLER_PASSPORT_NO]!
            txtPassportCounrty.text = dictTraveller[TRAVELLER_PASSPORT_COUNTRY]!
            txtVisaType.text        = dictTraveller[TRAVELLER_VISA_TYPE]!
            txtPassengerNationality.text = dictTraveller[TRAVELLER_NATIONALITY]!
            txtExpireDate.text      = dictTraveller[TRAVELLER_PASSPORT_EXPIRE_DATE]!
            stCountryId = dictTraveller[TRAVELLER_NATIONALITY_CODE]!
            stPassportCountryId = dictTraveller[TRAVELLER_PASSPORT_COUNTRY_CODE]!
            stVisaTypeId = dictTraveller[TRAVELLER_VISA_TYPE_CODE]!
            if dictTraveller[TRAVELLER_PASSPORT_EXPIRE_DATE] != "" {
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd"
                expireDate =  dateFormat.date(from: dictTraveller[TRAVELLER_PASSPORT_EXPIRE_DATE]!)!
            }
        }
        txtFlayerFFNumber.text      = dictTraveller[TRAVELLER_FF_NO]!
        txtFlayerAirlines.text      = dictTraveller[TRAVELLER_FF_AIRLINE]!
        self.stAirlineCode = dictTraveller[TRAVELLER_FF_AIRLINE_CODE]!
        
        if dictTraveller[TRAVELLER_FF_NO] == "" && dictTraveller[TRAVELLER_FF_AIRLINE] == ""{
            self.viewFlayerDetail.isHidden = true
            constraintViewFlayerDetailToSuperView.priority = PRIORITY_LOW
            constraintBtnFrequentFlayerBottomToSuperView.priority = PRIORITY_HIGH
        }
        else{
            self.viewFlayerDetail.isHidden = false
            constraintViewFlayerDetailToSuperView.priority = PRIORITY_HIGH
            constraintBtnFrequentFlayerBottomToSuperView.priority = PRIORITY_LOW
        }
    }
    
    func callGetCountryList(){
        
        let userInfo: typeAliasDictionary = DataModel.getUserInfo()
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID: userInfo[RES_userID] as! String ]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_GetCountryList, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
            DataModel.setHeaderToken(dict[RES_token] as! String)
            self.arrCountry = dict[RES_countryList] as! [typeAliasDictionary]
            
        }, onFailure: { (code, dict) in
            
        }) { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return }
    }
    
    fileprivate func callGetVisaTypeList() {
        
        let userInfo: typeAliasDictionary = DataModel.getUserInfo()
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID: userInfo[RES_userID] as! String ]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_GetVisaTypeList, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
            DataModel.setHeaderToken(dict[RES_token] as! String)
            self.callGetCountryList()
            self.arrVisaType = dict[RES_visaTypeList] as! [typeAliasDictionary]
            
        }, onFailure: { (code, dict) in
            
        }) { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtPassportCounrty  {
            self.hideKeyboard()
            let dkSelection:DKSelectionView = DKSelectionView.init(frame: UIScreen.main.bounds, arrRegion: arrCountry, title: "Country", dictKey: [VK_UNIQUE_KEY:RES_countryID,VK_VALUE_KEY:RES_countryName], isSearch:true, isImage:false)
             dkSelection.didSelecteOption(completion: { (dictOption) in
                if !dictOption.isEmpty {
                    self.dictSelectedCountry = dictOption
                    self.txtPassportCounrty.text = dictOption[RES_countryName] as! String?
                    self.stPassportCountryId = self.dictSelectedCountry[RES_countryCode3] as! String
                }
            })
        }
        else  if textField == txtPassengerNationality {
            self.hideKeyboard()
            let dkSelection:DKSelectionView = DKSelectionView.init(frame: UIScreen.main.bounds, arrRegion: arrCountry, title: "Country", dictKey: [VK_UNIQUE_KEY:RES_countryID,VK_VALUE_KEY:RES_countryName], isSearch: true ,isImage:false)
            dkSelection.didSelecteOption(completion: { (dictOption) in
                if !dictOption.isEmpty {
                    self.txtPassengerNationality.text = dictOption[RES_countryName] as! String?
                    self.stCountryId = dictOption[RES_countryCode3] as! String
                }
            })
        }
        else if textField == txtVisaType {
            self.hideKeyboard()
            let dkSelection:DKSelectionView = DKSelectionView.init(frame:  UIScreen.main.bounds, arrRegion: arrVisaType, title: "Visa Type", dictKey: [VK_UNIQUE_KEY:RES_planTypeId,VK_VALUE_KEY:RES_typeName],isSearch: false ,isImage:false)
            dkSelection.didSelecteOption(completion: { (dictOption) in
                if !dictOption.isEmpty {
                    self.dictSelectedVisa = dictOption
                    self.txtVisaType.text = dictOption[RES_typeName] as! String?
                    self.stVisaTypeId = self.dictSelectedVisa[RES_planTypeId] as! String
                }
            })
        }
        else if textField == txtFlayerAirlines {
            self.hideKeyboard()
            let dkSelection:DKSelectionView = DKSelectionView.init(frame:  UIScreen.main.bounds, arrRegion: arrAirlineList, title: "Airline", dictKey: [VK_UNIQUE_KEY:RES_AirlineCode,VK_VALUE_KEY:RES_AirlineName] , isSearch:false, isImage:true )
            dkSelection.didSelecteOption(completion: { (dictOption) in
                if !dictOption.isEmpty {
                    self.txtFlayerAirlines.text = dictOption[RES_AirlineName] as! String?
                    self.stAirlineCode = dictOption[RES_AirlineCode] as! String
                }
            })
        }
        else if textField == txtDateofBirth { self.showDateSelectionPopover(txtDateofBirth) }
        else if textField == txtExpireDate { self.showDateSelectionPopover(txtExpireDate)}
        
        else{ return true }
        return false
    }

    //MARK : TEXTFIELD DELAGATE
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideKeyboard()
        if textField == txtFirstName { txtMiddleName.becomeFirstResponder() }
        else if textField == txtMiddleName { txtLastName.becomeFirstResponder() }
        else if textField == txtLastName { txtDateofBirth.becomeFirstResponder() }
        else if textField == txtDateofBirth { txtDateofBirth.resignFirstResponder() }
        else if textField == txtPassportNumber { txtVisaType.becomeFirstResponder() }
        else if textField == txtVisaType { txtPassportCounrty.becomeFirstResponder() }
        else if textField == txtPassportCounrty { txtExpireDate.becomeFirstResponder() }
        else if textField == txtExpireDate { txtPassengerNationality.becomeFirstResponder() }
        else if textField == txtPassengerNationality { txtPassengerNationality.resignFirstResponder() }
        else if textField == txtFlayerFFNumber { txtFlayerAirlines.becomeFirstResponder() }
        else if textField == txtFlayerAirlines { txtFlayerAirlines.resignFirstResponder() }
        return true
    }
    
    func showDateSelectionPopover(_ textField: UITextField) {
        self.hideKeyboard()
        let date = NSDate()
        txtDate = textField
        let stdate : String = textField.text != nil ? textField.text! : VKDatePopOver.getDate(VKDateFormat.YYYYMMDD, date: date as Date)
         var maxDate:String = ""
         var minDate:String  = ""
        if textField == txtDateofBirth { maxDate = VKDatePopOver.getDate(VKDateFormat.YYYYMMDD, date: Date())
        }
        self._VKDatePopOver.initSetFrame(stdate, mininumDate: "", maximumDate: maxDate, dateFormat: VKDateFormat.YYYYMMDD, dateType: DATE_TYPE.DATE_BIRTHDATE, isOutSideClickedHidden: false , isShowCancel:false)
        
        self._VKDatePopOver.delegate = self
        self.navigationController!.view.addSubview(_VKDatePopOver)
    }
    
    //MARK: VKDATEPOPOVER DELEGATE
    func vkDatePopoverSelectedDate(_ vkDate: Date, strDate: String, dateType: DATE_TYPE, dateFormat: DateFormatter) {
        txtDate.text = strDate
        if txtDate == txtDateofBirth {
            dob = vkDate
        }
        else if txtDate == txtExpireDate {
            expireDate = vkDate
        }
    }
    
    func vkDatePopoverClearDate(_ dateType: DATE_TYPE) {
        txtDate.text = ""
    }
    
    func vkDatePopoverSelectedDate(_ vkDate: Date, strDate: String) {
        txtDate.text = strDate
    }
}
