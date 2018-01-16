//
//  WalletViewController.swift
//  Cubber
//
//  Created by dnk on 01/09/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class DonateMoneyViewController: UIViewController , UITextFieldDelegate , AppNavigationControllerDelegate ,  UITableViewDelegate , UITableViewDataSource , UIScrollViewDelegate {
    
    //MARK: PROPERTIES

    @IBOutlet var txtAmount: FloatLabelTextField!
    @IBOutlet var txtContribueTo: FloatLabelTextField!
    @IBOutlet var txtDescription: FloatLabelTextField!
    @IBOutlet var viewDonate: UIView!
    @IBOutlet var constraintMainViewTopToSuperView: NSLayoutConstraint!
    @IBOutlet var constraintMainViewHeight: NSLayoutConstraint!
    @IBOutlet var tableViewGiveUpList: UITableView!


    //MAMRK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate let _KDAlertView = KDAlertView()
    fileprivate var _VKSideMenu = VKSideMenu()
    internal var  dictOperatorCategory = typeAliasDictionary()
    fileprivate var arrGiveUpList = [typeAliasDictionary]()
    fileprivate var selectedGiveUpID:String = ""
    fileprivate var selectedDonatee:typeAliasDictionary = typeAliasDictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewGiveUpList.register(UINib.init(nibName: CELL_IDENTIFIER_GIVEUP_CASHBACK_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_GIVEUP_CASHBACK_CELL)
        self.tableViewGiveUpList.tableFooterView = UIView.init(frame: .zero)
        self.tableViewGiveUpList.rowHeight = HEIGHT_GIVE_UP_CASHBACK_CELL
        self.callGetGiveUpList()
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
       self.SetScreenName(name: SCREEN_DONATE_MONEY, stclass: SCREEN_DONATE_MONEY)
    }
    
    //MARK: - APP NAVIGATION CONTROLLER DELEGATE
    fileprivate func setNavigationBar() {
        if dictOperatorCategory.isEmpty {
            obj_AppDelegate.navigationController.setCustomTitle("Donate Money")
        }
        else{obj_AppDelegate.navigationController.setCustomTitle("\(dictOperatorCategory[RES_operatorCategoryName] as! String)")
        }
        obj_AppDelegate.navigationController.navigationDelegate = self
        obj_AppDelegate.navigationController.setLeftButton(title: "")
    }
    
    func appNavigationController_BackAction() {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: BUTTON METHODS 
  
    @IBAction func btnAddMoney_AddMoneyAction() {
        
        txtContribueTo.resignFirstResponder()
        txtDescription.resignFirstResponder()
        txtAmount.resignFirstResponder()
        var stAmount: String = txtAmount.text!.trim()
        stAmount = Double(stAmount) == 0 ? "" : stAmount
        if (txtContribueTo.text?.trim())!.isEmpty {
            _KDAlertView.showMessage(message: "Please select donatee.", messageType: .WARNING)
            return
        }
        if stAmount.characters.isEmpty {
          _KDAlertView.showMessage(message: MSG_TXT_AMOUNT, messageType: MESSAGE_TYPE.FAILURE)
            return
        }
        self.showRechargeView(stAmount)
    }
    

    //MARK: CUSTOM METHODS
    
    func hideKeyboard() {
        txtContribueTo.resignFirstResponder()
        txtDescription.resignFirstResponder()
        txtAmount.resignFirstResponder()
    }
    
    func showGiveupList() {
        
        if self.arrGiveUpList.isEmpty {
            _KDAlertView.showMessage(message: "No accounts found.", messageType: .WARNING)
            return
        }
        
        let frame:CGRect = CGRect.init(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.view.frame.width), height: CGFloat(self.view.frame.height))
        viewDonate.frame = frame
        viewDonate.backgroundColor = RGBCOLOR(0, g: 0, b: 0, alpha: 0.6)
        self.view.addSubview(viewDonate)
        let _ = DesignModel.setScrollSubViewConstraint(viewDonate, superView: self.view, toView: self.view, leading: 0, trailing: 0, top: 0, bottom: 0, width: 0, height: 0)
        self.view.layoutIfNeeded()
        viewDonate.alpha = 0
        constraintMainViewTopToSuperView.constant = 900
        constraintMainViewTopToSuperView.constant = self.view.frame.height/2
        constraintMainViewHeight.constant = self.view.frame.height/2
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, delay: 0.1, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            self.viewDonate.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
        self.tableViewGiveUpList.reloadData()
    }
    
    @IBAction func btnCloseViewAirportAction() {
        
        constraintMainViewTopToSuperView.constant = 900
        UIView.animate(withDuration: 0.3, delay: 0.1, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
            self.viewDonate.alpha = 0
        }) { (completed) in
            self.viewDonate.removeFromSuperview()
        }
    }
    
    func callGetGiveUpList(){
        
        let params = [REQ_USER_ID:DataModel.getUserInfo()[RES_userID] as! String,
                      REQ_HEADER:DataModel.getHeaderToken(),]
        obj_OperationWeb.callRestApi(methodName: JMETHOD_GetGiveUpList, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view!)!, onSuccess: { (dict) in
            self.arrGiveUpList = dict[RES_data] as! [typeAliasDictionary]
            self.selectedDonatee =  self.arrGiveUpList.first!
            self.selectedGiveUpID = self.selectedDonatee[RES_giveupId] as! String
            self.txtContribueTo.text = self.selectedDonatee[RES_Name] as! String?
                        
        }, onFailure: { (code, dict) in
            self._KDAlertView.showMessage(message: dict[RES_message] as! String, messageType: .WARNING)
            return
        }) {
            
        }
    }
    
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
            rechargeVC.mobile_CardOperator = "Donate Money"
            rechargeVC.mobile_CardRegionName = ""
            rechargeVC.mobile_CardPrepaidPostpaid = ""
            rechargeVC.cart_PrepaidPostpaid = VAL_RECHARGE_NONE
            rechargeVC.cart_PlanTypeID = "0"
            rechargeVC.cart_MobileNo = ""
            rechargeVC.cart_TotalAmount = amount
            rechargeVC.cart_OperatorId = "0"
            rechargeVC.cart_RegionId = "0"
            rechargeVC.donateeName = (txtContribueTo.text?.trim())!
            rechargeVC.cart_CategoryId = dictOperatorCategory[RES_operatorCategoryId] as! String
            rechargeVC.cart_RegionPlanId =  "0"
            rechargeVC.cart_PlanValue =  amount
            rechargeVC.cart_Extra1 = (txtDescription.text?.trim())!
            rechargeVC.selectedGiveupId = self.selectedGiveUpID
            rechargeVC._RECHARGE_TYPE = RECHARGE_TYPE.DONATE_MONEY
            if selectedDonatee[RES_userProfileImage] as! String == "" || selectedDonatee[RES_userProfileImage] as! String == "0" {
                rechargeVC.stImageUrl = dictOperatorCategory[RES_image] as! String
            }
            else{
              rechargeVC.stImageUrl = selectedDonatee[RES_userProfileImage] as! String
            }
            self.navigationController?.pushViewController(rechargeVC, animated: true)
            
            // SET GTMMODEL DATA FOR ADD TO CART
            
            let gtmModel = GTMModel()
            gtmModel.ee_type = GTM_EE_TYPE_DONATE_MONEY
            gtmModel.name = GTM_EE_TYPE_DONATE_MONEY
            gtmModel.price = rechargeVC.cart_TotalAmount
            gtmModel.product_Id = DataModel.getUserInfo()[RES_userID] as! String
            gtmModel.brand = GTM_EE_TYPE_DONATE_MONEY
            gtmModel.category = GTM_EE_TYPE_WALLET
            gtmModel.variant = DataModel.getUserInfo()[RES_userMobileNo] as! String
            gtmModel.dimension3 = ""
            gtmModel.dimension4 = ""
            gtmModel.list = "DonateMoney Section"
            GTMModel.pushProductDetail(gtmModel: gtmModel)
            GTMModel.pushAddToCart(gtmModel: gtmModel)

        }
        else {
            _KDAlertView.showMessage(message: DataModel.getNoMembershipFeesPayMsg(), messageType: MESSAGE_TYPE.FAILURE)
            return
        }
    }
    
    //MARK: TEXTFIELD DELEGATE
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtDescription {
            txtAmount.becomeFirstResponder()
        }
        else if textField == txtAmount {
            txtAmount.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtContribueTo {
            self.hideKeyboard()
            self.showGiveupList()
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text: String = textField.text!
        let resultingString: String = text.replacingCharacters(in: range.toRange(string: text), with: string)
        
        if resultingString.isEmpty { return true }
        
        if  textField == txtAmount {
            var holder: Float = 0.00
            let scan: Scanner = Scanner(string: resultingString)
            let RET: Bool = scan.scanFloat(&holder) && scan.isAtEnd
            if string == "." { return false }
            if dictOperatorCategory[RES_amountLimit] != nil && dictOperatorCategory[RES_amountLimit] as! String != "0" && dictOperatorCategory[RES_amountLimit] as! String != "" {
                let amountLimit = Int(dictOperatorCategory[RES_amountLimit] as! String)
                if resultingString.count > amountLimit! { return false }
            }
            return RET
        }
        
        return true
    }
    
    
    //MARK: TABLEVIEW DELEGATE
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HEIGHT_GIVE_UP_CASHBACK_CELL
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictGiveUpId = arrGiveUpList[indexPath.row]
        self.selectedDonatee = dictGiveUpId
        selectedGiveUpID = dictGiveUpId[RES_giveupId] as! String
        self.txtContribueTo.text = dictGiveUpId[RES_Name] as! String?
        self.btnCloseViewAirportAction()
    }
    
    //MARK: TABLEVIEW DATASOURCE
    
    func numberOfSections(in tableView: UITableView) -> Int {return 1}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return arrGiveUpList.count}
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:GiveUpCashBackCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_GIVEUP_CASHBACK_CELL) as! GiveUpCashBackCell
        
        let dictGiveup = arrGiveUpList[indexPath.row]
        if !(dictGiveup[RES_userProfileImage] as! String).isEmpty{
            cell.indicator.startAnimating()
            let sturl = dictGiveup[RES_userProfileImage] as! String
            cell.imageViewProfile.sd_setImage(with: NSURL.init(string: sturl) as URL!, completed: { (image, error, type, url) in
                if image != nil {
                    cell.imageViewProfile.isHidden = false
                    cell.lblProfileInitial.isHidden = true
                }
                else {
                    cell.imageViewProfile.isHidden = true
                    cell.lblProfileInitial.isHidden = false
                }
                cell.indicator.stopAnimating()
            })
            
        }
        else{
            cell.lblProfileInitial.isHidden = false
            cell.imageViewProfile.isHidden = true
        }
        let userFullName:String = dictGiveup[RES_Name] as! String
        let arrName = userFullName.components(separatedBy: " ")
        
        var stLN:String = ""
        var stLastName: String = ""
        let stFirstName: String = arrName[0]
        if arrName.count > 1 {
            stLastName = arrName[1]
        }
        
        let startIndex = stFirstName.index(stFirstName.startIndex, offsetBy: 0)
        let range = startIndex..<stFirstName.index(stFirstName.startIndex, offsetBy: 1)
        let stFN = stFirstName.substring( with: range ).uppercased()
        if !stLastName.isEmpty { stLN = stLastName.substring( with: range ).uppercased()}
        
        cell.lblProfileInitial.text = stFN+stLN
        cell.labelName.text = userFullName
        
        if selectedGiveUpID == dictGiveup[RES_giveupId] as! String {
            cell.imageViewStatus.isHidden = false
        }
        else{cell.imageViewStatus.isHidden = true}
        cell.imageViewStatus.isHidden = true
        cell.btnSelect.isHidden = true
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: SCROLLVIEW DELAGATE
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if tableViewGiveUpList.contentOffset.y > 0 {
            constraintMainViewTopToSuperView.constant = 0
            constraintMainViewHeight.constant = self.view.frame.height
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        else if tableViewGiveUpList.contentOffset.y < 0 {
            constraintMainViewTopToSuperView.constant = self.view.frame.height/2
            constraintMainViewHeight.constant = self.view.frame.height/2
            UIView.animate(withDuration: 0.5, delay: 0.3, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }


}
