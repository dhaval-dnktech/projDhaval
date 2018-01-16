//
//  MyOrderViewController.swift
//  Cubber
//
//  Created by dnk on 04/05/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class MyOrderViewController: UIViewController, AppNavigationControllerDelegate,UITableViewDelegate, UITableViewDataSource,  VKDatePopoverDelegate {
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
     var arrOrderList:Array = [typeAliasDictionary]()
    var dictFilterData:typeAliasDictionary = typeAliasDictionary()
    var dateFromSelected: String = ""
    var selectedToDate:String = ""
    var partnerId:String = ""
    var statusId:String = ""
    var stPartnerName:String = ""
    var statusName:String = ""
    var dictSelectedPartner = typeAliasDictionary()
    var dictSelectedStatus = typeAliasDictionary()
    var totalPages:Int = 0
    var currentPage:Int = 1
    var totalItems:Int = 0
    fileprivate var arrPartnerList = [typeAliasDictionary]()
    fileprivate var arrStatusList = [typeAliasDictionary]()
    fileprivate var arrPartnerListSelected = [typeAliasDictionary]()
    fileprivate var arrStatusListSelected = [typeAliasDictionary]()
    fileprivate var _vkDatePopOver = VKDatePopOver()
    //MY ORDER
    
    @IBOutlet var viewRightNav: UIView!
    @IBOutlet var viewMyOrder: UIView!
    @IBOutlet var lblNoDataFound: UILabel!
    @IBOutlet var tableViewOrder: UITableView!
    @IBOutlet var btnRefreshOrderList: UIButton!
    @IBOutlet var btnOrderFilter: UIButton!
    
    //FILTER
    
    @IBOutlet var viewFilter: UIView!
    @IBOutlet var txtDateFrom: UITextField!
    @IBOutlet var txtDateTo: UITextField!
    @IBOutlet var txtPartnerType: UITextField!
    @IBOutlet var txtOrderStatus: UITextField!
    @IBOutlet var txtOrderNumber: UITextField!
    
    @IBOutlet var constraintTableViewTopToViewFilter: NSLayoutConstraint!
    
    @IBOutlet var constraintTableViewTopToSuperView: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callOrderStatusList()
        self.tableViewOrder.estimatedRowHeight = HEIGHT_ORDER_LIST_CELL
        self.tableViewOrder.rowHeight = UITableViewAutomaticDimension
        self.tableViewOrder.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewOrder.register(UINib.init(nibName: CELL_IDENTIFIER_ORDER_CELL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_ORDER_CELL)
        self.btnRefreshOrderList.isHidden = true
        self.btnOrderFilter.isHidden = true
        constraintTableViewTopToViewFilter.priority = PRIORITY_LOW
        constraintTableViewTopToSuperView.priority = PRIORITY_HIGH
        self.viewFilter.isHidden = true
        self.view.layoutIfNeeded()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        let viewController  = self.navigationController?.viewControllers.last
        viewController?.view.layoutIfNeeded()
        self.sendScreenView(name: F_AFFILIATE_ORDERLIST)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.SetScreenName(name: F_AFFILIATE_ORDERLIST, stclass: F_AFFILIATE_ORDERLIST)

    }
    
    fileprivate func setNavigationBar() {
        self.setStatusBarBackgroundColor(color: UIColor.clear)
        obj_AppDelegate.navigationController.setCustomTitle("Shopping Order List")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.setRightView(self, view: viewRightNav, totalButtons: 2)
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    


    @IBAction func btnRefreshAction() {
        self.arrOrderList = [typeAliasDictionary]()
        self.dictFilterData = typeAliasDictionary()
        self.btnRefreshOrderList.isHidden = true
        statusId = ""
        statusName = ""
        partnerId = ""
        stPartnerName = ""
        tableViewOrder.reloadData()
        self.currentPage = 1
        self.callApplyFilter(dict: typeAliasDictionary())
        txtOrderStatus.text = ""
        txtPartnerType.text = ""
        txtOrderNumber.text = ""
        txtDateFrom.text = ""
        txtDateTo.text = ""
        viewFilter.isHidden = true
        constraintTableViewTopToViewFilter.priority = PRIORITY_LOW
        constraintTableViewTopToSuperView.priority = PRIORITY_HIGH
    }
    
    @IBAction func btnFilterAction() {
        btnOrderFilter.isSelected = !btnOrderFilter.isSelected
        if btnOrderFilter.isSelected {
            constraintTableViewTopToViewFilter.priority = PRIORITY_HIGH
            constraintTableViewTopToSuperView.priority = PRIORITY_LOW
            UIView.animate(withDuration: 0.3, animations: {
                self.viewFilter.isHidden = false
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
              
            })
        }
        else {
            constraintTableViewTopToViewFilter.priority = PRIORITY_LOW
            constraintTableViewTopToSuperView.priority = PRIORITY_HIGH
            UIView.animate(withDuration: 0.3, animations: {
                self.viewFilter.isHidden = true
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                
            })
        }
        self.setFilterData()
        self.view.layoutIfNeeded()
    }
    
    @IBAction func btnApplyAction() {
        
        if txtDateFrom.text!.isEmpty && txtDateTo.text!.isEmpty  && txtOrderNumber.text!.isEmpty && txtOrderStatus.text!.isEmpty && txtPartnerType.text!.isEmpty {
            return
        }
        
        self.hideKeyboard()
        btnOrderFilter.isSelected = false
        dictFilterData[REQ_FROM_DATE] = txtDateFrom.text?.trim() as AnyObject?
        dictFilterData[REQ_ORDER_ID] = txtOrderNumber.text?.trim() as AnyObject?
        dictFilterData[REQ_TO_DATE] = txtDateTo.text?.trim() as AnyObject?
        dictFilterData[REQ_PARTNER_ID] = partnerId as AnyObject?
        dictFilterData[REQ_PAGE_NO] = "1" as AnyObject?
        dictFilterData[REQ_COMMISSION_STATUS] = statusId as AnyObject?
        dictFilterData[RES_statusName] = statusName.trim() as AnyObject?
        dictFilterData[RES_partnerName] = stPartnerName.trim() as AnyObject?
        btnRefreshOrderList.isHidden = dictFilterData.isEmpty
        self.arrOrderList = [typeAliasDictionary]()
        self.currentPage = 1
        self.tableViewOrder.reloadData()
        self.callApplyFilter(dict: dictFilterData)
        viewFilter.isHidden = true
        constraintTableViewTopToViewFilter.priority = PRIORITY_LOW
        constraintTableViewTopToSuperView.priority = PRIORITY_HIGH
        self.hideKeyboard()
    }
    
    func setFilterData() {
     
            if !dictFilterData.isEmpty {
                statusName = dictFilterData[RES_statusName] as! String
                stPartnerName = dictFilterData[RES_partnerName] as! String
                txtOrderStatus.text = statusName
                txtPartnerType.text = stPartnerName
                txtOrderNumber.text =  dictFilterData[REQ_ORDER_ID] as? String
                txtDateTo.text =  dictFilterData[REQ_TO_DATE] as! String?
                txtDateFrom.text  = dictFilterData[REQ_FROM_DATE] as! String?
            }
            else{
                txtOrderStatus.text = ""
                txtPartnerType.text = ""
                txtOrderNumber.text = ""
                txtDateFrom.text = ""
                txtDateTo.text = ""
            }
    }
    
    func callOrderStatusList()
    {
        let params = [REQ_HEADER:DataModel.getAffiliateHeaderToken()]
        
        obj_OperationWeb.callRest_Affiliate_Api(methodName: JMETHOD_AffiliateStatus_List, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (obj_AppDelegate.navigationController?.view)!, onSuccess: { (dict) in
            DataModel.setPartnerList(array: dict[RES_partnerList] as! [typeAliasDictionary])
            DataModel.setStatusList(array: dict[RES_statusList] as! [typeAliasDictionary])
            DataModel.setAffiliateHeaderToken(dict[RES_token]! as! String)
            self.arrPartnerList = DataModel.getPartnerList()
            self.arrStatusList = DataModel.getStatusList()
            self.callApplyFilter(dict: typeAliasDictionary())
            self.btnRefreshOrderList.isHidden = true
        }, onFailure: { (code, dict) in
        }, onTokenExpire: {
            let _KDAlertView = KDAlertView()
             _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: MESSAGE_TYPE.WARNING); return
        })
    }
    
    func callApplyFilter(dict:typeAliasDictionary)
    {
        self.dictFilterData = dict
        let dictUserInfo: typeAliasDictionary = DataModel.getUserInfo()
        
        let params = [REQ_HEADER:DataModel.getAffiliateHeaderToken() ,REQ_USER_ID:dictUserInfo[RES_affiliateId] as! String,
                      REQ_FROM_DATE: dict.isEmpty ? "" : dict[REQ_FROM_DATE] as! String,
                      REQ_ORDER_ID:dict.isEmpty ? "" : dict[REQ_ORDER_ID] as! String,
                      REQ_TO_DATE:dict.isEmpty ? "" : dict[REQ_TO_DATE] as! String,
                      REQ_PARTNER_ID:dict.isEmpty ? "" : dict[REQ_PARTNER_ID] as! String,
                      REQ_PAGE_NO:String(self.currentPage),
                      REQ_COMMISSION_STATUS:dict.isEmpty ? "" : dict[REQ_COMMISSION_STATUS] as! String]
        
        obj_OperationWeb.callRest_Affiliate_Api(methodName: JMETHOD_AffiliateOrder_List, methodType: .POST, isAddToken: false, parameters: params, viewActivityParent: (self.navigationController?.view)!, onSuccess: { (dict) in
            DataModel.setAffiliateHeaderToken(dict[RES_token]! as! String)
            self.arrOrderList += dict[RES_orderList] as! [typeAliasDictionary]
            if !self.arrOrderList.isEmpty {
                self.totalItems = Int(dict[RES_totalItems] as! String)!
                self.totalPages = Int(dict[RES_totalPages] as! String)!
                self.btnOrderFilter.isHidden = false
                self.tableViewOrder.isHidden = false
                self.tableViewOrder.reloadData()
                if !self.dictFilterData.isEmpty { self.btnRefreshOrderList.isHidden = false }
                else { self.btnRefreshOrderList.isHidden = true }
            }
        }, onFailure: { (code, dict) in
            self.lblNoDataFound.text = dict[RES_message]! as? String
            self.tableViewOrder.isHidden = true
            if !self.dictFilterData.isEmpty {self.btnRefreshOrderList.isHidden = false}
            else { self.btnRefreshOrderList.isHidden = true ; self.btnOrderFilter.isHidden = true}
            let viewController  = self.navigationController?.viewControllers.last
            viewController?.view.layoutIfNeeded()
            
        }, onTokenExpire: {
                let _KDAlertView = KDAlertView()
            _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING)
            _KDAlertView.didClick(completion: { (isClicked) in
                self.obj_AppDelegate.navigationController.popViewController(animated: true)
            })
        })
    }
    
    func showDatePopover(isDateFrom:Bool){
        
        let maxDate:String = VKDatePopOver.getDate(VKDateFormat.YYYYMMDD, date: Date())
        if isDateFrom {
            self._vkDatePopOver.initSetFrame(dateFromSelected, mininumDate: "", maximumDate: maxDate, dateFormat: .YYYYMMDD, dateType: .DATE_FROM, isOutSideClickedHidden: false, isShowCancel: false)
        }
        else{
            self._vkDatePopOver.initSetFrame(selectedToDate, mininumDate: dateFromSelected, maximumDate: maxDate, dateFormat: .YYYYMMDD, dateType: .DATE_TO, isOutSideClickedHidden: false, isShowCancel: false)
        }
        self._vkDatePopOver.delegate = self
        obj_AppDelegate.navigationController!.view.addSubview(_vkDatePopOver)
    }
    
    fileprivate func hideKeyboard() {
        txtOrderNumber.resignFirstResponder()
        txtOrderStatus.resignFirstResponder()
        txtPartnerType.resignFirstResponder()
        txtDateTo.resignFirstResponder()
        txtDateFrom.resignFirstResponder()
    }


    //MARK: UITABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return self.arrOrderList.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyOrderCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_ORDER_CELL) as! MyOrderCell;
        let dict: typeAliasDictionary = arrOrderList[(indexPath as NSIndexPath).row]
        cell.lblOrderNO.text = "Order Number. \(dict[RES_orderNumber] as! String)"
        cell.lblDate.text = dict[RES_orderDate] as? String
        cell.lblPartner.text = dict[RES_partnerName] as? String
        cell.lblExpctedPaymentDate.text = dict[RES_expectedPaymentDate] as? String
  
        cell.btnStatus.titleLabel?.textColor = UIColor.white
        cell.btnStatus.backgroundColor = (dict[RES_statusColor] as? String)?.hexStringToUIColor()
        cell.btnStatus.setTitle(dict[RES_orderStatus] as? String, for: UIControlState.normal)
        let stCommision: String = dict[RES_commission] as! String
        cell.lblCommision.text = stCommision == "" ? "" : "\(dict[RES_commission] as! String)"
        cell.lblCommisionDate.attributedText = (dict[RES_expectedPaymentDateHtml] as! String).htmlAttributedString
        
        cell.constraintLblComissionDateHeight.constant =  ((cell.lblCommisionDate.text?.textHeight(cell.lblCommisionDate.frame.width, textFont: cell.lblCommisionDate.font)))! + 15
        
        let stImageUrl: String = dict[RES_partnerThumbImage] as! String
        if stImageUrl.count != 0 {
            cell.imageViewPartner.sd_setImage(with: stImageUrl.convertToUrl() as URL!, placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, progress:
                { (receivedSize, expectedSize) in cell.activityIndicator.startAnimating() })
            { (image, error, cacheType, imageURL) in
                if image == nil { cell.imageViewPartner.image = UIImage(named: "logo") }
                else { cell.imageViewPartner.image = image! }
                cell.activityIndicator.stopAnimating()
            }
        }
        else { cell.imageViewPartner.image = UIImage(named: "logo") }
        
        if indexPath.row == self.arrOrderList.count - 1 {
            let page: Int = self.currentPage + 1
            if page <= self.totalPages { self.currentPage = page
                self.callApplyFilter(dict: dictFilterData)
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }

    
    //MARK: UITABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return UITableViewAutomaticDimension }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero }
    
    @IBAction func btnCancelFilterAction() {
        self.callApplyFilter(dict: typeAliasDictionary())
    }
    
    //MARK: TEXTFIELD DELEGATE

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.hideKeyboard()
        if textField == txtPartnerType {
            let dkSelection:DKSelectionView = DKSelectionView.init(frame:  UIScreen.main.bounds, arrRegion: arrPartnerList, title: "Partner Type", dictKey: [VK_UNIQUE_KEY:RES_partnerId,VK_VALUE_KEY:RES_partnerName])
            dkSelection.didSelecteOption(completion: { (dictOption) in
                if !dictOption.isEmpty {
                    self.dictSelectedPartner = dictOption
                    self.txtPartnerType.text = dictOption[RES_partnerName] as! String?
                    self.partnerId = dictOption[RES_partnerId] as! String
                    self.stPartnerName = (self.txtPartnerType.text?.trim())!
                }
            })
        }
        else if textField == txtOrderStatus {
            let dkSelection:DKSelectionView = DKSelectionView.init(frame:  UIScreen.main.bounds, arrRegion: arrStatusList, title: "Order Status", dictKey: [VK_UNIQUE_KEY:RES_statusId,VK_VALUE_KEY:RES_statusName])
            dkSelection.didSelecteOption(completion: { (dictOption) in
                if !dictOption.isEmpty {
                    self.dictSelectedPartner = dictOption
                    self.txtOrderStatus.text = dictOption[RES_statusName] as! String?
                    self.statusId = dictOption[RES_statusId] as! String
                    self.statusName = (self.txtOrderStatus.text?.trim())!
                }
            })
        }
        else if textField == txtDateFrom {self.showDatePopover(isDateFrom: true)}
        else if textField == txtDateTo { self.showDatePopover(isDateFrom: false) }
            
        else if textField == txtOrderNumber{ return true }
        else{ return true }
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtOrderNumber {
            txtOrderNumber.resignFirstResponder()
        }
        return true
    }
    //MARK: DATAPOPOVER DELEGATE
    func vkDatePopoverSelectedDate(_ vkDate: Date, strDate: String, dateType: DATE_TYPE, dateFormat: DateFormatter) {
        
        if dateType == .DATE_FROM {
            dateFromSelected = strDate
            txtDateFrom.text = strDate
            txtDateTo.text = ""
            selectedToDate = ""
            
        }
        else if dateType == .DATE_TO {
            selectedToDate = strDate
            txtDateTo.text = strDate
        }
    }
    
    func vkDatePopoverClearDate(_ dateType: DATE_TYPE) { }
    func vkDatePopoverSelectedDate(_ vkDate: Date, strDate: String) {}
    
   }
