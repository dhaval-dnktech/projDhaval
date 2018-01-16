//
//  PlanViewController.swift
//  Cubber
//
//  Created by Vyas Kishan on 21/07/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

import UIKit

class PlanViewController: UIViewController, VKPagerViewDelegate , AppNavigationControllerDelegate  {

    //MARK: CONSTANT
    internal let TAG_PLUS:Int = 100
    
    //MARK: PROPERTIES
    @IBOutlet var _VKPagerView: VKPagerView!
    @IBOutlet var lblPlanNote: UILabel!
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate let obj_OperationWeb = OperationWeb()
    fileprivate let _KDAlertView = KDAlertView()
    
    internal var dictOperator: typeAliasDictionary!
    internal var dictRegion: typeAliasDictionary!
    internal var stCategoryID: String = ""
    fileprivate var arrPlanMenu = [typeAliasDictionary]()
    fileprivate var arrPlanDetail = [typeAliasDictionary]()
    fileprivate var key:String = ""
    var selectedTab: Int = 0
    
    //MARK: VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        key = self.stCategoryID
        key +=  self.dictRegion.isEmpty || self.dictRegion[RES_regionID] == nil ? "0" : self.dictRegion[RES_regionID] as! String
        key += self.dictOperator[RES_operatorID] as! String
        
     //   self.view.layoutIfNeeded()
        if obj_AppDelegate.checkIsCallService(serviceName: JMETHOD_PlanList) {
            DataModel.setPlanListResponse(dict: typeAliasDictionary())
             self.callPlanService()
        }
        else {
            let dictPlanList = DataModel.getPlanListResponse()
            if dictPlanList[key] != nil {
                let dict:typeAliasDictionary = dictPlanList[key] as! typeAliasDictionary
                DataModel.setHeaderToken(dict[RES_token] as! String)
                self.arrPlanMenu = dict[RES_data] as! [typeAliasDictionary]
                if !self.arrPlanMenu.isEmpty { self.createPaginationView() }
            }
            else{ self.callPlanService() }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        NotificationCenter.default.removeObserver(self)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.lblPlanNote.text = DataModel.getPlanRechargeNote()
        self.SetScreenName(name: F_BROWSEPLAN, stclass: F_BROWSEPLAN)
    }
    
    
    func setNavigationBar() {
        
        obj_AppDelegate.navigationController.setCustomTitle("Plans")
        obj_AppDelegate.navigationController.setLeftButton(title: "")
        obj_AppDelegate.navigationController.navigationDelegate = self
    }
    
    func appNavigationController_BackAction() {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    
    //MARK: CUSTOM METHODS
    fileprivate func callPlanService() {
        
        let params = [REQ_HEADER:DataModel.getHeaderToken(),
                    REQ_OPERATOR_ID:self.dictOperator[RES_operatorID] as! String,
                    REQ_REGION_ID:self.dictRegion.isEmpty || self.dictRegion[RES_regionID] == nil ? "0" : self.dictRegion[RES_regionID] as! String,
                    REQ_CATEGORY_ID:self.stCategoryID]
        obj_OperationWeb.callRestApi(methodName: JMETHOD_PlanList, methodType: METHOD_TYPE.POST, isAddToken: false, parameters: params, viewActivityParent: self.navigationController!.view, onSuccess: { (dict) in
            
                DataModel.setHeaderToken(dict[RES_token] as! String)
                self.arrPlanMenu = dict[RES_data] as! [typeAliasDictionary]
                if !self.arrPlanMenu.isEmpty { self.createPaginationView() }
            var dictPlanList = DataModel.getPlanListResponse()
            dictPlanList[self.key] = dict as AnyObject?
            DataModel.setPlanListResponse(dict: dictPlanList)
            self.obj_AppDelegate.updateDictService(serviceName: JMETHOD_PlanList)
            
        }, onFailure: { (code, dict) in
            let message: String = dict[RES_message] as! String
            self._KDAlertView.showMessage(message: message, messageType: .WARNING)
            let _ = self.navigationController?.popViewController(animated: true) 
            
        }) { self._KDAlertView.showMessage(message: MSG_ERR_RETRY, messageType: .WARNING);return }
    }
    
    fileprivate func createPaginationView() {
        
        self._VKPagerView.setPagerViewData(self.arrPlanMenu, keyName: RES_typeName)
        for i in 0..<self.arrPlanMenu.count {
            let dictPlan: typeAliasDictionary = self.arrPlanMenu[i]
            let xOrigin: CGFloat = CGFloat(i) * self._VKPagerView.scrollViewPagination.frame.width
            let tag: Int = (i + TAG_PLUS)
            let frame: CGRect = CGRect(x: xOrigin, y: 0, width: self._VKPagerView.scrollViewPagination.frame.width, height: self._VKPagerView.scrollViewPagination.frame.height)
            
            let _planDetailView = PlanDetailView(frame: frame, categoryID: self.stCategoryID, plan: dictPlan, operators: self.dictOperator, region: dictRegion)
            _planDetailView.tag = tag
            _planDetailView.translatesAutoresizingMaskIntoConstraints = false;
            self._VKPagerView.scrollViewPagination.addSubview(_planDetailView);
            
            //---> SET AUTO LAYOUT
            //HEIGHT
            self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _planDetailView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
            
            //WIDTH
            self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _planDetailView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
            
            //TOP
            self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _planDetailView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
            
            if (i == 0)
            {
                //LEADING
                self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _planDetailView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0))
            }
            else
            {
                //LEADING = SPCING BETWEEN PREVIOUS SCROLLVIEW AND CURRENT
                let viewPrevious: UIView = self._VKPagerView.scrollViewPagination.viewWithTag(tag - 1)!;
                self._VKPagerView.scrollViewPagination.addConstraint(NSLayoutConstraint(item: _planDetailView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: viewPrevious, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))
            }
            
            if (i == self.arrPlanMenu.count - 1) //This will set scroll view content size
            {
                //SCROLLVIEW - TRAILING
                self.view.addConstraint(NSLayoutConstraint(item: _planDetailView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self._VKPagerView.scrollViewPagination, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))
            }
        }
        
        self.setPlanDetail(0)
    }
    
    fileprivate func setPlanDetail(_ index: Int) {
        let _planDetailView: PlanDetailView = self._VKPagerView.scrollViewPagination.viewWithTag(index + TAG_PLUS) as! PlanDetailView
        _planDetailView.setPlanListDetail(1)
    }
    
    //MARK: VKPAGERVIEW DELEGATE
    func onVKPagerViewScrolling(_ selectedMenu: Int) {
        self.setPlanDetail(selectedMenu)
    }
}
