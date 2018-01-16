//
//  SelectOrderViewController.swift
//  Cubber
//
//  Created by dnk on 09/01/17.
//  Copyright © 2017 DNKTechnologies. All rights reserved.
//

import UIKit

class SelectOrderViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource, SelectOrderCellDelegate, AppNavigationControllerDelegate{

    //MARK: PROPERTIES
    @IBOutlet var tableViewOrders: UITableView!
    @IBOutlet var viewNoDataFound: UIView!
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate var pageSize: Int = 0
    fileprivate var totalPages: Int = 0
    fileprivate var totalRecords: Int = 0
    fileprivate var currentPage: Int = 0
    fileprivate var arrOrders = [typeAliasDictionary]()
    internal var orderTypeId:String = ""
    
    //MARK: VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentPage = 1
        self.callOrderHistoryService()
        self.tableViewOrders.rowHeight = UITableViewAutomaticDimension
        self.tableViewOrders.estimatedRowHeight = HEIGHT_ORDER_CELL
        self.tableViewOrders.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewOrders.register(UINib.init(nibName: CELL_IDENTIFIER_SELECT_ORDER, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_SELECT_ORDER)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        self.sendScreenView(name: SCREEN_PICKANORDER)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.SetScreenName(name: F_PICKORDER, stclass: F_PICKORDER)
    }
    
    //MARK: CUSTOME METHODS
    fileprivate func callOrderHistoryService() {
        
        let userInfo: typeAliasDictionary = DataModel.getUserInfo()
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_USER_ID: userInfo[RES_userID] as! String,
                      REQ_PAGE_NO:String(self.currentPage),
                      REQ_ORDER_TYPE_ID: orderTypeId]
        
