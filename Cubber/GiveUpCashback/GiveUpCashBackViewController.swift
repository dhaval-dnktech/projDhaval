//
//  GiveUpCashBackViewController.swift
//  Cubber
//
//  Created by dnk on 21/11/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class GiveUpCashBackViewController: UIViewController , AppNavigationControllerDelegate , UITableViewDelegate , UITableViewDataSource , GiveUpCashBackCellDelegate {
    
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var _KDAlertView = KDAlertView()
    fileprivate var arrGiveUpList = [typeAliasDictionary]()
    fileprivate var selectedGiveUpID:String = ""
    fileprivate var giveUpNote:String = ""
    fileprivate var giveUpTerm:String = ""
    internal var giveUpTitle:String = ""
    fileprivate var giveUpCategoryId:String = ""
    
    
    //MARK: PROPERTIS
    @IBOutlet var tableViewGiveUpList: UITableView!
    @IBOutlet var switchGiveUp: UISwitch!
    @IBOutlet var lblGiveUpCashBackTitle: UILabel!
    @IBOutlet var constraintTableViewHeight: NSLayoutConstraint!
    
    
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

    //MARK: - APP NAVIGATION CONTROLLER DELEGATE
    fileprivate func setNavigationBar() {

        obj_AppDelegate.navigationController.setCustomTitle(self.giveUpTitle == "" ? "Giveup Cashback" :  self.giveUpTitle )
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ =  self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: BUTTON ACTION
    
    @IBAction func btnInfoAction() {
        _KDAlertView.showMessage(message: self.giveUpNote, messageType: .WARNING)
    }
    
    
    @IBAction func switchGiveUpAction() {
          //switchGiveUp.isOn = !switchGiveUp.isOn
    }
    
    
    @IBAction func btnSaveAction() {
        
        let params = [REQ_USER_ID:DataModel.getUserInfo()[RES_userID] as! String,
                      REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_ISGIVEUP:switchGiveUp.isOn ? "1" : "0",
                      REQ_GIVEUPID:selectedGiveUpID == "" ? "0" : selectedGiveUpID]
        obj_OperationWeb.callRestApi(methodName: JMETHOD_SaveGiveup, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view!)!, onSuccess: { (dict) in
            self._KDAlertView.showMessage(message: dict[RES_message] as! String, messageType: .SUCCESS)
        }, onFailure: { (code, dict) in
            
        }) {
            self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .INTERNET_WARNING)
            return
        }
    }
    
    @IBAction func btnWhyGiveUpAction() {
        let howToEarnVC = HowToEarnViewController(nibName: "HowToEarnViewController", bundle: nil)
        howToEarnVC.categoryID = self.giveUpCategoryId
        self.navigationController?.pushViewController(howToEarnVC, animated: true)
    }
    
    //MARK: CUSTOM METHODS
    
    func callGetGiveUpList(){
        
        let params = [REQ_USER_ID:DataModel.getUserInfo()[RES_userID] as! String,
                      REQ_HEADER:DataModel.getHeaderToken(),]
        obj_OperationWeb.callRestApi(methodName: JMETHOD_GetGiveUpList, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view!)!, onSuccess: { (dict) in
           // self.giveUpNote = dict[RES_giveupNote] as! String
            if dict[RES_isGiveup] as! String == "0" {
                self.switchGiveUp.isOn = false
            }
            else{ self.switchGiveUp.isOn = true }
            self.giveUpCategoryId = dict.isKeyNull(RES_giveUpOperatorCategoryId) ?  "" : dict[RES_giveUpOperatorCategoryId] as! String
            self.giveUpTerm = dict.isKeyNull(RES_giveupTerm) ? "" : dict[RES_giveupTerm] as! String
            self.arrGiveUpList = dict[RES_data] as! [typeAliasDictionary]
            self.selectedGiveUpID = dict[RES_giveupId] as! String
            let height:CGFloat =  CGFloat(self.arrGiveUpList.count) * self.tableViewGiveUpList.rowHeight
            if height > 300 {
                self.constraintTableViewHeight.constant = 300
            }
            else{
                self.constraintTableViewHeight.constant = height
            }
            self.tableViewGiveUpList.reloadData()

        }, onFailure: { (code, dict) in
            
        }) {
            
        }
    }
    
    //MARK: TABLEVIEW DELEGATE
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HEIGHT_GIVE_UP_CASHBACK_CELL
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = self.arrGiveUpList[indexPath.row]
        let howToEarnVC = HowToEarnViewController(nibName: "HowToEarnViewController", bundle: nil)
        howToEarnVC.categoryID = dict[RES_operatorCategoryId] as! String
        self.navigationController?.pushViewController(howToEarnVC, animated: true)
        //self.tableViewGiveUpList.reloadData()
    }

    //MARK: TABLEVIEW DATASOURCE
    
    func numberOfSections(in tableView: UITableView) -> Int {return 1}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return arrGiveUpList.count}
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:GiveUpCashBackCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_GIVEUP_CASHBACK_CELL) as! GiveUpCashBackCell
        
        cell.delegate = self
        cell.btnSelect.accessibilityIdentifier = String(indexPath.row)
        cell.btnInfo.isHidden = false
        
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
        if !stLastName.isEmpty { stLN = stLastName.substring( with: range ).uppercased() }
        
        cell.lblProfileInitial.text = stFN+stLN
        cell.labelName.text = userFullName
        cell.imageViewStatus.isHidden = true
        if selectedGiveUpID == dictGiveup[RES_giveupId] as! String {
            cell.btnSelect.isSelected = true
        }
        else { cell.btnSelect.isSelected = false }
        
        cell.selectionStyle = .none
        return cell
    }
    
    //MARK: GIVEUP CAHSBACK CELL DELELGATE
    func GiveUpCashBackCell_btnSelectAction(button: UIButton) {
        let index:Int = Int(button.accessibilityIdentifier!)!
        let dictGiveUpId = arrGiveUpList[index]
        if dictGiveUpId[RES_giveupId] as! String == selectedGiveUpID { selectedGiveUpID = "" }
        else { selectedGiveUpID = dictGiveUpId[RES_giveupId] as! String }
        self.tableViewGiveUpList.reloadData()
    }
}
