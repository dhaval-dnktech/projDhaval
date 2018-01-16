//
//  StationViewController.swift
//  Cubber
//
//  Created by dnk on 04/02/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

protocol stationViewDelegate {
    func selectedSourceAndDestination(dict:typeAliasDictionary , isOrigin:Bool)
}

class StationViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UITextFieldDelegate, AppNavigationControllerDelegate {

    //MARK: PROPERTIES
    @IBOutlet var txtSearch: UITextField!
    @IBOutlet var tableViewList: UITableView!
    @IBOutlet var lblNoSearchFound: UILabel!
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var arrSources = [typeAliasDictionary]()
    fileprivate var arrDestination = [typeAliasDictionary]()
    fileprivate var arrDisplayData = [typeAliasDictionary]()
    internal var isOrigin:Bool = false
    internal var stSourceID : String = ""
    internal var stTitle : String = ""

    var delegate:stationViewDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewList.tableFooterView = UIView(frame: CGRect.zero)
        tableViewList.rowHeight = 40
        if isOrigin {
            if obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_GetSources) {
                self.callGetSourcesService()
            }
            else{
                let dict:typeAliasDictionary = DataModel.getSourceList()
                DataModel.setHeaderToken(dict[RES_token]! as! String)
                self.arrSources = dict[RES_data] as! [typeAliasDictionary]
                self.arrDisplayData = dict[RES_data] as! [typeAliasDictionary]
                self.tableViewList.reloadData()
                self.tableViewList.isHidden = false
                self.txtSearch.becomeFirstResponder()
            }
        }
        else{self.callGetDestinationsBasedOnSourceService()}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        self.sendScreenView(name: F_BUS_SELECT_JOURNEYLOCATION)
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         self.SetScreenName(name: F_BUS_SELECT_JOURNEYLOCATION, stclass: F_BUS_SELECT_JOURNEYLOCATION)
    }
    
    //MARK: APP NAVIGATION METHOD
    
    fileprivate func setNavigationBar() {
        stTitle = isOrigin ? "Select Origin City" : "Select Destination City"
        obj_AppDelegate.navigationController.setCustomTitle(stTitle)
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    
    //MARK: CUSTOM METHODS
    
    fileprivate func callGetSourcesService(){
        
        var params = typeAliasStringDictionary()
        params[REQ_HEADER] = DataModel.getHeaderToken()
        params[REQ_SOURCE_NAME] = " "
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_GetSources, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params
            , viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
                
                DataModel.setHeaderToken(dict[RES_token]! as! String)
                self.arrSources = dict[RES_data] as! [typeAliasDictionary]
                self.arrDisplayData = dict[RES_data] as! [typeAliasDictionary]
                self.tableViewList.reloadData()
                self.tableViewList.isHidden = false
                self.txtSearch.becomeFirstResponder()
                DataModel.setSourceList(dict: dict)
                self.obj_AppDelegate.updateDictService(serviceName: JMETHOD_GetSources)
                
        }, onFailure: { (code, dict) in
            self.tableViewList.isHidden = true
        }) {
            let _KDAlertView = KDAlertView()
            _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return
        }
    }
    fileprivate func callGetDestinationsBasedOnSourceService(){
        
        var params = typeAliasStringDictionary()
        params[REQ_HEADER] = DataModel.getHeaderToken()
        params[REQ_SOURCE_ID] = stSourceID
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_GetDestinationsBasedOnSource, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            
            DataModel.setHeaderToken(dict[RES_token]! as! String)
            self.arrDestination = dict[RES_data] as! [typeAliasDictionary]
            self.arrDisplayData = dict[RES_data] as! [typeAliasDictionary]
            self.tableViewList.reloadData()
            self.tableViewList.isHidden = false
            self.isOrigin = false
            self.txtSearch.becomeFirstResponder()
            self.setNavigationBar()
            
        }, onFailure: { (code, dict) in
              self.tableViewList.isHidden = true
        }) {let _KDAlertView = KDAlertView()
            _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return
        }
    }
    
    fileprivate func searchCity(name:String) {
        
       arrDisplayData = [typeAliasDictionary]()
       let arrData = isOrigin ? arrSources : arrDestination
        let keyCityName = isOrigin ? RES_sourceName : RES_destinationName
        if !name.isEmpty{
            for dict in arrData{
                if (dict[keyCityName] as! String).isContainString(name){arrDisplayData.append(dict)}
            }
        }
        else { arrDisplayData = arrData }
        
        if arrDisplayData.count == 0 {
            lblNoSearchFound.isHidden = false
        }
        else { lblNoSearchFound.isHidden = true }
        tableViewList.reloadData()
    }
    
    //MARK: TABLEVIEW DATASOURCE
    
    func numberOfSections(in tableView: UITableView) -> Int {return 1}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDisplayData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell.init(style: .value1, reuseIdentifier: "CELL")
       
        let dictCity = arrDisplayData[indexPath.row]
        cell.textLabel?.text = isOrigin ? dictCity[RES_sourceName] as! String : dictCity[RES_destinationName] as! String
        cell.selectionStyle = .none
        return cell
    }
    
    //MARK: TABLEVIEW DELEGATE
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        txtSearch.resignFirstResponder()
        txtSearch.text = ""
        let dictCity = arrDisplayData[indexPath.row]
        self.delegate?.selectedSourceAndDestination(dict: dictCity , isOrigin: self.isOrigin)
        if isOrigin {
            self.title = "Select Destination City"
            self.stSourceID = dictCity[RES_sourceId] as! String
            self.callGetDestinationsBasedOnSourceService()
            
        }
        else{
           let _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: TEXTFIELD DELEGATE
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true}
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text: String = textField.text!
        let resultingString: String = text.replacingCharacters(in: range.toRange(string: text), with: string)
         
        if textField.isEqual(txtSearch){self.searchCity(name: resultingString)}
        return true
    }
}