        obj_OperationWeb.callRestApi(methodName: JMETHOD_ListUserOrders, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
            
            DataModel.setHeaderToken(dict[RES_token] as! String)
            let arrData: Array<typeAliasDictionary> = dict[RES_data] as! Array<typeAliasDictionary>
            self.pageSize = Int(dict[RES_par_page] as! String)!
            self.totalPages = Int(dict[RES_total_pages] as! String)!
            self.totalRecords = Int(dict[RES_total_items] as! String)!
            self.arrOrders += arrData
            self.tableViewOrders.reloadData()
            self.viewNoDataFound.isHidden = true
            
        }, onFailure: { (code, dict) in
            self.viewNoDataFound.isHidden = false
        }) {  let _KDAlertView = KDAlertView()
            _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return }
        
      }
    
  /*  fileprivate func showRechargeView(_ button: UIButton) {
        let section: Int = Int(button.accessibilityLabel!)!
        let index: Int = Int(button.accessibilityIdentifier!)!
        
        let dictOrderDetail: typeAliasDictionary = self.arrOrders[section]
        let category: Int = dictOrderDetail[RES_operatorCategoryMasterId] as! Int
        let arrItems: Array<typeAliasDictionary> = dictOrderDetail[RES_items] as! Array<typeAliasDictionary>
        let dictItem: typeAliasDictionary = arrItems[index]
        
        let rechargeVC = RechargeViewController(nibName: "RechargeViewController", bundle: nil)
        
        if category == VAL_MOBILE
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
            rechargeVC.cart_Extra1 = dictItem[RES_EXTRA1] as! String
            rechargeVC.cart_Extra2 = dictItem[RES_EXTRA2] as! String
            rechargeVC._RECHARGE_TYPE = RECHARGE_TYPE.MOBILE_RECHARGE
        }
        self.navigationController?.pushViewController(rechargeVC, animated: true)
    }*/
    
    //MARK: - APP NAVIGATION CONTROLLER DELEGATE
    fileprivate func setNavigationBar() {
        obj_AppDelegate.navigationController.setCustomTitle("Pick an order")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ =  self.navigationController?.popViewController(animated: true)
    }

    
    //MARK: UITABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int { return self.arrOrders.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return self.arrOrders[section][RES_items]!.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SelectOrderCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_SELECT_ORDER) as! SelectOrderCell;
        cell.delegate = self
        
        let dictOrder: typeAliasDictionary = self.arrOrders[(indexPath as NSIndexPath).section]
        let arrItems: Array<typeAliasDictionary> = dictOrder[RES_items] as! Array<typeAliasDictionary>
        let dictItem: typeAliasDictionary = arrItems[(indexPath as NSIndexPath).row]
        let orderTypeId: Int = (Int(dictOrder[RES_orderTypeID] as! String))!
        let itemStatus: Int = (Int(dictItem[RES_orderStatusID] as! String))!
        
        cell.btnSelect.accessibilityIdentifier = String(indexPath.section)
        cell.lblItemTitle.text = dictItem[RES_title] as? String
        var bgColor: UIColor = UIColor.clear
        var textColor: UIColor = UIColor.white
        
        if orderTypeId == RECHARGE_TYPE.MEMBERSHIP_FEES.rawValue {

            if itemStatus == ORDER_STATUS.SUCCESS.rawValue { bgColor = COLOUR_ORDER_STATUS_SUCCESS }
            else if itemStatus == ORDER_STATUS.FAILED.rawValue { bgColor = COLOUR_ORDER_STATUS_FAILURE }
            else if itemStatus == ORDER_STATUS.AWAITING.rawValue { bgColor = COLOUR_ORDER_STATUS_AWAITING }
            else if itemStatus == ORDER_STATUS.FAILED.rawValue { bgColor = COLOUR_ORDER_STATUS_FAILURE }
            else if itemStatus == ORDER_STATUS.PROCESSING.rawValue { bgColor = COLOUR_ORDER_STATUS_PROCESSING }
            else if itemStatus == ORDER_STATUS.REFUNDED.rawValue { bgColor = COLOUR_ORDER_STATUS_REFUNDED; textColor = UIColor.white
            }
        }
        else {
            if itemStatus == ORDER_STATUS.SUCCESS.rawValue {
                bgColor = COLOUR_ORDER_STATUS_SUCCESS
            }
            else if itemStatus == ORDER_STATUS.FAILED.rawValue {
                bgColor = COLOUR_ORDER_STATUS_FAILURE
            }
            else if itemStatus == ORDER_STATUS.AWAITING.rawValue {
                bgColor = COLOUR_ORDER_STATUS_AWAITING
            }
            else if itemStatus == ORDER_STATUS.PROCESSING.rawValue {
                bgColor = COLOUR_ORDER_STATUS_PROCESSING
            }
            else if itemStatus == ORDER_STATUS.REFUNDED.rawValue {
                bgColor = COLOUR_ORDER_STATUS_REFUNDED
                textColor = UIColor.white
            }
            else {
            }
        }
        
        var stStatus: String = dictItem[RES_orderStatus] as! String
        stStatus = " \(stStatus.trim().uppercased()) "
        cell.btnSelect.setTitleColor(bgColor, for: UIControlState.normal)
        cell.btnSelect.layer.borderColor = bgColor.cgColor
        cell.btnItemStatus.setTitle(stStatus, for: UIControlState())
        cell.btnItemStatus.backgroundColor = bgColor
        cell.btnItemStatus.setTitleColor(textColor, for: UIControlState.normal)
        cell.lblAmount.text = "\(RUPEES_SYMBOL) \(dictItem[RES_displayTotal] as! String)"
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
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    //MARK: UITABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return UITableViewAutomaticDimension }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero }
    
  /*  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict: typeAliasDictionary = self.arrOrders[(indexPath as NSIndexPath).section]
        let orderDetailVC = OrderDetailViewController(nibName: "OrderDetailViewController", bundle: nil)
        orderDetailVC.dictOrderDetail = dict
        orderDetailVC.orderId = dict[RES_orderID] as! String
        orderDetailVC.isOrderDetailFromOrderHistory = true
        self.navigationController?.pushViewController(orderDetailVC, animated: true)
    }*/
    
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
    func btnSelectOrderCell_SelectAction(_ button: UIButton) {
        
        let ind = Int(button.accessibilityIdentifier!)
        let dictOrder = arrOrders[ind!]
        let dictItem = dictOrder[RES_items]?.lastObject
        let registerProblemVC = RegisterProblemViewController(nibName: "RegisterProblemViewController", bundle: nil)
        registerProblemVC.OrderItems = dictItem as! typeAliasDictionary
        registerProblemVC.orderTypeId = dictOrder[RES_orderTypeID] as! String
        
         self.navigationController?.pushViewController(registerProblemVC, animated: true)
        
    }
    
}
