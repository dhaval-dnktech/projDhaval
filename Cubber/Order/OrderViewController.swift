//
//  OrderViewController.swift
//  Cubber
//
//  Created by Vyas Kishan on 06/08/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, OrderCellDelegate , AppNavigationControllerDelegate , VKDatePopoverDelegate{

    //MARK: PROPERTIES
    
    @IBOutlet var viewFilter: UIView!
    @IBOutlet var tableViewOrders: UITableView!
    @IBOutlet var viewNoDataFound: UIView!
    @IBOutlet var txtDateFrom: UITextField!
    @IBOutlet var txtDateTo: UITextField!
    @IBOutlet var txtOrderType: UITextField!
    @IBOutlet var txtOrderStatus: UITextField!
    @IBOutlet var txtOrderNumber: UITextField!
    
    @IBOutlet var constraintTableViewTopToViewFilter: NSLayoutConstraint!
    
    @IBOutlet var constraintTableViewTopToSuperView: NSLayoutConstraint!
    //MARK: VARIABLES
     fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var pageSize: Int = 0
    fileprivate var totalPages: Int = 0
    fileprivate var totalRecords: Int = 0
    fileprivate var currentPage: Int = 0
    fileprivate var _vkDatePopOver = VKDatePopOver()
    fileprivate var arrOrders = [typeAliasDictionary]()
    fileprivate var dictFilter = typeAliasStringDictionary()
    var dictSelectedPartner = typeAliasDictionary()
    @IBOutlet var viewRightNav: UIView!
    @IBOutlet var btnRefreshOrderList: UIButton!
    @IBOutlet var btnOrderFilter: UIButton!
    var arrOrderType = [typeAliasDictionary]()
    var arrOrderStatus = [typeAliasDictionary]()
    var dateFromSelected:String = ""
    var selectedToDate: String = ""
    var stOrderName:String = ""
    var stOrderId: String = ""
    var stStatusName:String = ""
    var stStatusId: String = ""

    
    //MARK: VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
       self.callOrderHistoryService()
        viewFilter.isHidden = true
        constraintTableViewTopToViewFilter.priority = PRIORITY_LOW
        constraintTableViewTopToSuperView.priority = PRIORITY_HIGH
        self.view.layoutIfNeeded()
        self.tableViewOrders.rowHeight = UITableViewAutomaticDimension
        self.tableViewOrders.estimatedRowHeight = HEIGHT_ORDER_CELL
        self.tableViewOrders.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewOrders.register(UINib.init(nibName: CELL_IDENTIFIER_ORDER, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_ORDER)
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.currentPage = 1
       // self.callOrderHistoryService()
        btnRefreshOrderList.isHidden = dictFilter.isEmpty
        self.setNavigationBar()
        self.sendScreenView(name: SCREEN_ORDERSUMMARY)
    }
    
    //MARK: - APP NAVIGATION CONTROLLER DELEGATE
    fileprivate func setNavigationBar() {
        obj_AppDelegate.navigationController.setRightView(self, view: viewRightNav, totalButtons: 2)
        obj_AppDelegate.navigationController.navigationDelegate = self
        obj_AppDelegate.navigationController.setCustomTitle("Your Order")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.SetScreenName(name: F_ORDERLIST, stclass: F_ORDERLIST)
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnRefreshAction() {
        
        self.currentPage = 1
        self.arrOrders = [typeAliasDictionary]()
        self.dictFilter = typeAliasStringDictionary()
        self.btnRefreshOrderList.isHidden = true
        tableViewOrders.reloadData()
        self.callOrderHistoryService()
        viewFilter.isHidden = true
        constraintTableViewTopToViewFilter.priority = PRIORITY_LOW
        constraintTableViewTopToSuperView.priority = PRIORITY_HIGH
        txtDateFrom.text = ""
        txtDateTo.text = ""
        txtOrderType.text = ""
        txtOrderStatus.text = ""
        txtOrderNumber.text = ""
        stOrderId = ""
        stStatusId = ""
        self.hideKeyboard()
    }
    
    @IBAction func btnApplyAction() {
        
        self.hideKeyboard()
        
        let stFromDate:String = (txtDateFrom.text?.trim())!
        let stToDate:String = (txtDateTo.text?.trim())!
        let stOrderNo:String = (txtOrderNumber.text?.trim())!
        if stFromDate.count == 0 &&  stToDate.count == 0 && stOrderNo.count == 0 && self.stOrderId.count == 0 && self.stStatusId.count == 0{return}
        btnOrderFilter.isSelected = false
        dictFilter[REQ_FROM_DATE] = txtDateFrom.text?.trim()
        dictFilter[REQ_TO_DATE] = txtDateTo.text?.trim()
        dictFilter[REQ_ORDER_TYPE_ID] = self.stOrderId.isEmpty ? "" : stOrderId
        dictFilter[REQ_ORDER_STATUS] = self.stStatusId.isEmpty ? "" : stStatusId
        dictFilter[REQ_ORDER_ID] = txtOrderNumber.text?.trim()
        
        btnRefreshOrderList.isHidden = dictFilter.isEmpty
        self.currentPage = 1
        self.arrOrders = [typeAliasDictionary]()
        tableViewOrders.reloadData()
        self.callOrderHistoryService()
        viewFilter.isHidden = true
        constraintTableViewTopToViewFilter.priority = PRIORITY_LOW
        constraintTableViewTopToSuperView.priority = PRIORITY_HIGH
        self.hideKeyboard()
    }
    
    fileprivate func hideKeyboard() {
        txtOrderNumber.resignFirstResponder()
        txtOrderStatus.resignFirstResponder()
        txtOrderType.resignFirstResponder()
        txtDateTo.resignFirstResponder()
        txtDateFrom.resignFirstResponder()
    }

    @IBAction func btnFilterAction() {
        
        btnOrderFilter.isSelected = !btnOrderFilter.isSelected
        if btnOrderFilter.isSelected {
            constraintTableViewTopToViewFilter.priority = PRIORITY_HIGH
            constraintTableViewTopToSuperView.priority = PRIORITY_LOW
            UIView.animate(withDuration: 0.3, animations: { 
                self.viewFilter.isHidden = false
            }, completion: { (completed) in
                 self.view.layoutIfNeeded()
            })
        }
        else {
            constraintTableViewTopToViewFilter.priority = PRIORITY_LOW
            constraintTableViewTopToSuperView.priority = PRIORITY_HIGH
            UIView.animate(withDuration: 0.3, animations: {
                self.viewFilter.isHidden = true
            }, completion: { (completed) in
                self.view.layoutIfNeeded()
            })
        }
        self.view.layoutIfNeeded()
        if obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_getAllOrderType) {
            self.callOrderTypeService()
        }
        else{
            let dictAllOrder = DataModel.getAllOrderTypeResponse()
            let arrData: Array<typeAliasDictionary> = dictAllOrder[RES_orderType] as! Array<typeAliasDictionary>
            self.arrOrderType = arrData
            let arrStatus: Array<typeAliasDictionary> = dictAllOrder[RES_orderStatusList] as! Array<typeAliasDictionary>
            self.arrOrderStatus = arrStatus
              if !dictFilter.isEmpty{ self.setFilterData() }
        }
}
    
    func setFilterData() {
        
        self.dateFromSelected = dictFilter[REQ_FROM_DATE]!
        self.selectedToDate = dictFilter[REQ_TO_DATE]!
        txtOrderNumber.text = dictFilter[REQ_ORDER_ID]!
        txtDateTo.text =  self.selectedToDate
        txtDateFrom.text =  self.dateFromSelected
        
        if dictFilter[REQ_ORDER_STATUS] != nil && dictFilter[REQ_ORDER_STATUS] != ""{
            let arrSel:[typeAliasDictionary] = arrOrderStatus.filter({ (dict) -> Bool in
                return dict[RES_orderStatusID] as? String == dictFilter[RES_orderStatusID]
            })
            if !arrSel.isEmpty{
                txtOrderStatus.text = arrSel.first?[RES_statusName] as? String
            }
        }
        if dictFilter[REQ_ORDER_TYPE_ID] != nil && dictFilter[REQ_ORDER_TYPE_ID] != ""{
            let arrSel:[typeAliasDictionary] = arrOrderType.filter({ (dict) -> Bool in
                 return dict[RES_orderTypeID] as? String == dictFilter[REQ_ORDER_TYPE_ID]
            })
            if !arrSel.isEmpty{
             txtOrderType.text = arrSel.first?[RES_orderTypeName] as? String
            }
        }
    }
    
    //MARK: CUSTOME METHODS
    fileprivate func callOrderHistoryService() {
        
        let userInfo: typeAliasDictionary = DataModel.getUserInfo()
        var params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID: userInfo[RES_userID] as! String,
                      REQ_PAGE_NO: "\(currentPage)",
                      REQ_ORDER_TYPE_ID: "",
                      REQ_ORDER_ID:"",
                      REQ_ORDER_STATUS:"",
                      REQ_TO_DATE:"",
                      REQ_FROM_DATE:""]
        
        if !dictFilter.isEmpty {
            params[REQ_ORDER_TYPE_ID] = dictFilter[REQ_ORDER_TYPE_ID]
            params[REQ_ORDER_ID] = dictFilter[REQ_ORDER_ID]
            params[REQ_ORDER_STATUS] = dictFilter[REQ_ORDER_STATUS]
            params[REQ_TO_DATE] = dictFilter[REQ_TO_DATE]
            params[REQ_FROM_DATE] = dictFilter[REQ_FROM_DATE]
        }
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_ListUserOrders, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
            
            DataModel.setHeaderToken(dict[RES_token] as! String)
            self.pageSize = Int(dict[RES_par_page] as! String)!
            self.totalPages = Int(dict[RES_total_pages] as! String)!
            self.totalRecords = Int(dict[RES_total_items] as! String)!
            let arrData: Array<typeAliasDictionary> = dict[RES_data] as! Array<typeAliasDictionary>
            self.arrOrders += arrData
            self.tableViewOrders.reloadData()
             self.viewNoDataFound.isHidden = true
            
        }, onFailure: { (code, dict) in
             self.viewNoDataFound.isHidden = false
        }) {let _KDAlertView = KDAlertView()
            _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return }
    }
    
    fileprivate func callOrderTypeService() {
        
        let params = [REQ_HEADER:DataModel.getHeaderToken()]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_getAllOrderType, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: obj_AppDelegate.navigationController.view, onSuccess: { (dict) in
            
            DataModel.setHeaderToken(dict[RES_token] as! String)
            let arrData: Array<typeAliasDictionary> = dict[RES_orderType] as! Array<typeAliasDictionary>
            self.arrOrderType = arrData
            let arrStatus: Array<typeAliasDictionary> = dict[RES_orderStatusList] as! Array<typeAliasDictionary>
            self.arrOrderStatus = arrStatus
            DataModel.setAllOrderTypeResponse(dict: dict)
            if !self.self.dictFilter.isEmpty{ self.setFilterData() }
            self.obj_AppDelegate.updateDictService(serviceName: JMETHOD_getAllOrderType)
            
        }, onFailure: { (code, dict) in
            
        }) {let _KDAlertView = KDAlertView()
            _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return
        }
    }

    
    fileprivate func showRechargeView(_ button: UIButton) {
        
        let gtmModel = GTMModel()
        let section: Int = Int(button.accessibilityLabel!)!
        let index: Int = Int(button.accessibilityIdentifier!)!
        
        let dictOrderDetail: typeAliasDictionary = self.arrOrders[section]
        let category: String = dictOrderDetail[RES_orderTypeID] as! String
        let arrItems: Array<typeAliasDictionary> = dictOrderDetail[RES_items] as! Array<typeAliasDictionary>
        let dictItem: typeAliasDictionary = arrItems[index]
        
        let rechargeVC = RechargeViewController(nibName: "RechargeViewController", bundle: nil)
        
        if category == VAL_ORDERTYPE_MOBILE
        {
            let cartPrepaidPostpaid: String = dictOrderDetail[RES_subCategoryId] as! String
            
            rechargeVC.mobile_CardOperator = dictOrderDetail[RES_operatorName] as! String
            rechargeVC.mobile_CardRegionName = dictOrderDetail[RES_regionName] as! String
            rechargeVC.mobile_CardPrepaidPostpaid = cartPrepaidPostpaid == VAL_RECHARGE_PREPAID ? "Prepaid" : "Postpaid"
            rechargeVC.cart_PrepaidPostpaid = cartPrepaidPostpaid
            rechargeVC.cart_PlanTypeID = dictOrderDetail[RES_planTypeId] as! String
            rechargeVC.cart_MobileNo = dictOrderDetail[RES_mobileNo] as! String
            rechargeVC.cart_TotalAmount = dictItem[RES_amount] as! String
            rechargeVC.cart_OperatorId = dictOrderDetail[RES_operatorID] as! String
            rechargeVC.cart_RegionId = dictOrderDetail[RES_regionID] as! String
            rechargeVC.cart_CategoryId = dictOrderDetail[RES_operatorCategoryMasterId] as! String
            rechargeVC.cart_RegionPlanId =  dictItem[RES_regionPlanID] as! String
            rechargeVC.cart_PlanValue =  dictItem[RES_amount] as! String
            rechargeVC.cart_Extra1 = dictItem[RES_extra1] as! String
            rechargeVC.cart_Extra2 = dictItem[RES_extra2] as! String
            rechargeVC._RECHARGE_TYPE = RECHARGE_TYPE.MOBILE_RECHARGE
            
            gtmModel.list = "Mobile Section"

        }
        else if category == VAL_ORDERTYPE_DTH {
            
            rechargeVC.mobile_CardOperator = dictOrderDetail[RES_operatorName] as! String
            rechargeVC.mobile_CardRegionName = dictOrderDetail[RES_regionName] as! String
            rechargeVC.mobile_CardPrepaidPostpaid = VAL_RECHARGE_PREPAID_CAPTION
            rechargeVC.cart_PrepaidPostpaid = VAL_RECHARGE_PREPAID
            rechargeVC.cart_PlanTypeID = dictOrderDetail[RES_planTypeId] as! String
            rechargeVC.cart_MobileNo = dictOrderDetail[RES_mobileNo] as! String
            rechargeVC.cart_TotalAmount = dictItem[RES_amount] as! String
            rechargeVC.cart_OperatorId = dictOrderDetail[RES_operatorID] as! String
            rechargeVC.cart_RegionId = dictOrderDetail[RES_regionID] as! String
            rechargeVC.cart_CategoryId = dictOrderDetail[RES_operatorCategoryMasterId] as! String
            rechargeVC.cart_Extra1 = dictItem[RES_extra1] as! String
            rechargeVC.cart_Extra2 = dictItem[RES_extra2] as! String
            rechargeVC.cart_RegionPlanId =  dictItem[RES_regionPlanID] as! String
            rechargeVC.cart_PlanValue =  dictItem[RES_amount] as! String
            rechargeVC._RECHARGE_TYPE = RECHARGE_TYPE.DTH_RECHARGE
             gtmModel.list = "DTH Section"
        }
     
        else if category == VAL_ORDERTYPE_LANDLINE {
            
            rechargeVC.mobile_CardOperator = dictOrderDetail[RES_operatorName] as! String
            rechargeVC.mobile_CardRegionName = dictOrderDetail[RES_regionName] as! String
            rechargeVC.mobile_CardPrepaidPostpaid = VAL_RECHARGE_POSTPAID_CAPTION
            rechargeVC.cart_PrepaidPostpaid = VAL_RECHARGE_POSTPAID
            rechargeVC.cart_PlanTypeID = "0"
            rechargeVC.cart_TotalAmount = dictItem[RES_amount] as! String
            rechargeVC.cart_OperatorId = dictOrderDetail[RES_operatorID] as! String
            rechargeVC.cart_RegionId = dictOrderDetail[RES_regionID] as! String
            rechargeVC.cart_CategoryId = dictOrderDetail[RES_operatorCategoryMasterId] as! String
            rechargeVC.cart_Extra1 = dictItem[RES_extra1] as! String
            rechargeVC.cart_Extra2 = dictItem[RES_extra2] as! String
            rechargeVC.cart_RegionPlanId = "0"
            rechargeVC.cart_PlanValue =  dictItem[RES_amount] as! String
            rechargeVC._RECHARGE_TYPE = RECHARGE_TYPE.LANDLINE_BROABAND
            
            gtmModel.list = "Broadband And Landline Section"
        }
            
        else if category == VAL_ORDERTYPE_DATACARD {
            
            let cartPrepaidPostpaid: String = dictOrderDetail[RES_subCategoryId] as! String
            
            rechargeVC.mobile_CardOperator = dictOrderDetail[RES_operatorName] as! String
            rechargeVC.mobile_CardRegionName = dictOrderDetail[RES_regionName] as! String
            rechargeVC.mobile_CardPrepaidPostpaid = cartPrepaidPostpaid == VAL_RECHARGE_PREPAID ? "Prepaid" : "Postpaid"
            rechargeVC.cart_PrepaidPostpaid = cartPrepaidPostpaid
            rechargeVC.cart_PlanTypeID = dictOrderDetail[RES_planTypeId] as! String
            rechargeVC.cart_MobileNo = dictOrderDetail[RES_mobileNo] as! String
            rechargeVC.cart_TotalAmount = dictItem[RES_amount] as! String
            rechargeVC.cart_OperatorId = dictOrderDetail[RES_operatorID] as! String
            rechargeVC.cart_RegionId = dictOrderDetail[RES_regionID] as! String
            rechargeVC.cart_CategoryId = dictOrderDetail[RES_operatorCategoryMasterId] as! String
            rechargeVC.cart_RegionPlanId =  dictItem[RES_regionPlanID] as! String
            rechargeVC.cart_PlanValue =  dictItem[RES_amount] as! String
            rechargeVC._RECHARGE_TYPE = RECHARGE_TYPE.DATA_CARD
            
            gtmModel.list = "DataCard Section"
        }
            
        else if category == VAL_ORDERTYPE_INSURANCE {
            
            let cartPrepaidPostpaid: String = dictOrderDetail[RES_subCategoryId] as! String
            
            rechargeVC.mobile_CardOperator = dictOrderDetail[RES_operatorName] as! String
            rechargeVC.mobile_CardRegionName = dictOrderDetail[RES_regionName] as! String
            rechargeVC.mobile_CardPrepaidPostpaid = cartPrepaidPostpaid == VAL_RECHARGE_PREPAID ? "Prepaid" : "Postpaid"
            rechargeVC.cart_PrepaidPostpaid = cartPrepaidPostpaid
            rechargeVC.cart_PlanTypeID = dictOrderDetail[RES_planTypeId] as! String
            rechargeVC.cart_MobileNo = dictOrderDetail[RES_mobileNo] as! String
            rechargeVC.cart_TotalAmount = dictItem[RES_amount] as! String
            rechargeVC.cart_OperatorId = dictOrderDetail[RES_operatorID] as! String
            rechargeVC.cart_RegionId = dictOrderDetail[RES_regionID] as! String
            rechargeVC.cart_CategoryId = dictOrderDetail[RES_operatorCategoryMasterId] as! String
            rechargeVC.cart_RegionPlanId =  dictItem[RES_regionPlanID] as! String
            rechargeVC.cart_PlanValue =  dictItem[RES_amount] as! String
            rechargeVC._RECHARGE_TYPE = RECHARGE_TYPE.INSURANCE
            
            gtmModel.list = "Insurance Section"
        }
        
        else if category == VAL_ORDERTYPE_ADD_MONEY {
        
            rechargeVC.mobile_CardOperator = "Add Money"
            rechargeVC.mobile_CardRegionName = ""
            rechargeVC.mobile_CardPrepaidPostpaid = ""
            rechargeVC.cart_PrepaidPostpaid = VAL_RECHARGE_NONE
            rechargeVC.cart_PlanTypeID = "0"
            rechargeVC.cart_MobileNo = ""
            rechargeVC.cart_TotalAmount = dictItem[RES_amount] as! String
            rechargeVC.cart_OperatorId = "0"
            rechargeVC.cart_RegionId = "0"
            rechargeVC.cart_CategoryId = "0"
            rechargeVC.cart_RegionPlanId =  "0"
            rechargeVC.cart_PlanValue = dictItem[RES_amount] as! String
            rechargeVC._RECHARGE_TYPE = RECHARGE_TYPE.ADD_MONEY
            
            gtmModel.list = "AddMoney Section"

        }
       else if category == VAL_ORDERTYPE_BUS_BOOKING
        {
            let dictSource:typeAliasStringDictionary = [RES_sourceId:dictOrderDetail[RES_regionID]! as! String,
                                                        RES_sourceName:dictOrderDetail[RES_sourceName]! as! String]
            let dictDest:typeAliasStringDictionary =    [RES_destinationId:dictOrderDetail[RES_planTypeId]! as! String,
                                                         RES_destinationName:dictOrderDetail[RES_destinationName]! as! String]
            
            let busBookVC = BusBookingViewController(nibName: "BusBookingViewController", bundle: nil)
            busBookVC.dictSource = dictSource
            busBookVC.dictDestination = dictDest
            busBookVC.stSource = dictOrderDetail[RES_sourceName] as! String
            busBookVC.stDestination = dictOrderDetail[RES_destinationName] as! String
            self.navigationController?.pushViewController(busBookVC, animated: true)
            return

        }
         else if category == VAL_ORDERTYPE_FLIGHT
         {
            let dictSource:typeAliasStringDictionary = [RES_AirportCode:dictOrderDetail[RES_sourceId]! as! String,
                                                        RES_regionName:dictOrderDetail[RES_sourceName]! as! String,
                                                        RES_regionID:dictOrderDetail[RES_regionID]! as! String,
                                                        RES_countryID:dictOrderDetail[RES_sourceCountryId]! as! String]
            let dictDest:typeAliasStringDictionary = [RES_AirportCode:dictOrderDetail[RES_destinationId]! as! String,
                                                      RES_regionName:dictOrderDetail[RES_destinationName]! as! String,
                                                      RES_regionID:dictOrderDetail[RES_planTypeId]! as! String,
                                                      RES_countryID:dictOrderDetail[RES_destinationCountryId]! as! String]
            
            let flightVC = FlightBookingViewController(nibName: "FlightBookingViewController", bundle: nil)
            flightVC.dictOrigin = dictSource as typeAliasDictionary
            flightVC.dictDestination = dictDest as typeAliasDictionary
            self.navigationController?.pushViewController(flightVC, animated: true)
            return
        }

        // SET GTMMODEL DATA FOR ADD TO CART
        
        gtmModel.category = rechargeVC.mobile_CardPrepaidPostpaid
        gtmModel.price = rechargeVC.cart_TotalAmount
        gtmModel.product_Id = DataModel.getUserInfo()[RES_userID] as! String
        gtmModel.brand = rechargeVC.mobile_CardOperator
        gtmModel.variant = rechargeVC.cart_MobileNo
        gtmModel.dimension3 = "\(rechargeVC.mobile_CardOperator):\(rechargeVC.mobile_CardRegionName)"
        gtmModel.dimension4 = "0"
        
        if category == VAL_ORDERTYPE_ADD_MONEY {
            gtmModel.list = "Wallet"
            gtmModel.ee_type = GTM_EE_TYPE_WALLET
            gtmModel.name = GTM_ADDMONEY
            gtmModel.brand = GTM_ADDMONEY
            gtmModel.category = GTM_EE_TYPE_WALLET
        }
        
        if category != VAL_ORDERTYPE_BUS_BOOKING && category != VAL_ORDERTYPE_FLIGHT {
            
            GTMModel.pushProductDetail(gtmModel: gtmModel)
            GTMModel.pushAddToCart(gtmModel: gtmModel)
        }
        
        
        rechargeVC.stImageUrl =  dictItem[RES_image] as! String
        self.navigationController?.pushViewController(rechargeVC, animated: true)
    }
    
    //MARK: UITABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int { return self.arrOrders.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return self.arrOrders[section][RES_items]!.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OrderCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_ORDER) as! OrderCell;
        cell.delegate = self
        
        let dictOrder: typeAliasDictionary = self.arrOrders[(indexPath as NSIndexPath).section]
        let arrItems: Array<typeAliasDictionary> = dictOrder[RES_items] as! Array<typeAliasDictionary>
        let dictItem: typeAliasDictionary = arrItems[(indexPath as NSIndexPath).row]
        let orderTypeId: Int = (Int(dictOrder[RES_orderTypeID] as! String))!
        let itemStatus: Int = (Int(dictItem[RES_orderStatusID] as! String))!
       
        
        for btn in cell.btnCollection {
            btn.accessibilityIdentifier = String((indexPath as NSIndexPath).row)
            btn.accessibilityLabel = String((indexPath as NSIndexPath).section)
        }
        
        cell.lblItemTitle.text = dictItem[RES_title] as? String
        var bgColor: UIColor = UIColor.clear
        var textColor: UIColor = UIColor.white
        
        if orderTypeId == RECHARGE_TYPE.MEMBERSHIP_FEES.rawValue ||  orderTypeId == RECHARGE_TYPE.ELECTRICITY_BILL.rawValue ||  orderTypeId == RECHARGE_TYPE.GAS_BILL.rawValue  ||  orderTypeId == RECHARGE_TYPE.EVENT.rawValue || orderTypeId == RECHARGE_TYPE.DONATE_MONEY.rawValue || orderTypeId == RECHARGE_TYPE.SHOPPING_CASHBACK.rawValue  {
            cell.btnRepeat.isHidden = true
            cell.btnRetry.isHidden = true
            
            if itemStatus == ORDER_STATUS.SUCCESS.rawValue { bgColor = COLOUR_ORDER_STATUS_SUCCESS }
            else if itemStatus == ORDER_STATUS.FAILED.rawValue { bgColor = COLOUR_ORDER_STATUS_FAILURE }
            else if itemStatus == ORDER_STATUS.AWAITING.rawValue { bgColor = COLOUR_ORDER_STATUS_AWAITING }
            else if itemStatus == ORDER_STATUS.FAILED.rawValue { bgColor = COLOUR_ORDER_STATUS_FAILURE }
            else if itemStatus == ORDER_STATUS.PROCESSING.rawValue { bgColor = COLOUR_ORDER_STATUS_PROCESSING }
            else if itemStatus == ORDER_STATUS.REFUNDED.rawValue { bgColor = COLOUR_ORDER_STATUS_REFUNDED; textColor = UIColor.white;
            }
            else if itemStatus == ORDER_STATUS.CANCELLED.rawValue { bgColor = COLOUR_ORDER_STATUS_CANCELLED; textColor = UIColor.white;
            }
        }
        else {
            if itemStatus == ORDER_STATUS.SUCCESS.rawValue {
                cell.btnRepeat.isHidden = false
                cell.btnRetry.isHidden = true
                
                bgColor = COLOUR_ORDER_STATUS_SUCCESS
            }
            else if itemStatus == ORDER_STATUS.FAILED.rawValue {
                cell.btnRepeat.isHidden = true
                cell.btnRetry.isHidden = false
                
                bgColor = COLOUR_ORDER_STATUS_FAILURE
            }
            else if itemStatus == ORDER_STATUS.AWAITING.rawValue {
                cell.btnRepeat.isHidden = true
                cell.btnRetry.isHidden = true
                
                bgColor = COLOUR_ORDER_STATUS_AWAITING
            }
            else if itemStatus == ORDER_STATUS.PROCESSING.rawValue {
                cell.btnRepeat.isHidden = true
                cell.btnRetry.isHidden = true
                
                bgColor = COLOUR_ORDER_STATUS_PROCESSING
            }
            else if itemStatus == ORDER_STATUS.REFUNDED.rawValue {
                cell.btnRepeat.isHidden = true
                cell.btnRetry.isHidden = true
                
                bgColor = COLOUR_ORDER_STATUS_REFUNDED
                textColor = UIColor.white//RGBCOLOR(178, g: 182, b: 182)
            }
            else if itemStatus == ORDER_STATUS.CANCELLED.rawValue {
                cell.btnRepeat.isHidden = true
                cell.btnRetry.isHidden = true
                
                bgColor = COLOUR_ORDER_STATUS_CANCELLED
                textColor = UIColor.white
            }
            else {
                cell.btnRepeat.isHidden = true
                cell.btnRetry.isHidden = true
            }
        }
        
        //DUMMY
       // cell.btnRepeat.isHidden = true
       // cell.btnRetry.isHidden = true
        //
        
        var stStatus: String = dictItem[RES_orderStatus] as! String
        stStatus = " \(stStatus.trim().uppercased()) "
        cell.btnItemStatus.setTitle(stStatus, for: UIControlState())
        cell.btnItemStatus.backgroundColor = bgColor
        cell.btnItemStatus.setTitleColor(textColor, for: UIControlState.normal)
        cell.lblOrderDate.text = dictOrder[RES_orderDate]! as? String
        
        cell.imageViewItem.sd_setImage(with: (dictItem[RES_image] as! String).convertToUrl() as URL!, placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, progress:
            { (receivedSize, expectedSize) in cell.activityIndicator.startAnimating() })
        { (image, error, cacheType, imageURL) in
            
            if image == nil { cell.imageViewItem.image = UIImage(named: "logo") }
            else { cell.imageViewItem.image = image! }
            cell.activityIndicator.stopAnimating()
        }
        
        if (indexPath as NSIndexPath).section == self.arrOrders.count - 1 {
            let page: Int = self.currentPage + 1
            if page <= self.totalPages { currentPage = page; self.callOrderHistoryService(); }
        }
      /*  let amount:Double = Double(dictItem[RES_amount] as! String)! + Double(dictItem.isKeyNull(RES_ServiceTax) ? "0" : dictItem[RES_ServiceTax] as! String)! +  Double(dictItem.isKeyNull(RES_convenienceFee) ? "0" : dictItem[RES_convenienceFee] as! String)!*/
       // let stAmount = String.init(format: "%.2f", amount)
        cell.lblAmount.text = "\(RUPEES_SYMBOL) \(dictItem[RES_displayTotal] as! String)"
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutIfNeeded()
        return cell
    }
    
    //MARK: UITABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return UITableViewAutomaticDimension }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict: typeAliasDictionary = self.arrOrders[(indexPath as NSIndexPath).section]
        let orderDetailVC = OrderDetailViewController(nibName: "OrderDetailViewController", bundle: nil)
        orderDetailVC.orderId = dict[RES_orderID] as! String
        orderDetailVC.dictOrderDetail = dict
        orderDetailVC.isOrderDetailFromOrderHistory = true
        self.navigationController?.pushViewController(orderDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HEIGHT_ORDER_HEADER
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let orderHeader = OrderHeader(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: HEIGHT_ORDER_HEADER), orderInfo: self.arrOrders[section])
        return orderHeader
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1))
        view.backgroundColor = RGBCOLOR(190, g: 190, b: 190)
        return view
    }
    
    //MARK: ORDER DETAIL CELL DELEGATE
    func btnOrderCell_RepeatAction(_ button: UIButton) {
        self.showRechargeView(button)
    }
    
    func btnOrderCell_RetryAction(_ button: UIButton) {
        self.showRechargeView(button)
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
    
    //MARK: TEXTFIELD DELEGATE
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.hideKeyboard()
        if textField == txtOrderType {
            let dkSelection:DKSelectionView = DKSelectionView.init(frame:  UIScreen.main.bounds, arrRegion: arrOrderType, title: "Order Type", dictKey: [VK_UNIQUE_KEY:RES_orderTypeID,VK_VALUE_KEY:RES_orderTypeName])
            dkSelection.didSelecteOption(completion: { (dictOption) in
                if !dictOption.isEmpty {
                    self.btnRefreshOrderList.isHidden = false
                    self.dictSelectedPartner = dictOption
                    self.txtOrderType.text = dictOption[RES_orderTypeName] as! String?
                    self.stOrderName = (self.txtOrderType.text?.trim())!
                    self.stOrderId = self.dictSelectedPartner[RES_orderTypeID] as! String
                }
            })
        }
        else if textField == txtOrderStatus {
            let dkSelection:DKSelectionView = DKSelectionView.init(frame:  UIScreen.main.bounds, arrRegion: arrOrderStatus, title: "Order Status", dictKey: [VK_UNIQUE_KEY:RES_orderStatusID,VK_VALUE_KEY:RES_statusName])
            dkSelection.didSelecteOption(completion: { (dictOption) in
                if !dictOption.isEmpty {
                    self.btnRefreshOrderList.isHidden = false
                    self.dictSelectedPartner = dictOption
                    self.txtOrderStatus.text = dictOption[RES_statusName] as! String?
                    self.stStatusName = (self.txtOrderStatus.text?.trim())!
                    self.stStatusId = self.dictSelectedPartner[RES_orderStatusID] as! String
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

    //MARK: DATEPOPOVER DLEGATE
    
    func vkDatePopoverSelectedDate(_ vkDate: Date, strDate: String, dateType: DATE_TYPE, dateFormat: DateFormatter) {
        
        if dateType == .DATE_FROM {
            self.btnRefreshOrderList.isHidden = false
            dateFromSelected = strDate
            txtDateFrom.text = strDate
            txtDateTo.text = ""
            selectedToDate = ""
            
        }
        else if dateType == .DATE_TO {
            self.btnRefreshOrderList.isHidden = false
            selectedToDate = strDate
            txtDateTo.text = strDate
        }
    }
    
    func vkDatePopoverClearDate(_ dateType: DATE_TYPE) { }
    func vkDatePopoverSelectedDate(_ vkDate: Date, strDate: String) {}

}
