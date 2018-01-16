
//
//  PassengerDetailViewController.swift
//  Cubber
//
//  Created by dnk on 25/04/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class PassengerDetailViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , PassengerDetalCellDelegate , UITextFieldDelegate, AppNavigationControllerDelegate {

    //MARK: PROPERTIES
    @IBOutlet var txtEmailID: UITextField!
    @IBOutlet var txtMobileNo: UITextField!
    @IBOutlet var tableViewPassengerList: UITableView!
    @IBOutlet var lblNotice: UILabel!
    @IBOutlet var constraintTableViewPassengerDetailHeight: NSLayoutConstraint!
    @IBOutlet var scrollViewBG: UIScrollView!
    @IBOutlet var constraintTableViewBottom: NSLayoutConstraint!
    
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let _KDAlertView = KDAlertView()
    internal var arrSelecteSeats = [typeAliasStringDictionary]()
    internal var dictRoute = typeAliasDictionary()
    internal var dictBoardingPoint = typeAliasStringDictionary()
    fileprivate var arrPassengerDetail = [typeAliasStringDictionary]()
    fileprivate var txtActive = UITextField()
    internal var totalFare:Double = 0.00
    internal var baseFare:Double = 0.00
    
    //MARK: DEFAULT METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setContactInfo()
        txtActive.delegate = self
        tableViewPassengerList.register(UINib.init(nibName: CELL_IDENTIFIER_PASSENGER_DETAIL_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_PASSENGER_DETAIL_CELL)
        tableViewPassengerList.tableFooterView = UIView.init(frame: CGRect.zero)
        tableViewPassengerList.rowHeight = HEIGHT_PASSENGER_DETAIL_CELL
        setArrPassengerDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        self.sendScreenView(name: F_BUS_PASSENGERDETAIL)
       
     }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.registerForKeyboardNotifications()
        self.SetScreenName(name: F_BUS_PASSENGERDETAIL, stclass: F_BUS_PASSENGERDETAIL)
    }

    fileprivate func setNavigationBar() {
        
        obj_AppDelegate.navigationController.setCustomTitle("Passenger Details")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
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
        
        var contentInset: UIEdgeInsets = scrollViewBG.contentInset
        contentInset.bottom = keyboardRect.size.height
       // tableViewPassengerList.contentInset = contentInset
        scrollViewBG.contentInset = contentInset
    }
    
    internal func keyboardWillBeHidden(_ aNotification: Notification) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            self.scrollViewBG.contentInset = UIEdgeInsets.zero
            // self.tableViewPassengerList.contentInset = UIEdgeInsets.zero
        }, completion: nil)
    }

    
    //MARK: CUSTOM METHODS
    func setContactInfo() {
    
        let dictUser = DataModel.getUserInfo()
        if dictUser[RES_userEmailId] as! String != "" {
            txtEmailID.text = dictUser[RES_userEmailId] as! String?
            lblNotice.text = "Your ticket will be sent to \(dictUser[RES_userEmailId]!)."
        }
        else { lblNotice.text = "Your ticket will be sent to your email." }
        txtMobileNo.text = dictUser[RES_userMobileNo] as! String?
    }
    
    func setArrPassengerDetail() {
    
        for i in 0..<arrSelecteSeats.count {
            
            var dictPassenger:typeAliasStringDictionary = [PASSENGER_NAME:"",
                                 PASSENGER_AGE:"",
                                 PASSENGER_GENDER:"",]
            if i == 0 {
                let dictUser = DataModel.getUserInfo()
                dictPassenger[PASSENGER_NAME] = "\((dictUser[RES_userFirstName] as! String) + " " +  (dictUser[RES_userLastName] as! String))"
                 dictPassenger[PASSENGER_AGE] = "\(self.calculateAge())"
                dictPassenger[PASSENGER_GENDER] = dictUser[RES_userSex] as! String? == "0" ? "M" : "F"
            }
            arrPassengerDetail.append(dictPassenger)
        }
        constraintTableViewPassengerDetailHeight.constant = HEIGHT_PASSENGER_DETAIL_CELL * CGFloat(arrPassengerDetail.count)
        tableViewPassengerList.reloadData()
        
    }
    
    func calculateAge()-> Int {
     let dictUser = DataModel.getUserInfo()
        let dob:String = dictUser[RES_userDOB] as! String
        if dob == "0000-00-00" || dob == ""{
            return 0
        }
        else {
            let dateFormate = DateFormatter()
            dateFormate.dateFormat = "yyyy-MM-dd"
            let dateOB = dateFormate.date(from: dob)
            let myAge = dateOB?.age
            return myAge!
           
        }
        return -1
    }
    
    func updateArrPassengerDetail(text:String , index:Int , textFeild:UITextField , isAge:Bool) {
        var dictPassenger = arrPassengerDetail[index]
        if isAge { dictPassenger[PASSENGER_AGE] = text }
        else { dictPassenger[PASSENGER_NAME] = text }
        arrPassengerDetail[index] = dictPassenger
        tableViewPassengerList.reloadData()
    }
    
    @IBAction func btnProceedAction() {
        
        let stEmailID = txtEmailID.text?.trim()
        let stMobileNo = txtMobileNo.text?.trim()
        
        for i  in 0..<arrPassengerDetail.count {
            let dict = arrPassengerDetail[i]
            if dict[PASSENGER_NAME] == ""{
                if i == 0 {
                    _KDAlertView.showMessage(message: "Please enter primary passenger name", messageType: .WARNING)
                    return
                }
                else{
                     _KDAlertView.showMessage(message: "Please enter co-passenger \(i) name", messageType: .WARNING)
                    return
                }
            }
            else if dict[PASSENGER_AGE] == "" {
                if i == 0 {
                     _KDAlertView.showMessage(message: "Please enter primary passenger age", messageType: .WARNING)
                    return
                }
                else{
                     _KDAlertView.showMessage(message: "Please enter co-passenger \(i) age", messageType: .WARNING)
                    return
                }
            }
            else if dict[PASSENGER_GENDER] == "" {
                if i == 0 {
                     _KDAlertView.showMessage(message: "Please select primary passenger gender", messageType: .WARNING)
                    return
                }
                else{
                     _KDAlertView.showMessage(message: "Please select co-passenger \(i) gender", messageType: .WARNING)
                    return
                }
            }
        }
        if stEmailID == "" {
            _KDAlertView.showMessage(message: MSG_TXT_EMAIL, messageType: .WARNING)
            return
        }
        else if !DataModel.validateEmail(stEmailID!) {
             _KDAlertView.showMessage(message: MSG_TXT_EMAIL_VALID, messageType: .WARNING)
            return
        }
        else if stMobileNo == "" {
          _KDAlertView.showMessage(message: MSG_TXT_MOBILE_NO, messageType: .WARNING)
            return
        }
        else if !DataModel.validateMobileNo(stMobileNo!) {
            _KDAlertView.showMessage(message: MSG_TXT_MOBILE_NO_VALID, messageType: .WARNING)
            return
        }
         let arr:NSArray = arrSelecteSeats as NSArray
        let arrPass:NSArray = arrPassengerDetail as NSArray
        let params = [RES_SeatNames:((arr.value(forKey: RES_SeatNo) as AnyObject).value(forKey: KEY_DESCRIPTION)! as AnyObject).componentsJoined(by: ","),
                      RES_userId:DataModel.getUserInfo()[RES_userID]!,
                      "Gender":((arrPass.value(forKey: PASSENGER_GENDER) as AnyObject).value(forKey: KEY_DESCRIPTION)! as AnyObject).componentsJoined(by: ","),
                      RES_mobileNo:stMobileNo!,
                      RES_emailId:stEmailID!,
        FIR_SELECT_CONTENT:"Proceed"] as [String:Any]
        self.FIRLogEvent(name: F_MODULE_BUS, parameters: params as! [String : NSObject])
        let confirmBookingVC = ConfirmBookingViewController(nibName: "ConfirmBookingViewController", bundle: nil)
        confirmBookingVC.arrPassengerDetail = arrPassengerDetail
        confirmBookingVC.arrSelecteSeats = arrSelecteSeats
        confirmBookingVC.dictBoardingPoint = dictBoardingPoint
        confirmBookingVC.dictRoute = dictRoute
        confirmBookingVC.fare = totalFare
        confirmBookingVC.stU_Mobile = stMobileNo!
        confirmBookingVC.stU_Email = stEmailID!
        
        let _gtmModel = GTMModel()
        _gtmModel.ee_type = GTM_BUS
        _gtmModel.name = GTM_BUS_BOOKING
        _gtmModel.price = "\(baseFare)"
        _gtmModel.product_Id = DataModel.getUserInfo()[RES_userID] as! String
        _gtmModel.brand = self.dictRoute[RES_CompanyName] as! String
        _gtmModel.category = "\(self.dictRoute[RES_FromCityName] as! String) To \(dictRoute[RES_ToCityName] as! String)"
        _gtmModel.variant = self.dictRoute[RES_ArrangementName] as! String
        _gtmModel.option = "Passenger Details"
        _gtmModel.step = 1
        _gtmModel.quantity = arrSelecteSeats.count
        _gtmModel.dimension5 = "\(self.dictRoute[RES_FromCityName] as! String) : \(dictRoute[RES_ToCityName] as! String)"
        _gtmModel.dimension6 = dictRoute[RES_BookingDate] as! String
         GTMModel.pushCheckoutBus(gtmModel: _gtmModel)
        
        
        self.navigationController?.pushViewController(confirmBookingVC, animated: true)
    }
    
    //MARK: TABLEVIEW DATASOURCE 
    
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return arrPassengerDetail.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PassengerDetailCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_PASSENGER_DETAIL_CELL, for: indexPath) as! PassengerDetailCell
        let dictPAssenger = arrPassengerDetail[indexPath.row]
        cell.txtPassengerAge.accessibilityIdentifier = String(indexPath.row)
        cell.txtPassengerName.accessibilityIdentifier = String(indexPath.row)
        cell.btnGender_Female.accessibilityIdentifier = String(indexPath.row)
        cell.btnGender_Male.accessibilityIdentifier = String(indexPath.row)
        cell.delegate = self
        cell.txtPassengerName.delegate = self;
        cell.txtPassengerAge.delegate = self;
        
        cell.lblPassengerTitle.text = indexPath.row == 0 ? "Primary Passenger" : "Co-Passenger \(indexPath.row)"
        cell.lblSeatNo.text = "Seat \(arrSelecteSeats[indexPath.row][RES_SeatNo]!)"
        cell.txtPassengerName.text = dictPAssenger[PASSENGER_NAME]
        cell.txtPassengerAge.text = dictPAssenger[PASSENGER_AGE]
        
        if dictPAssenger[PASSENGER_GENDER] == "M" {
            cell.btnGender_Male.isSelected = true
            cell.btnGender_Female.isSelected = false
        }
        else if dictPAssenger[PASSENGER_GENDER] == "F" {
            cell.btnGender_Female.isSelected = true
            cell.btnGender_Male.isSelected = false
        }
        else{
            cell.btnGender_Male.isSelected = false
            cell.btnGender_Female.isSelected = false
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HEIGHT_PASSENGER_DETAIL_CELL
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero }
    
    
    //MARK: PASSENGER DETAIL CELL DELEGATE
    
    func PassengerDetailCell_BtnSelectGenderAction(button: UIButton) {
        
        let index = Int(button.accessibilityIdentifier!)!
        var dictPassenger = arrPassengerDetail[index]
        dictPassenger[PASSENGER_GENDER] = button.tag == 0 ? "M" : "F"
        arrPassengerDetail[index] = dictPassenger
        tableViewPassengerList.reloadData()
    }
    //MARK: TEXTFIELD DELEGATE
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        txtActive = textField
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField  == txtEmailID || textField  == txtMobileNo{
        }
        else {
            
            let cell:PassengerDetailCell = tableViewPassengerList.cellForRow(at: IndexPath.init(row: Int(textField.accessibilityIdentifier!)!, section: 0)) as! PassengerDetailCell
            if textField == cell.txtPassengerName{
                updateArrPassengerDetail(text: (textField.text?.trim())!, index: Int(textField.accessibilityIdentifier!)!, textFeild: textField, isAge: false)
                cell.txtPassengerAge.becomeFirstResponder()
                cell.txtPassengerAge.becomeFirstResponder()
            }
            else if textField == cell.txtPassengerAge{
                 updateArrPassengerDetail(text: (textField.text?.trim())!, index: Int(textField.accessibilityIdentifier!)!, textFeild: textField, isAge: true)
                cell.txtPassengerAge.resignFirstResponder()
            }
        }

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField  == txtEmailID {
            txtMobileNo.becomeFirstResponder()
        }
        else if textField  == txtMobileNo {
            txtMobileNo.resignFirstResponder()
        }
        else {
            let cell:PassengerDetailCell = tableViewPassengerList.cellForRow(at: IndexPath.init(row: Int(textField.accessibilityIdentifier!)!, section: 0)) as! PassengerDetailCell
            if textField == cell.txtPassengerName{
                cell.txtPassengerName.resignFirstResponder()
            }
            else if textField == cell.txtPassengerAge{
                cell.txtPassengerAge.resignFirstResponder()
            }
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text: String = textField.text!
        let resultingString: String = text.replacingCharacters(in: range.toRange(string: text), with: string)
         
        if textField == txtMobileNo {
            
            if resultingString.characters.isEmpty
            {
                txtMobileNo.text = ""
                return true
            }
            
            var holder: Float = 0.00
            let scan: Scanner = Scanner(string: resultingString)
            let RET: Bool = scan.scanFloat(&holder) && scan.isAtEnd
            if string == "." { return false }
            if resultingString.characters.count > 10 { return false }
            return RET
        }
        
        else if textField == txtEmailID || textField == txtMobileNo {
         return true
        }
        else {
            let cell:PassengerDetailCell = tableViewPassengerList.cellForRow(at: IndexPath.init(row: Int(textField.accessibilityIdentifier!)!, section: 0)) as! PassengerDetailCell
            
            if textField == cell.txtPassengerAge {
                
                if resultingString.characters.isEmpty
                {
                    cell.txtPassengerAge.text = ""
                    return true
                }
                var holder: Float = 0.00
                let scan: Scanner = Scanner(string: resultingString)
                let RET: Bool = scan.scanFloat(&holder) && scan.isAtEnd
                if string == "." { return false }
                if resultingString.characters.count > 2 { return false }
                return RET
            }
        }
        return true
    }
}
