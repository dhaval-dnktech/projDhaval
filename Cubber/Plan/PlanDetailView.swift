//
//  PlanDetailView.swift
//  Cubber
//
//  Created by Vyas Kishan on 22/07/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

class PlanDetailView: UIView, UITableViewDelegate, UITableViewDataSource {

    //MARK: PROPERTIES
    @IBOutlet var tableViewDetail: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var lblNoPlanAvailble: UILabel!
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    
    fileprivate var stCategoryID: String = ""
    fileprivate var dictPlan : typeAliasDictionary!
    fileprivate var dictOperator : typeAliasDictionary!
    fileprivate var dictRegion : typeAliasDictionary!
    fileprivate var arrPlanDetail = [typeAliasDictionary]()
    fileprivate var pageSize: Int = 0
    fileprivate var totalPages: Int = 0
    fileprivate var totalRecords: Int = 0
    fileprivate var currentPage: Int = 0
    fileprivate var key:String = ""
    //MARK: VIEW METHODS
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadXIB()
    }
    
    init(frame: CGRect, categoryID: String, plan: typeAliasDictionary, operators: typeAliasDictionary, region: typeAliasDictionary) {
        super.init(frame: frame)
        self.loadXIB()
        stCategoryID = categoryID
        dictPlan = plan
        dictOperator = operators
        dictRegion = region
        key = stCategoryID
        key += self.dictRegion.isEmpty || self.dictRegion[RES_regionID] == nil ? "0" : self.dictRegion[RES_regionID] as! String
        key += self.dictOperator[RES_operatorID] as! String
        key += self.dictPlan[RES_planTypeId] as! String
    }
    
    fileprivate func loadXIB() {
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(view)
        
        //TOP
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
        
        //LEADING
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0))
        
        //WIDTH
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
        
        //HEIGHT
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
        
        self.layoutIfNeeded()
        
        self.tableViewDetail.rowHeight = UITableViewAutomaticDimension
        self.tableViewDetail.estimatedRowHeight = HEIGHT_PLAN_DETAIL_CELL
        self.tableViewDetail.tableFooterView = UIView(frame: CGRect.zero)
        self.tableViewDetail.register(UINib.init(nibName: CELL_IDENTIFIER_PLAN_DETAIL, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER_PLAN_DETAIL)
    }
    
    //MARK: CUSTOME METHODS
    
    internal func setPlanListDetail (_ pageNo: Int) {
        self.currentPage = pageNo
        if self.arrPlanDetail.isEmpty {
            
            if obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_OpratorPlanList) {
                DataModel.setPlanDetailResponse(dict: typeAliasDictionary())
                self.callPlanDetailService()
            }
            else{
                let dictPlanDetail = DataModel.getPlanDetailResponse()
                if dictPlanDetail[key] != nil {
                    let dict:typeAliasDictionary = dictPlanDetail[key] as! typeAliasDictionary
                    DataModel.setHeaderToken(dict[RES_token] as! String)
                    let arrData: Array<typeAliasDictionary> = dict[RES_data] as! Array<typeAliasDictionary>
                    self.arrPlanDetail = arrData
                    self.pageSize = Int(dict[RES_par_page] as! String)!
                    self.totalPages = Int(dict[RES_total_pages] as! String)!
                    self.totalRecords = Int(dict[RES_total_items] as! String)!
                    self.tableViewDetail.reloadData()
                    lblNoPlanAvailble.isHidden = true
                    
                }
                else  { self.callPlanDetailService() }
            }
        }
    }
    
    fileprivate func callPlanDetailService() {
        activityIndicator.startAnimating()
        
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                      REQ_PLAN_ID:self.dictPlan[RES_planTypeId] as! String,
                      REQ_CATEGORY_ID:self.stCategoryID,
                      REQ_REGION_ID:self.dictRegion.isEmpty || self.dictRegion[RES_regionID] == nil ? "0" : self.dictRegion[RES_regionID] as! String,
                      REQ_OPERATOR_ID:self.dictOperator[RES_operatorID] as! String,
                      REQ_PAGE_NO:"\(self.currentPage)"]
        obj_OperationWeb.callRestApi(methodName: JMETHOD_OpratorPlanList, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: UIView.init(), onSuccess: { (dict) in
            
                self.activityIndicator.stopAnimating()
                DataModel.setHeaderToken(dict[RES_token] as! String)
                let arrData: Array<typeAliasDictionary> = dict[RES_data] as! Array<typeAliasDictionary>
                self.arrPlanDetail += arrData
                self.pageSize = Int(dict[RES_par_page] as! String)!
                self.totalPages = Int(dict[RES_total_pages] as! String)!
                self.totalRecords = Int(dict[RES_total_items] as! String)!
                self.tableViewDetail.reloadData()
            
            if self.currentPage == 1 {
                var dictPlanDetail = DataModel.getPlanDetailResponse()
                dictPlanDetail[self.key] = dict as AnyObject?
                DataModel.setPlanDetailResponse(dict: dictPlanDetail)
                
            }
            self.obj_AppDelegate.updateDictService(serviceName: JMETHOD_OpratorPlanList)

        }, onFailure: { (code, dict) in
            self.activityIndicator.stopAnimating()
            let message: String = dict[RES_message] as! String
          //  VKToast.showToast(message, toastType: VKTOAST_TYPE.FAILURE);
            self.lblNoPlanAvailble.isHidden = false
        }) {self.activityIndicator.stopAnimating()
            let _KDAlertView = KDAlertView()
            _KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return
        }
   }
    
    //MARK: UITABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return self.arrPlanDetail.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlanDetailCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_PLAN_DETAIL) as! PlanDetailCell;
        
        let dict: typeAliasDictionary = self.arrPlanDetail[(indexPath as NSIndexPath).row]
        
        cell.lblTalkTime.text = dict[RES_talkTime] as? String
        cell.lblValidity.text = dict[RES_planValidity] as? String
        cell.lblDescription.text = dict[RES_planDescription] as? String
        cell.lblAmount.text = "\(RUPEES_SYMBOL) \(dict[RES_PlanValue] as! String) "
        
        if (indexPath as NSIndexPath).row == self.arrPlanDetail.count - 1 {
            let page: Int = self.currentPage + 1
            if page <= self.totalPages {
                currentPage = page
                self.callPlanDetailService()
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    //MARK: UITABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return UITableViewAutomaticDimension }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict: typeAliasDictionary = self.arrPlanDetail[(indexPath as NSIndexPath).row]
        dict[RES_isSpelicalType] = self.dictPlan[RES_isSpelicalType];
        NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFICATION_PLAN_VIEW_SELECTION), object: dict) //POST NOTIFICATION
        obj_AppDelegate.navigationController.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { cell.separatorInset = UIEdgeInsets.zero; cell.preservesSuperviewLayoutMargins = false; cell.layoutMargins = UIEdgeInsets.zero }
}
