//
//  EventBookInfoViewController.swift
//  Cubber
//
//  Created by dnk on 15/10/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit



class EventBookInfoViewController: UIViewController, UITextFieldDelegate , AppNavigationControllerDelegate {

    //MARK:PROPERTIES
    @IBOutlet var scrollViewBG: UIScrollView!
    @IBOutlet var lblVenueTitle: UILabel!
    @IBOutlet var lblEventName: UILabel!
    @IBOutlet var lblDateTime: UILabel!
    @IBOutlet var lblNoofTickets: UILabel!
    @IBOutlet var lblTicketContent: UILabel!
    @IBOutlet var lblBaseFarePrice: UILabel!
    @IBOutlet var lblConventionalFeesTaxes: UILabel!
    @IBOutlet var txtFullName: UITextField!
    @IBOutlet var txtMobileNo: UITextField!
    @IBOutlet var txtEmailID: UITextField!
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var _KDAlertView = KDAlertView()
    internal var dictEventDetail = typeAliasDictionary()
    internal var arrPassData = [typeAliasDictionary]()
    internal var arrPackageDataSelected = [typeAliasDictionary]()
    internal var stVenue:String = ""
    internal var operatorID:String = ""
    internal var selectedTime:String = ""
    
    var str = ""
    var totalPrice: Double = 0.00
    var ticketCount: Int = 0
    var baseFarePrice: Double = 0.00
    var conventionFeesTaxes: Double = 0.00

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUserBookInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.registerForKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
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
        obj_AppDelegate.navigationController.setCustomTitle("Book Tickets")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }

    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    
    func setUserBookInfo(){
        lblVenueTitle.text = stVenue 
        let dictUserInfo = DataModel.getUserInfo()
        txtFullName.text = "\(dictUserInfo[RES_userFirstName] as! String) \(dictUserInfo[RES_userLastName] as! String)"
        txtMobileNo.text = dictUserInfo[RES_userMobileNo] as? String
        txtEmailID.text = dictUserInfo[RES_userEmailId] as? String
        

        for dict in arrPassData {
            if dict[KEY_QUANTITY] as! String > "0"  {
                
            str += "\(dict[KEY_QUANTITY]!) x \(dict[RES_packageTitle]!) (\(RUPEES_SYMBOL) \(String.init(format: "%.1f", Double(dict[RES_price] as! String)!))) \n"
            ticketCount = ticketCount + Int(dict[KEY_QUANTITY] as! String)!
            baseFarePrice += Double(Int(dict[KEY_QUANTITY] as! String)!) * Double(dict[RES_price] as! String)!
            conventionFeesTaxes += Double(Int(dict[KEY_QUANTITY] as! String)!) * Double(dict[RES_convenienceAmt] as! NSNumber)
        
            }
        }
        
        lblTicketContent.text = str
        lblNoofTickets.text = "\(String(ticketCount)) Tickets"
        lblEventName.text = "\(dictEventDetail[RES_operatorName]!)"
        let dictPackage = self.arrPackageDataSelected.first!
        
        lblDateTime.text = "\(dictPackage[RES_day]!) \(dictPackage[RES_date]!) \(dictPackage[RES_month]!), \(selectedTime)"
        lblBaseFarePrice.text = "\(RUPEES_SYMBOL) \(String.init(format: "%.1f", baseFarePrice))"
        
        lblConventionalFeesTaxes.text = "\(RUPEES_SYMBOL) \(String.init(format: "%.1f",conventionFeesTaxes))"
        totalPrice = baseFarePrice + conventionFeesTaxes
    }
    
    @IBAction func btnContinueAction() {
        
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
            rechargeVC.cart_subTotal = String(baseFarePrice)
            rechargeVC.cart_totalServiceTax = String(conventionFeesTaxes)
            rechargeVC.cart_CouponCode = "0"
            rechargeVC.cart_CategoryId = "21"
            rechargeVC.cart_RegionId = self.dictEventDetail[RES_regionID] as! String
            rechargeVC.cart_DiscountAmount = "0"
            rechargeVC.cart_TotalAmount = String(totalPrice)
            rechargeVC.cart_walletUsed = "0"
            rechargeVC.cart_OperatorId = "0"
            rechargeVC.cart_paidAmount = String(totalPrice)
            rechargeVC.cart_CashBackAmount = "0"
            rechargeVC.cart_CouponMessage = ""
            rechargeVC.cart_couponID = "0"
            rechargeVC._RECHARGE_TYPE = RECHARGE_TYPE.EVENT
            rechargeVC.cart_Email = txtEmailID.text!.trim()
            rechargeVC.cart_MobileNo = txtMobileNo.text!.trim()
            rechargeVC.cart_totalPassengers = "\(ticketCount)"
            rechargeVC.dictEvent = self.dictEventDetail
            rechargeVC.cart_arrPassData = self.arrPassData
            rechargeVC.cart_passengerName = (self.txtFullName.text?.trim())!
            rechargeVC.cart_OperatorId = self.operatorID

            let _gtmModel = GTMModel()
            _gtmModel.ee_type = GTM_EVENT
            _gtmModel.name = GTM_EVENT_BOOKING
            _gtmModel.price = String(baseFarePrice)
            _gtmModel.product_Id = DataModel.getUserInfo()[RES_userID] as! String
            _gtmModel.brand = self.dictEventDetail[RES_operatorName] as! String
            _gtmModel.category = stVenue
            _gtmModel.variant = self.operatorID
            _gtmModel.option = ""
            _gtmModel.step = 1
            _gtmModel.quantity = ticketCount
            _gtmModel.dimension5 = self.dictEventDetail[RES_regionID] as! String
            _gtmModel.dimension6 = "0"
            _gtmModel.list = "Event Section"
            _gtmModel.option = "Passenger Details"
            _gtmModel.step = 1
            GTMModel.pushCheckoutBus(gtmModel: _gtmModel)
            _gtmModel.step = 2
            _gtmModel.option = "Confirm Passenger Details"
            GTMModel.pushCheckoutBus(gtmModel: _gtmModel)
            
            self.navigationController?.pushViewController(rechargeVC, animated: true)        }
            
        else{
            _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: .WARNING)
        }
        
    }
    
    //MARK: UITEXTFIELD DELEGATE
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtFullName { txtMobileNo.becomeFirstResponder() }
        else if textField == txtMobileNo { txtEmailID.becomeFirstResponder() }
        else if textField == txtEmailID { txtEmailID.resignFirstResponder() }
        
        return true
    }
    
}
