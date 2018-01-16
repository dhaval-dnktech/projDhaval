//
//  ApplyPromocodeViewController.swift
//  Cubber
//
//  Created by dnk on 18/09/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

protocol ApplyPromocodeViewDelegate {
    func ApplyPromoCodeView_btnApplyAction(dict:typeAliasDictionary)
}

class ApplyPromocodeViewController: UIViewController , UITableViewDataSource , UITableViewDelegate , ApplyPromoCodeCellDelegate , UITextFieldDelegate , AppNavigationControllerDelegate , VKPopoverDelegate {

    //MARK: PROPERTIES
    @IBOutlet var txtPromocode: UITextField!
    @IBOutlet var btnApplyPromocode: UIButton!
    @IBOutlet var tableViewPromocode: UITableView!
    @IBOutlet var lblDescription: UILabel!
    
    @IBOutlet var viewTerms: UIView!
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
     fileprivate let _KDAlertView = KDAlertView()
    fileprivate var _VKPopOver = VKPopover()
    var arrCoupon:[typeAliasDictionary] = [typeAliasDictionary]()
    var stCart:String = ""
    var dictCart:typeAliasDictionary = typeAliasDictionary()
    var stOrderType:String = ""
    var delegate:ApplyPromocodeViewDelegate? = nil
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableViewPromocode.register(UINib.init(nibName: CELL_IDENIFIER_APPLY_PROMOCODE_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENIFIER_APPLY_PROMOCODE_CELL)
        tableViewPromocode.estimatedRowHeight = 100
        tableViewPromocode.rowHeight = UITableViewAutomaticDimension
        tableViewPromocode.tableFooterView = UIView.init(frame: .zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }
    
    //MARK: APPNAVIGATION CONTROLLER METHOD
    func setNavigationBar() {
        
        obj_AppDelegate.navigationController.setCustomTitle("Apply Promocode")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: CUSTOM METHODS
    
    @IBAction func btnApplyCouponAction() {

        txtPromocode.resignFirstResponder()
        let stCode:String = txtPromocode.text!.trim()
        self.callAapplyCouponService(couponCode: stCode)
        
    }
    
    func callAapplyCouponService(couponCode:String) {
        
        dictCart = stCart.convertToDictionary2()
        dictCart[CART_COUPON_CODE] = couponCode as AnyObject?
        
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_CART:dictCart.convertToJSonString(),
                      REQ_USER_ID:DataModel.getUserInfo()[RES_userID] as! String,
                      REQ_ORDER_TYPE_ID:stOrderType,
                      REQ_DEVICE_TYPE:VAL_DEVICE_TYPE,
                      REQ_DEVICE_ID:DataModel.getUDID()]
        
        self.obj_OperationWeb.callRestApi(methodName: JMETHOD_AppliedCoupon, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
           
            self.delegate?.ApplyPromoCodeView_btnApplyAction(dict: dict)
            let _ = self.navigationController?.popViewController(animated: true)
            print("Cart : Coupon : \(dict)")
            
        }, onFailure: { (code, dict) in
            let message: String = dict[RES_message] as! String
             self._KDAlertView.showMessage(message: message, messageType: .WARNING)
        }) {  self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return     }
    }
    
    
    //MARK: TABLEVIEW DATASOURCE
    
    func numberOfSections(in tableView: UITableView) -> Int { return 1}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCoupon.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ApplyPromocodeCell  = tableView.dequeueReusableCell(withIdentifier: CELL_IDENIFIER_APPLY_PROMOCODE_CELL) as! ApplyPromocodeCell
        cell.delegate = self
        let dictCoupon:typeAliasDictionary = arrCoupon[indexPath.row]
        cell.lblCouponName.text = dictCoupon[RES_couponCode] as? String
        cell.lblDescription.text = dictCoupon[RES_couponTitle] as? String
        cell.btnApplyCode.accessibilityIdentifier = String(indexPath.row)
        cell.btnTermsAndCond.accessibilityIdentifier = String(indexPath.row)
        cell.selectionStyle = .none
        return cell
    }

    //MARK: TABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    //MARK: APPLYPROMOCODE CELL DELEGATE
    
    func ApplyPromoCodeCell_btnApplyAction(button: UIButton) {
        let ind:Int = Int(button.accessibilityIdentifier!)!
        let dictCoupon:typeAliasDictionary = arrCoupon[ind]
        self.callAapplyCouponService(couponCode:  dictCoupon[RES_couponCode] as! String)
    }
    
    func ApplyPromoCodeCell_btnTermsAndCondAction(button: UIButton) {
        let ind:Int = Int(button.accessibilityIdentifier!)!
        let dictCoupon:typeAliasDictionary = arrCoupon[ind]
        let _ = TermsAndCondView.init(dictCoupon, isSignUP: false, isPrivacyPolicy: false)
    }
    
    //MARK: UITEXTFIELD DELEGATE
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtPromocode {
            txtPromocode.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text: String = textField.text!
        let resultingString: String = text.replacingCharacters(in: range.toRange(string: text), with: string)
         
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    //MARK: VKPOPOVER DELEGATE
    
    func vkPopoverClose() {
        
    }
}
