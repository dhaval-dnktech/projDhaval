//
//  DropBoardingPointViewController.swift
//  Cubber
//
//  Created by dnk on 31/03/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

protocol DropBoardingViewDelegate {
    func DropBoardingView_SelectedArray(array:[typeAliasStringDictionary] , filterType:String)
}

class DropBoardingPointViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , DropBoardngCellDelegate , UITextFieldDelegate{

    //MARK: CONSTANTS
    
    //MARK: PROPERTIES
    @IBOutlet var scrollViewBG: UIScrollView!
    @IBOutlet var tableViewList: UITableView!
    @IBOutlet var btnDone: UIButton!
    @IBOutlet var txtSearch: UITextField!
    @IBOutlet var constraintViewFooterBottom: NSLayoutConstraint!
    
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate let _KDAlertView = KDAlertView()
    fileprivate var arrList = [typeAliasDictionary]()
    internal var arrSelected = [typeAliasStringDictionary]()
    fileprivate var arrDisplayList = [typeAliasDictionary]()
    fileprivate var arrDisplayData = [typeAliasDictionary]()
    fileprivate var stFilterType = ""
    internal var _FILTER_LIST_TYPE = FILTER_LIST_TYPE.DUMMY
    internal var stCityID : String = ""
    var delegate:DropBoardingViewDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if _FILTER_LIST_TYPE == .BOARDING { stFilterType = KEY_BOARDING_POINT ; callDropBoardingPointService(cityID: stCityID) }
        else if _FILTER_LIST_TYPE == .DROPPING { stFilterType = KEY_DROPPING_POINT ; callDropBoardingPointService(cityID: stCityID) }
        else if _FILTER_LIST_TYPE == .OPERATOR_LIST { stFilterType = KEY_BUS_OPERATOR ;  self.callOperatorListService() }
        btnDone.isEnabled = false
        tableViewList.register(UINib.init(nibName: CELL_DROP_BOARDING_POINT, bundle: nil), forCellReuseIdentifier: CELL_DROP_BOARDING_POINT)
        tableViewList.rowHeight = 40
        tableViewList.tableFooterView = UIView.init(frame: CGRect.zero)
        
    }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
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
        self.constraintViewFooterBottom.constant = keyboardRect.size.height
        scrollViewBG.contentInset = contentInset
    }
    
    internal func keyboardWillBeHidden(_ aNotification: Notification) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            self.scrollViewBG.contentInset = UIEdgeInsets.zero
            self.constraintViewFooterBottom.constant = 0
            
        }, completion: nil)
    }
    
    

    //MARK: BUTTON ACTION
    
    @IBAction func btnCancelAction() {
        txtSearch.resignFirstResponder()
        let _ = self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func btnDoneAction() {
        txtSearch.resignFirstResponder()
        self.delegate?.DropBoardingView_SelectedArray(array: arrSelected, filterType: stFilterType)
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: CUSTOM METHODS
    
    func isExistValue(dict:typeAliasDictionary , key:String) -> Int {
        
        for i in 0..<arrSelected.count {
            let dictSel = arrSelected[i]
            if dictSel[KEY_ID] == dict[key] as! String {
                return i
            }
        }
        return -1
    }
    
    fileprivate func searchData(name:String) {
        
        arrDisplayData = [typeAliasDictionary]()
        let arrData = arrList
         if !name.isEmpty{
            for dict in arrData{
                if (dict[RES_operatorName] as! String).isContainString(name){arrDisplayData.append(dict)}
            }
        }
        else{arrDisplayData = arrData}
        tableViewList.reloadData()
    }
    
    func callOperatorListService() {
        
        var params = typeAliasStringDictionary()
        params[REQ_HEADER] = DataModel.getHeaderToken()
        params[REQ_CATEGORY_ID] = "8"
        
       obj_OperationWeb.callRestApi(methodName: JMETHOD_OperatorList, methodType: METHOD_TYPE.POST, isAddToken: false, parameters:params
        , viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
            self.arrList = dict[RES_data] as! [typeAliasDictionary]
            self.arrDisplayData = self.arrList
            self.tableViewList.reloadData()
            self.txtSearch.becomeFirstResponder()
       }, onFailure: { (code, dict) in
       }) {
        self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return}
    }
    
    func callDropBoardingPointService(cityID:String){
        
        var params = typeAliasStringDictionary()
        params[REQ_HEADER] = DataModel.getHeaderToken()
        params[REQ_CITY_ID] = cityID
        params[REQ_OPERATOR_ID] = ""
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_GetBoardingDropLocationsByCity, methodType: METHOD_TYPE.POST, isAddToken: false, parameters:params
            , viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
                self.arrList = dict[RES_data] as! [typeAliasDictionary]
                self.arrDisplayData = self.arrList
                self.tableViewList.reloadData()
                
        }, onFailure: { (code, dict) in
            self._KDAlertView.showMessage(message: dict[RES_message] as! String, messageType: .WARNING)
            _ = self.navigationController?.popViewController(animated: true)
        }) {
            self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return}
        
    
    }
    
    //MARK: TABLEVIEW DATASOURCE
    
    func numberOfSections(in tableView: UITableView) -> Int { return 1}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDisplayData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_DROP_BOARDING_POINT, for: indexPath) as! DropBoardingPointCell
        let dictData = arrDisplayData[indexPath.row]
        cell.delegate = self
        
        if _FILTER_LIST_TYPE == .BOARDING {
            
            cell.lblTitle.text = dictData[RES_bus_boardingPointName] as? String
            cell.btnCheckBox.accessibilityIdentifier = String(indexPath.row)
            if isExistValue(dict: dictData, key: "locationId") > -1 { cell.btnCheckBox.isSelected = true ; btnDone.isEnabled = true }
            else{ cell.btnCheckBox.isSelected = false  }
        }
        else if _FILTER_LIST_TYPE == .DROPPING {
            
            cell.lblTitle.text = dictData[RES_bus_boardingPointName] as? String
            cell.btnCheckBox.accessibilityIdentifier = String(indexPath.row)
            if isExistValue(dict: dictData, key: RES_bus_boardingId) > -1 { cell.btnCheckBox.isSelected = true ; btnDone.isEnabled = true }
            else{ cell.btnCheckBox.isSelected = false  }
        }
        else if _FILTER_LIST_TYPE == .OPERATOR_LIST {
            
            cell.lblTitle.text = dictData[RES_operatorName] as? String
            cell.btnCheckBox.accessibilityIdentifier = String(indexPath.row)
            if isExistValue(dict: dictData, key: RES_operatorID) > -1 { cell.btnCheckBox.isSelected = true ; btnDone.isEnabled = true }
            else{ cell.btnCheckBox.isSelected = false  }
        }

        cell.selectionStyle = .none
        return cell
    }
    
    //MARK: TABLEVIEW DELEGATE
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero }
    
   
    //MARK: DropBoardingCellDelegate
        
    func DropBoardoingCell_btnCheckBoxAction(button: UIButton) {
        let ind = Int(button.accessibilityIdentifier!)!
        let dictData:typeAliasDictionary = arrDisplayData[ind]
        let  index = isExistValue(dict: dictData, key: _FILTER_LIST_TYPE == .OPERATOR_LIST ? RES_operatorID : RES_bus_boardingId)
        if index > -1 {
           arrSelected.remove(at: index)
        }
        else{
            
            if _FILTER_LIST_TYPE == .OPERATOR_LIST {
                
                let dict = [KEY_ID:dictData[RES_operatorID] as! String,
                            KEY_NAME:dictData[RES_operatorName] as! String ,
                            KEY_FILTER_TYPE : stFilterType
                ]
                arrSelected.append(dict)
            }
            else if _FILTER_LIST_TYPE == .BOARDING {
                let dict = [KEY_ID:dictData[RES_bus_boardingId] as! String,
                            KEY_NAME:dictData[RES_bus_boardingPointName] as! String ,
                            KEY_FILTER_TYPE : stFilterType
                ]
                 arrSelected.append(dict)
            }
            else if _FILTER_LIST_TYPE == .DROPPING {
                let dict = [KEY_ID:dictData[RES_bus_boardingId] as! String,
                            KEY_NAME:dictData[RES_bus_boardingPointName] as! String ,
                            KEY_FILTER_TYPE : stFilterType
                ]
                 arrSelected.append(dict)
            }
            
            btnDone.isEnabled = true
        }
        
        if arrSelected.count == 0{ btnDone.isEnabled = false}
        
        tableViewList.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       // constraintViewFooterBottom.constant = 0
        return true}
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       // constraintViewFooterBottom.constant = 120
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //constraintViewFooterBottom.constant = 0
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text: String = textField.text!
        let resultingString: String = text.replacingCharacters(in: range.toRange(string: text), with: string)
         
        if textField.isEqual(txtSearch){self.searchData(name: resultingString)}
        return true
    }

}

